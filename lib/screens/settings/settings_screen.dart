import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../sound_manager.dart';

class SettingsScreen extends StatelessWidget {
  final bool soundEnabled;
  final Function(bool) onToggleSound;
  final SoundManager soundManager;

  SettingsScreen({
    Key? key,
    required this.soundEnabled,
    required this.onToggleSound,
    required this.soundManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings_title')),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text(AppLocalizations.of(context).translate('sound_title')),
            trailing: Switch(
              value: soundEnabled,
              onChanged: (value) {
                onToggleSound(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
