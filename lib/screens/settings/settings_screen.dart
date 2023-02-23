import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../sound_manager.dart';

class SettingsScreen extends StatelessWidget {
  static final SoundManager _soundManager = SoundManager();

  const SettingsScreen({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings_title')),
      ),
      body: Column(
        children: <Widget>[
          // ...

          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text(AppLocalizations.of(context).translate('sound_title')),
            trailing: Switch(
              value: _soundManager.soundEnabled,
              onChanged: (value) {
                _soundManager.toggleSound();
              },
            ),
          ),
        ],
      ),
    );
  }
}