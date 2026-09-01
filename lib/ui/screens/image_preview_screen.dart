import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/assessment_state.dart';
import '../../services/api_service.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String? imagePath;
  const ImagePreviewScreen({super.key, this.imagePath});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _hasConsent = false;

  void _onRetake(BuildContext context) {
    if (widget.imagePath != null) {
      final file = File(widget.imagePath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    context.pop();
  }

  void _onUseImage(BuildContext context) {
    if (!_hasConsent) return;
    
    if (widget.imagePath != null) {
      AssessmentState.instance.imagePath = widget.imagePath;
      final id = AssessmentState.instance.currentAssessmentId;
      if (id != null) {
        AssessmentState.instance.imageUploadFuture = ApiService().uploadImage(id, widget.imagePath!);
      }
      context.go('/questionnaire');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Review Your Image'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: widget.imagePath != null
                    ? Image.file(File(widget.imagePath!), fit: BoxFit.contain)
                    : const Center(child: Text('No image found', style: TextStyle(color: Colors.white))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Make sure the affected area is clearly visible, well lit, and in focus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: const Text(
                    'I have permission to use this image',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  value: _hasConsent,
                  activeColor: Theme.of(context).colorScheme.primary,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      _hasConsent = value ?? false;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => _onRetake(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Retake'),
                  ),
                  ElevatedButton(
                    onPressed: _hasConsent ? () => _onUseImage(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Colors.grey[800],
                      disabledForegroundColor: Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Confirm and assess'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
