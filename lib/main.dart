import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test1/screens/tictactoe/tictactoe_screen.dart';
import 'package:test1/sound_manager.dart';
import 'app_localizations.dart';
import 'screens/homepage/home_page.dart';
import 'screens/settings/settings_screen.dart';
import '../../sound_manager.dart';

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
  late bool _soundEnabled = true;

  late Function(bool) _toggleSound;

  @override
  void initState() {
    super.initState();
    _soundManager = SoundManager();
    _toggleSound = (bool isEnabled) {
      setState(() {
        _soundEnabled = isEnabled;
      });
    };
  }

  void _playClickSound() async {
    await _soundManager.playSound('assets/sounds/zapsplat_multimedia_button_click_bright_001_92098.mp3');
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
            '/': (context) => HomePage(
                onPlayClickSound: _playClickSound,
                onPlayLoseSound: _playClickSound,
                onPlayWinSound: _playClickSound,
              soundManager: _soundManager,
            ),
            '/settings': (context) => SettingsScreen(soundManager: _soundManager),
            '/tictactoe': (context) => TicTacToeScreen(),
          },
        );
      },
    );
  }
}

