import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    selectedPlace.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Text(
                    selectedPlace.location.address,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.location_on),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'View on Map',
                style: TextStyle(fontSize: 16),
              ),
            ),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => MapScreen(
                  initialLocation: selectedPlace.location,
                  isSelecting: false,
                ),
              ));
            },
          )
        ],
      ),
    );
  }
}
