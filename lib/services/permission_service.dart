// permission_service.dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
    print("Location permission granted");
  } else if (status.isDenied) {
    print("Location permission denied");
  } else if (status.isPermanentlyDenied) {
    print("Location permission permanently denied. Open settings to enable.");
    await openAppSettings();
  }
}
