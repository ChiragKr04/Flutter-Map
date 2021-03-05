import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as imgPick;
import 'package:path_provider/path_provider.dart' as sysPath;

class ImagePicker extends StatefulWidget {
  final Function selectImage;
  ImagePicker(this.selectImage);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  // final pickedImage = imgPick.ImagePicker();
  // Future<void> _pickImage() async {
  //   final imageFile = await pickedImage.getImage(
  //     source: imgPick.ImageSource.camera,
  //     maxWidth: 600,
  //   );
  // }
  File _storedImage;
  final picker = imgPick.ImagePicker();

  Future getImage() async {
    print("clicked");
    final pickedFile =
        await picker.getImage(source: imgPick.ImageSource.camera);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      if (pickedFile != null) {
        _storedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    final appDir = await sysPath.getTemporaryDirectory();
    final imageName = DateTime.now().toString();
    // getting system define image name
    // final fileName = path.basename(pickedFile.path);
    final savedImage = await _storedImage.copy("${appDir.path}/$imageName");
    widget.selectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text(
                  "Select Image!",
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: () {
              getImage();
            },
            icon: Icon(
              Icons.camera,
            ),
            label: Text(
              "Pick Image",
            ),
            textColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
