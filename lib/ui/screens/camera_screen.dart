import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isPermissionDenied = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onNewCameraSelected(cameraController.description);
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isPermissionDenied = false;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        // Find back camera
        _selectedCameraIndex = _cameras.indexWhere(
            (c) => c.lensDirection == CameraLensDirection.back);
        if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

        await _onNewCameraSelected(_cameras[_selectedCameraIndex]);
      }
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        setState(() {
          _isPermissionDenied = true;
        });
      }
    } catch (e) {
      // Other generic errors
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    final oldController = _controller;
    if (oldController != null) {
      _controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = cameraController;

    try {
      await cameraController.initialize();
    } catch (e) {
      if (e is CameraException && e.code == 'CameraAccessDenied') {
        setState(() {
          _isPermissionDenied = true;
        });
        return;
      }
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void _switchCamera() {
    if (_cameras.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      _isCameraInitialized = false;
      _onNewCameraSelected(_cameras[_selectedCameraIndex]);
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile file = await _controller!.takePicture();
      if (mounted) {
        context.push('/image_preview', extra: file.path);
      }
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: ${e.description}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPermissionDenied) {
      return Scaffold(
        appBar: AppBar(title: const Text('SkinSense Africa')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Camera permission denied.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Try Again'),
              )
            ],
          ),
        ),
      );
    }

    if (_cameras.isEmpty && !_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('SkinSense Africa'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isCameraInitialized && _controller != null)
            CameraPreview(_controller!),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Position the affected skin area inside the frame',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 250,
                      height: 350,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Use good lighting and avoid filters.',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 14,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                      onPressed: _cameras.length > 1 ? _switchCamera : null,
                    ),
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(width: 48), // Balancing the flex row
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your image is used only for the assessment process.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
