import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_localizations.dart';
import 'screens/homepage/home_page.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            body: child,
          ),
        );
      },
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('uk', ''),
        ],
        title: 'Хрестики Нулики',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
