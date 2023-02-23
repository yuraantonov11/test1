import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test1/sound_manager.dart';
import 'app_localizations.dart';
import 'screens/homepage/home_page.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SoundManager _soundManager;

  @override
  void initState() {
    super.initState();
    _soundManager = SoundManager();
  }

  void _playClickSound() async {
    await _soundManager.playSound('assets/sounds/click.mp3');
  }

  // ...

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
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
            '/': (context) => HomePage(onPlayClickSound: _playClickSound),
            '/settings': (context) => SettingsScreen(
              soundEnabled: _soundEnabled,
              onToggleSound: _toggleSound,
            ),
          },
        );
      },
    );
  }
}

