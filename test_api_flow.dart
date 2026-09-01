// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  print('Building mock image for testing...');
  final dummyImg = File('dummy.jpg');
  if (!dummyImg.existsSync()) {
    // Just an empty file for now, might fail quality checks but proves endpoint works
    dummyImg.writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00]);
  }
}
