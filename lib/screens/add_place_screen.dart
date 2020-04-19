import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/widgets/image_input.dart';
import 'package:great_places_app/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: <Widget>[
                    ImageInput(_selectImage),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectPlace),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Name of the place",
                      ),
                      controller: _titleController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Add place",
                style: TextStyle(fontSize: 16),
              ),
            ),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).primaryColor,
            onPressed: _savePlace,
          )
        ],
      ),
    );
  }
}
