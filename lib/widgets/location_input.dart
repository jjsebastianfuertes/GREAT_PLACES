import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showMapPreview(double latitude, double longitude) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    bool _serviceEnabled;
    Location location = Location();
    LocationData _locationData;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    try {
      _locationData = await location.getLocation();
    } catch (err) {}
    _showMapPreview(_locationData.latitude, _locationData.longitude);
    widget.onSelectPlace(_locationData.latitude, _locationData.longitude);
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => MapScreen(
                isSelecting: true,
              )),
    );
    if (selectedLocation == null) {
      return;
    }
    _showMapPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: _previewImageUrl != null
                ? Border.all(width: 1, color: Theme.of(context).primaryColor)
                : Border.all(width: 1, color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  "No location Chosen",
                  textAlign: TextAlign.center,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _previewImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              textColor: Theme.of(context).accentColor,
              label: Text("Current location"),
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              textColor: Theme.of(context).accentColor,
              label: Text("Select on Map"),
            ),
          ],
        )
      ],
    );
  }
}
