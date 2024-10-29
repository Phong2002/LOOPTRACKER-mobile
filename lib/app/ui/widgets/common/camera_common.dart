import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraCommon extends StatefulWidget {
  final double aspectRatio;
  final Function(Uint8List) onCapture;

  const CameraCommon({Key? key, required this.aspectRatio, required this.onCapture}) : super(key: key);

  @override
  _CameraCommonState createState() => _CameraCommonState();
}

class _CameraCommonState extends State<CameraCommon> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.low, // Use a lower resolution for faster capture
        enableAudio: false,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final XFile rawImage = await _cameraController!.takePicture();
      final Uint8List imageBytes = await rawImage.readAsBytes();
      widget.onCapture(imageBytes);
      Navigator.pop(context);
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Chụp Ảnh', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double previewWidth = constraints.maxWidth;
          final double previewHeight = constraints.maxHeight;
          double frameWidth, frameHeight;

          if (previewWidth / widget.aspectRatio > previewHeight) {
            frameHeight = previewHeight;
            frameWidth = frameHeight * widget.aspectRatio;
          } else {
            frameWidth = previewWidth;
            frameHeight = frameWidth / widget.aspectRatio;
          }

          return Stack(
            children: [
              Container(
                width: previewWidth,
                height: previewHeight,
                color: Colors.black,
              ),
              Center(
                child: CameraPreview(_cameraController!),
              ),
              Positioned(
                left: (previewWidth - frameWidth) / 2,
                top: (previewHeight - frameHeight) / 2,
                child: Container(
                  width: frameWidth,
                  height: frameHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Container(
                          width: frameWidth,
                          height: frameHeight,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Container(
                              width: frameWidth,
                              height: frameHeight,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _capturePhoto,
        backgroundColor: Colors.white,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
