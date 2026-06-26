import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivtexsolutionsapp/injection_container.dart' as di;
import 'package:ivtexsolutionsapp/presentation/bloc/recipeBloc/recipe_bloc.dart';
import 'package:ivtexsolutionsapp/routes/app_router.dart';
import 'package:ivtexsolutionsapp/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await di.init();
  } catch (e) {
    debugPrint('Dependency injection initialization error: $e');
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform error: $error');
    debugPrint('Stack trace: $stack');
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<RecipeBloc>(create: (_) => di.sl<RecipeBloc>()),
          ],
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: MaterialApp.router(
                title: 'Mr. Neeraj',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routerDelegate: di.sl<AppRouter>().delegate(),
                routeInformationParser: di.sl<AppRouter>().defaultRouteParser(),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ivtexsolutionsapp/firebase_options.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('Firebase.initializeApp failed: $e\n$st');
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
*/
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hive_ce_flutter/adapters.dart';
// import 'package:ivtexsolutionsapp/resources/app_colors.dart';
// import 'package:ivtexsolutionsapp/resources/fonts.dart';
// import 'package:ivtexsolutionsapp/resources/string_resources.dart';
// import 'package:ivtexsolutionsapp/utils/local_notification.dart';
// import 'injection_container.dart' as di;
// import 'injection_container.dart';
// import 'presentation/bloc/recipeBloc/recipe_bloc.dart';
// import 'routes/app_router.dart';
// import 'data/services/meal_notification_service.dart';

// Future<void> main() async {
//   HttpOverrides.global = MyHttpOverrides(); // 👈 ADD THIS
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   await Hive.openBox('favorites');
//   await Hive.openBox('cache');
//   await LocalNotification.ensureInitialized();
//   await di.init();
//   // Ensure scheduled notifications exist even if API fails/not loaded.
//   await sl<MealNotificationService>().ensureDailyMealNotificationsScheduled();
//   runApp(const MyApp());
// }
// //
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         // systemNavigationBarColor: Colors.white, // navigation bar color
//         // statusBarColor: Colors.white, // status bar color
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     return MultiBlocProvider(
//       providers: [BlocProvider<RecipeBloc>(create: (_) => di.sl<RecipeBloc>())],
//       child: MediaQuery(
//         data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
//         child: GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () {
//             FocusScopeNode currentFocus = FocusScope.of(context);
//             if (!currentFocus.hasPrimaryFocus &&
//                 currentFocus.focusedChild != null) {
//               FocusManager.instance.primaryFocus?.unfocus();
//             }
//           },
//           child: MaterialApp.router(
//             title: StringResources.appName,
//             theme: MyAppThemes.lightTheme,
//             darkTheme: MyAppThemes.lightTheme,
//             debugShowCheckedModeBanner: false,
//             routerDelegate: di.sl<AppRouter>().delegate(),
//             routeInformationParser: di.sl<AppRouter>().defaultRouteParser(),
//             builder: EasyLoading.init(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyAppThemes {
//   static final lightTheme = ThemeData(
//     primaryColor: AppColors.appColor,
//     brightness: Brightness.light,
//     useMaterial3: false,
//     fontFamily: AppFonts.openSansRegular,
//     fontFamilyFallback: [
//       AppFonts.agrandirTextBold,
//       AppFonts.agrandirNarrow,
//       AppFonts.agrandirRegular,
//       AppFonts.openSansBold,
//       AppFonts.openSansMedium,
//       AppFonts.openSansRegular,
//     ],
//     appBarTheme: const AppBarTheme(backgroundColor: AppColors.appColor),
//     scaffoldBackgroundColor: AppColors.white,
//     bottomSheetTheme: const BottomSheetThemeData(
//       backgroundColor: Colors.transparent,
//     ),
//   );

//   static final darkTheme = ThemeData(
//     primaryColor: AppColors.appColor,
//     brightness: Brightness.dark,
//     useMaterial3: false,
//     fontFamily: AppFonts.openSansRegular,
//     fontFamilyFallback: [
//       AppFonts.agrandirTextBold,
//       AppFonts.agrandirNarrow,
//       AppFonts.agrandirRegular,
//       AppFonts.openSansBold,
//       AppFonts.openSansMedium,
//       AppFonts.openSansRegular,
//     ],
//     scaffoldBackgroundColor: AppColors.textColor1C1C28,
//     appBarTheme: const AppBarTheme(backgroundColor: AppColors.appColor),
//     bottomSheetTheme: const BottomSheetThemeData(
//       backgroundColor: Colors.transparent,
//     ),
//   );
// }
