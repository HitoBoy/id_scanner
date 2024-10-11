import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'info_input.dart';
import 'nfc_reader_screen.dart';
import 'dart:io';

class MRZPictureScanner extends StatefulWidget {
  @override
  _MRZPictureScannerState createState() => _MRZPictureScannerState();
}

class _MRZPictureScannerState extends State<MRZPictureScanner> {
  CameraController? _controller;
  final textDetector = GoogleMlKit.vision.textDetector();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high, // Use high resolution for better MRZ detection
    );

    await _controller?.initialize();
    setState(() {});
  }

  Future<void> _takePictureAndScan() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Take the picture
      final image = await _controller!.takePicture();

      // Process the captured image for MRZ detection
      setState(() {
        isProcessing = true;
      });

      await _processCapturedImage(File(image.path));

      setState(() {
        isProcessing = false;
      });

      if (_controller != null && _controller!.value.isInitialized) {
      await _controller?.dispose();
      setState(() {
        _controller = null;  // Set to null after stopping
      });
    }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _processCapturedImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    // Process the image using ML Kit to detect text
    final RecognisedText recognisedText = await textDetector.processImage(inputImage);


    // Check if MRZ is detected
    List<String>? mrzCode = _detectMRZCode(recognisedText.text);
    if (mrzCode != null && mrzCode.isNotEmpty) {
    // MRZ is detected, stop scanning
      setState(() {
      });
      InfoInput input = InfoInput(mrzCode);

      // Navigate to a new page to display the MRZ code or handle it further
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NFCReaderScreen(infoInput: input,),
        ),
      );
    }
  }

  // This method checks for MRZ patterns
  List<String>? _detectMRZCode(String scannedText) {
    final RegExp mrzPattern = RegExp(
      r'([A-Z0-9<]{30,44})',  // MRZ lines are typically 30 to 44 characters
      caseSensitive: false,
    );
    // Find matches in the recognized text based on the MRZ pattern
    final matches = mrzPattern.allMatches(scannedText);
    
    // If there are two or more lines matching the MRZ format, return the MRZ code
    if (matches.length >= 2) {
      return matches.map((match) => match.group(0)!).toList();
    }

    return null; // Return null if no valid MRZ found
  }

  @override
  void dispose() {
    _controller?.dispose();
    textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 130, 182, 226),
      appBar: AppBar(
        title: Text('MRZ Picture Scanner'),
        backgroundColor: Colors.blue,),
      body: Column(
        children: [
          Expanded(
            child: _controller?.value.isInitialized == true
                ? CameraPreview(_controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:const Color.fromARGB(255, 177, 209, 231),
            ),
            child: ElevatedButton(
              onPressed: isProcessing ? null : _takePictureAndScan,
              child: Text(isProcessing ? 'Processing...' : 'Take Picture and Scan MRZ'),
            ),
          ),
        ],
      ),
    );
  }
}