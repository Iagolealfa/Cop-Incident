import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:incident/criarIncidente.dart';

LatLng localdoincidenteGlobal = LatLng(-8.049898597727989, -34.904375418630245);

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  LatLng selectedLocation = LatLng(-8.049898597727989, -34.904375418630245);

  void _handleTap(TapPosition tap, LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione a Localização'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: selectedLocation,
          zoom: 14.0,
          onTap: _handleTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: selectedLocation,
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50.0,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          localdoincidenteGlobal =
              LatLng(selectedLocation.latitude, selectedLocation.longitude);
          Navigator.pop(context, localdoincidenteGlobal);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Localização'),
              content: Text('Localização selecionada com sucesso!'),
            ),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
