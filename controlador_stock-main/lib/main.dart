import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockcontrollerterminal/Utils/Theme/themes.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/departments/presentation/widgets/screen.dart';
import 'package:stockcontrollerterminal/features/employee_creator/product_creator_presentation/Widgets/Screen.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/Widgets/Screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Dependencies.startDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => Dependencies.productCreatorPresentatorManager),
        Provider(create: (_) => Dependencies.departmentPresentationManager),
        Provider(create: (_) => Dependencies.productViewerPresentationManager),
        Provider(create: (_) => Dependencies.stockChangerPresentationManager),
        Provider(
            create: (_) =>
                Dependencies.productReportCreatorPresentationManager),
        Provider(
            create: (_) => Dependencies.departmentReportPresentatorManager),
      ],
      child: FluentApp(
        initialRoute: TabBarSystemView.routeName,
        routes: {
          ProductViewerScreen.routeName: (context) =>
              const ProductViewerScreen(),
          ProductCreatorScreen.routeName: (context) =>
              const ProductCreatorScreen(),
          DepartmentScreen.routeName: (context) => const DepartmentScreen(),
          TabBarSystemView.routeName: (context) => const TabBarSystemView(),
        },
        home: MultiProvider(
          providers: [
            Provider(
                create: (_) => Dependencies.productCreatorPresentatorManager),
            Provider(create: (_) => Dependencies.departmentPresentationManager),
            Provider(
                create: (_) => Dependencies.productViewerPresentationManager),
            Provider(
                create: (_) => Dependencies.stockChangerPresentationManager),
            Provider(
                create: (_) =>
                    Dependencies.productReportCreatorPresentationManager),
            Provider(
                create: (_) => Dependencies.departmentReportPresentatorManager),
          ],
          child: const TabBarSystemView(),
        ),
      ),
    );
  }
}
