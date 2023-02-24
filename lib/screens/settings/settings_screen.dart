import 'package:flutter/material.dart';
import 'package:test1/app_localizations.dart';
import 'package:test1/sound_manager.dart';

class SettingsScreen extends StatefulWidget {
  final SoundManager soundManager;

  SettingsScreen({required this.soundManager});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings_title')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context).translate('settings_sound')),
            value: widget.soundManager.soundEnabled,
            onChanged: (value) {
              setState(() {
                widget.soundManager.toggleSound();
              });
            },
          ),
        ],
      ),
    );
  }
}
