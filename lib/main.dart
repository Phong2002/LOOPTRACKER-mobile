import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'app/bindings/app_bindings.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/notification_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await NotificationService().init();
  runApp(
    ScreenUtilInit(
      designSize: const Size(1080, 2400),
      builder: (context, child) {
        return  const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      title: 'LoopTracker',
      debugShowCheckedModeBanner: false,
    );
  }
}




