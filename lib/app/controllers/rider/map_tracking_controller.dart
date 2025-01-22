import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:looptracker_mobile/app/controllers/auth/authentication_controller.dart';
import 'package:looptracker_mobile/app/controllers/rider/rider_infor_controller.dart';
import 'package:looptracker_mobile/app/controllers/rider/tour_instance_controller.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
      : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    return LatLng(
      begin!.latitude + (end!.latitude - begin!.latitude) * t,
      begin!.longitude + (end!.longitude - begin!.longitude) * t,
    );
  }
}

class Waypoint {
  final LatLng location;
  final String name;
  final String description;

  Waypoint({
    required this.location,
    required this.name,
    required this.description,
  });
}

class MapControllerX extends GetxController with GetSingleTickerProviderStateMixin {
  final Location _location = Location();
  final Rxn<LatLng> currentLocation = Rxn<LatLng>();
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final RxList<Waypoint> waypoints = <Waypoint>[].obs;
  final RxBool isTracking = true.obs;
  StompClient? stompClient;
  late AnimationController animationController;
  Animation<LatLng>? locationAnimation;
  final RiderInforController riderInforController =
      Get.find<RiderInforController>();
  final TourInstanceController tourInstanceController =
      Get.find<TourInstanceController>();
  final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  bool _isMapReady = false;
  Timer? _locationUpdateTimer; // Timer để cập nhật vị trí mỗi 10 giây

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this, // Sử dụng chính GetTickerProviderStateMixin làm TickerProvider
      duration: const Duration(seconds: 10),
    );

    // Thêm các waypoint mặc định
    waypoints.addAll([
      Waypoint(
        location: LatLng(22.8283, 104.9838),
        name: "Điểm xuất phát",
        description: "Điểm tập trung để xuất phát",
      ),
      Waypoint(
        location: LatLng(22.8366, 104.9784),
        name: "Điểm dừng",
        description: "điểm dừng",
      ),
      Waypoint(
        location: LatLng(22.8467, 105.0078),
        name: "Điểm đánh dấu",
        description: "Rời khỏi thành phố",
      ),
      Waypoint(
        location: LatLng(22.8698, 105.0081),
        name: "Điểm dừng",
        description: "điểm dừng chụp ảnh",
      ),
      Waypoint(
        location: LatLng(22.9806, 104.9398),
        name: "Điểm dừng",
        description: "điểm dừng chụp ảnh",
      ),
      Waypoint(
        location: LatLng(22.9949, 104.9359),
        name: "Điểm dừng",
        description: "điểm dừng chụp ảnh",
      ),
      Waypoint(
        location: LatLng(23.0185, 104.9645),
        name: "Điểm kết thúc",
        description: "kết thúc",
      ),
    ]);

    _checkLocationPermission();
    _startPeriodicLocationUpdates();
    connectToWebSocket(); // Bắt đầu cập nhật vị trí định kỳ
  }

  void connectToWebSocket() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://10.0.2.2:8080/ws',
        // URL WebSocket của backend Spring Boot
        onConnect: (StompFrame frame) {
          print("WebSocket connected!");
        },
        onDisconnect: (StompFrame frame) {
          print("WebSocket disconnected!");
        },
        onStompError: (StompFrame frame) {
          print("WebSocket error: ${frame.body}");
        },
        onWebSocketError: (dynamic error) {
          print("WebSocket connection error: $error");
        },
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
      ),
    );

    stompClient?.activate();
  }

  Future<void> _checkLocationPermission() async {
    final isServiceEnabled = await _location.serviceEnabled();
    if (!isServiceEnabled) {
      await _location.requestService();
    }

    final permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      await _location.requestPermission();
    }

    if (permissionGranted == PermissionStatus.granted) {
      _updateLocation();
    }
  }

  /// Cập nhật vị trí mỗi 10 giây
  void _startPeriodicLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 10), (_) async {
      if (!isClosed) {
        final locationData = await _location.getLocation();
        final newLocation =
            LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);

        // Cập nhật vị trí nếu khác vị trí hiện tại
        if (currentLocation.value == null ||
            currentLocation.value != newLocation) {
          print(
              "=====================UPDATE NEW LOCATION=============================");
          print(newLocation);
          sendLocationToWebSocket(
              authenticationController.userId.value,
              "${riderInforController.lastName.value} ${riderInforController.firstName.value}",
              newLocation.latitude,
              newLocation.longitude,
              tourInstanceController.tourInstanceId.value,
              authenticationController.role.value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!isClosed) {
              _moveToLocation(
                  currentLocation.value ?? newLocation, newLocation);
              currentLocation.value = newLocation;
            }
          });
        }
      }
    });
  }

  void sendLocationToWebSocket(String userId, String fullName, double lat,
      double lon, String tourInstanceId, String role) {
    if (stompClient != null && stompClient!.connected) {
      final userLocation = {
        "userId": userId,
        "fullName": fullName,
        "lat": lat.toString(),
        "lon": lon.toString(),
        "tourInstanceId": tourInstanceId,
        "role": role,
      };
      print("====================send");
      stompClient?.send(
        destination: '/app/updateLocation',
        // Trùng với @MessageMapping trong Spring Boot
        body: jsonEncode(userLocation),
      );

      print("Sent location: $userLocation");
    } else {
      print("WebSocket is not connected!");
    }
  }

  void _updateLocation() async {
    final locationData = await _location.getLocation();
    final newLocation = LatLng(locationData.latitude!, locationData.longitude!);
    currentLocation.value = newLocation;

    if (currentLocation.value != null) {
      _fetchRoute(
          [currentLocation.value!, ...waypoints.map((wp) => wp.location)]);
    }
  }

  void _moveToLocation(LatLng oldLocation, LatLng newLocation) {
    if (!isClosed) {
      final tween = LatLngTween(
        begin: oldLocation,
        end: newLocation,
      );

      locationAnimation = tween.animate(animationController)
        ..addListener(() {
          if (!isClosed) {
            currentLocation.value = locationAnimation!.value;
          }
        });

      animationController.forward(from: 0.0);
    }
  }

  Future<void> _fetchRoute(List<LatLng> stops) async {
    if (stops.length < 2) {
      return;
    }

    final coordinates =
        stops.map((stop) => '${stop.longitude},${stop.latitude}').join(';');
    final url = Uri.parse(
        'http://10.0.2.2:5000/route/v1/motorcycle/$coordinates?overview=full&geometries=geojson');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routeGeometry = data['routes'][0]['geometry']['coordinates'];
        final points = routeGeometry.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]);
        }).toList();

        routePoints.assignAll(points);
      }
    } catch (e) {
      debugPrint("Error fetching route: $e");
    }
  }

  void setMapReady() {
    _isMapReady = true;
  }

  @override
  void onClose() {
    _locationUpdateTimer?.cancel(); // Hủy Timer khi controller đóng
    animationController.stop(); // Dừng hoạt ảnh
    animationController.dispose(); // Hủy AnimationController
    _locationSubscription?.cancel(); // Hủy subscription vị trí
    super.onClose();
  }
}
