import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  final List<LatLng> incidentLocations;
  Map(this.incidentLocations);

  @override
  Widget build(BuildContext context) {
    var markers = incidentLocations.map((latlng) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        builder: (ctx) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(
                  "Latitude = ${latlng.latitude.toString()} :: Longitude = ${latlng.longitude.toString()}"),
            ));
          },
          child: Container(
            child: Icon(
              Icons.pin_drop,
              color: Colors.red,
            ),
          ),
        ),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Calor de Incidentes'),
      ),
      body: FlutterMap(
        options: new MapOptions(
            center: new LatLng(-8.049898597727989, -34.904375418630245),
            zoom: 14.0),
        children: [
          TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayer(markers: markers)
        ],
      ),
    );
  }
}
