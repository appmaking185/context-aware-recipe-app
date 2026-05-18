import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/ecommerce_injection.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/auth_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/cart_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/connectivity_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/location_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/product_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/auth_gate.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';
import 'package:ivtexsolutionsapp/resources/fonts.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ecommerceSl<AuthProvider>()),
        ChangeNotifierProvider(
          create: (_) => ecommerceSl<ConnectivityProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => ecommerceSl<LocationProvider>()),
        ChangeNotifierProvider(create: (_) => ecommerceSl<CartProvider>()),
        ChangeNotifierProvider(create: (_) => ecommerceSl<ProductProvider>()),
      ],
      child: MaterialApp(
        title: 'IVTEX E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.appColor,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColor),
          fontFamily: AppFonts.openSansRegular,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.appColor,
            foregroundColor: Colors.white,
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

Future<void> runEcommerceApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initEcommerce();
  runApp(const EcommerceApp());
}
