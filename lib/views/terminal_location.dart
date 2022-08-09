// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String user_id;
  MyMap(this.user_id, {Key? key}) : super(key: key);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Terminal Location'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if (_added) {
            //   mymap(snapshot);
            // }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: {
                Marker(
                    position: LatLng(
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == widget.user_id)['latitude'],
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == widget.user_id)['longitude'],
                    ),
                    markerId: MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta)),
              },
              
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.user_id)['latitude'],
                  snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.user_id)['longitude'],
                ),
                zoom: 14.47,
              ),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  // _added = true;
                });
              },
            );
          },
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }
}
