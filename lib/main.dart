import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/add_place_screen.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:great_places_app/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.purple,
          inputDecorationTheme: InputDecorationTheme(
            focusColor: Colors.purple,
            fillColor: Theme.of(context).accentColor,
            labelStyle: TextStyle(
              color: Colors.purple,
            ),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.purple),
            ),
          ),
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
