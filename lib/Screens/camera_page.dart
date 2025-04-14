import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  XFile? _capturedPhoto;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _capturePhoto() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      final XFile photo = await _cameraController.takePicture();
      setState(() {
        _capturedPhoto = photo;
      });
    } catch (e) {
      print("Error capturing photo: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: _capturePhoto,
                      child: const Icon(Icons.camera),
                    ),
                  ),
                ),
                if (_capturedPhoto != null)
                  Align(
                    alignment: Alignment.center,
                    child: FutureBuilder<Uint8List?>(
                      future: _capturedPhoto!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Image.memory(snapshot.data!);
                        } else if (snapshot.hasError) {
                          return const Text("Error loading photo");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
