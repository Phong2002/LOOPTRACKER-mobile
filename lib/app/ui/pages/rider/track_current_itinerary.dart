import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'easy_rider/easy_rider_trip.dart';
import 'map_with_routing.dart';

class TrackCurrentItinerary extends StatefulWidget {
  @override
  _TrackCurrentItineraryState createState() => _TrackCurrentItineraryState();
}

class _TrackCurrentItineraryState extends State<TrackCurrentItinerary> {
  double initialHeightFraction = 0.8;
  double minHeightFraction = 0.5;
  double maxHeightFraction = 0.8;
  double currentHeightFraction = 0.8;

  @override
  void initState() {
    super.initState();
    currentHeightFraction = initialHeightFraction;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          // Top section (Flexible Header)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: screenHeight * currentHeightFraction,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: MapWithRouting(
              // waypoints: [
              //   LatLng(21.028511, 105.804817), // Hà Nội
              //   LatLng(21.003117, 105.820305), // Điểm dừng 1
              //   LatLng(20.998117, 105.795305), // Điểm dừng 2
              // ],
            ),
          ),

          // Separator section
          Positioned(
            top: screenHeight * currentHeightFraction - 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(3.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom section (DraggableScrollableSheet)
          DraggableScrollableSheet(
            initialChildSize: 1 - initialHeightFraction,
            minChildSize: 1 - maxHeightFraction,
            maxChildSize: 1 - minHeightFraction,
            builder: (BuildContext context, ScrollController scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  setState(() {
                    currentHeightFraction = 1 - notification.extent;
                  });
                  return true;
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Draggable handle
                      // Content of the bottom section
                      Flexible(  // Wrap the content in Flexible or Expanded
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Icon(
                                  Icons.drag_handle,
                                  size: 32,
                                  color: Colors.grey[400],
                                ),
                              ),
                              EasyRiderTrip(),
                            ],
                          ), // Display the EasyRiderTrip screen here
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
