import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';
import '../models/place.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageURL;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageURL = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(
        locData.latitude,
        locData.longitude,
      );
      widget.onSelectPlace(
        locData.latitude,
        locData.longitude,
      );
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    try {
      final locData = await Location().getLocation();
      final selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => MapScreen(
            initialLocation: PlaceLocation(
              latitude: locData.latitude,
              longitude: locData.longitude,
            ),
            isSelecting: true,
          ),
        ),
      );
      if (selectedLocation == null) {
        return;
      }
      _showPreview(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
      widget.onSelectPlace(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
    } catch (error) {
      print('lol');
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageURL == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(
                  Icons.map,
                  color: Colors.blueAccent,
                ),
                label: Text('Select on Map'),
                textColor: Theme.of(context).primaryColor),
          ],
        )
      ],
    );
  }
}
