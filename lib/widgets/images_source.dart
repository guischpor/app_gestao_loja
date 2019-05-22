import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  final Color colorPink600 = Colors.pink[600];

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.camera,
                          size: 80,
                          color: colorPink600,
                        ),
                        onPressed: () async {
                          File image = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          imageSelected(image);
                        },
                      ),
                      Text(
                        'Câmera',
                        style: TextStyle(
                          color: colorPink600,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.photo_library,
                          size: 80,
                          color: colorPink600,
                        ),
                        onPressed: () async {
                          File image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          imageSelected(image);
                        },
                      ),
                      Text(
                        'Galeria',
                        style: TextStyle(
                          color: colorPink600,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  void imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        ratioX: 1.0,
        ratioY: 1.0,
      );

      onImageSelected(croppedImage);
    }
  }
}
