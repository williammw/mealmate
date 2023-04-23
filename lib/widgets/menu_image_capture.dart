import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MenuImageCapture extends StatefulWidget {
  const MenuImageCapture({Key? key}) : super(key: key);

  @override
  State<MenuImageCapture> createState() => MenuImageCaptureState();
}

class MenuImageCaptureState extends State<MenuImageCapture> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _captureMenuImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Menu Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
                    File(_image!.path),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Text('No image selected'),
            ElevatedButton.icon(
              onPressed: _captureMenuImage,
              icon: const Icon(Icons.camera),
              label: const Text('Capture Menu Image'),
            ),
          ],
        ),
      ),
    );
  }
}
