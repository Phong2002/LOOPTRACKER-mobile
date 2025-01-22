import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../controllers/rider/map_tracking_controller.dart';

class MapWithRouting extends StatelessWidget {
  final MapControllerX mapControllerX = Get.find();
  final MapController flutterMapController = MapController();

  final RxBool isMapReady = false.obs; // Trạng thái bản đồ đã sẵn sàng

  MapWithRouting({Key? key}) : super(key: key) {
    // Lắng nghe thay đổi của currentLocation và kiểm tra isTracking
    mapControllerX.currentLocation.listen((location) {
      if (isMapReady.value && location != null && mapControllerX.isTracking.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (flutterMapController.mapEventSink != null) { // Đảm bảo controller tồn tại
            flutterMapController.move(location, 18.0);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (mapControllerX.currentLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return FlutterMap(
          mapController: flutterMapController,
          options: MapOptions(
            center: mapControllerX.currentLocation.value,
            zoom: 18.0,
            maxZoom: 20.0,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                mapControllerX.isTracking.value = false;
              }
            },
            onMapReady: () {
              isMapReady.value = true; // Đánh dấu bản đồ đã sẵn sàng
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: mapControllerX.routePoints,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                ...mapControllerX.waypoints.map((waypoint) {
                  return Marker(
                    point: waypoint.location,
                    builder: (ctx) => GestureDetector(
                      onTap: () => _showWaypointInfo(context, waypoint),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  );
                }).toList(),
                if (mapControllerX.currentLocation.value != null)
                  Marker(
                    point: mapControllerX.currentLocation.value!,
                    builder: (ctx) => const Icon(
                      Icons.my_location_outlined,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (isMapReady.value) {
                mapControllerX.isTracking.value = true;
                if (mapControllerX.currentLocation.value != null) {
                  flutterMapController.move(
                    mapControllerX.currentLocation.value!,
                    18.0,
                  );
                }
              }
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }

  void _showWaypointInfo(BuildContext context, Waypoint waypoint) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(waypoint.name),
          content: Text(waypoint.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}