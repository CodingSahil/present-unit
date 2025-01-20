import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:present_unit/routes/route_generator.dart';

import 'binding/store_bindings.dart';
import 'firebase_options.dart';

// Platform  Firebase App Id
// android   1:92580548493:android:b649ab00e3cc91a2aef7c4
// ios       1:92580548493:ios:a1c8d48e59cc503aaef7c4
// macos     1:92580548493:ios:a1c8d48e59cc503aaef7c4

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  /// todo add authentication
  final LocalAuthentication localAuthentication = LocalAuthentication();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(
        720,
        1520,
      ),
      builder: (context, child) {
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PresentUnit App',
          initialBinding: StoreBinding(),
          onGenerateRoute: RouteGenerator.onGenerate,
        );
      },
    );
  }
}
