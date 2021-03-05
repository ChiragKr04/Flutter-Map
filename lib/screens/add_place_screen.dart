import 'dart:io';

import 'package:flutter/material.dart';
import 'package:native_device_cide/provides/user_places.dart';
import 'package:native_device_cide/widgets/image_picker.dart';
import 'package:native_device_cide/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place-screen';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  var _titleController = TextEditingController();
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }
    Provider.of<UserPlaces>(context, listen: false).addPlace(
      _pickedImage,
      _titleController.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add new place",
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Form(
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImagePicker(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            child: RaisedButton.icon(
              color: Theme.of(context).accentColor,
              elevation: 0,
              onPressed: _savePlace,
              icon: Icon(Icons.add),
              label: Text("Add Place"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
