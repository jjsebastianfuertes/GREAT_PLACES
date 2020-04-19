import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storeImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storeImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: _storeImage != null
                  ? Border.all(width: 1, color: Theme.of(context).primaryColor)
                  : Border.all(width: 1, color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.circular(15)),
          child: _storeImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _storeImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
              : Text(
                  "No image taken",
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Take picture"),
            textColor: Theme.of(context).accentColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
