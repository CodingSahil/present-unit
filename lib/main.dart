import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:present_unit/routes/route_generator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'binding/store_bindings.dart';
import 'firebase_options.dart';
import 'helpers/database/supabase_client_keys.dart';

// Platform  Firebase App Id
// android   1:92580548493:android:b649ab00e3cc91a2aef7c4
// ios       1:92580548493:ios:a1c8d48e59cc503aaef7c4
// macos     1:92580548493:ios:a1c8d48e59cc503aaef7c4

bool isIOS = false;
bool isAndroid = false;
bool isDebugMode = false;
final RegExp passwordRegex = RegExp(
  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
);

final SupabaseClient supabase = SupabaseClient(SupabaseClientKeys.supabaseUrl, SupabaseClientKeys.supabaseKey);


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// todo add authentication
  // final LocalAuthentication localAuthentication = LocalAuthentication();
  // final bool canAuthenticateWithBiometrics =
  //     await localAuthentication.canCheckBiometrics;
  // final bool canAuthenticate = canAuthenticateWithBiometrics ||
  //     await localAuthentication.isDeviceSupported();
  // canAuthenticate.toString().logOnString('canAuthenticate =>');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: SupabaseClientKeys.supabaseUrl,
    anonKey: SupabaseClientKeys.supabaseKey,
  );
  // final List<BiometricType> availableBiometrics =
  // await localAuthentication.getAvailableBiometrics();
  //
  // if (availableBiometrics.isNotEmpty) {
  //   // Some biometrics are enrolled.
  // }
  //
  // if (availableBiometrics.contains(BiometricType.strong) ||
  //     availableBiometrics.contains(BiometricType.face)) {
  //   // Specific types of biometrics are available.
  //   // Use checks like this with caution!
  // }
  // try {
  //   await localAuthentication.authenticate(
  //     localizedReason: 'Please authenticate to Open PresentUnit',
  //     options: const AuthenticationOptions(
  //       biometricOnly: true,
  //     ),
  //   );
  // } on PlatformException {
  //   'PlatformException error it is'.logOnString('PlatformException');
  // }

  isIOS = GetPlatform.isIOS;
  isAndroid = GetPlatform.isAndroid;
  isDebugMode = kDebugMode;
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
