import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
=======
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
<<<<<<< HEAD
  String? _firebaseKeyPath;
  String? _googleCloudKeyPath;
=======
  TextEditingController _apiKeyController = TextEditingController();
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadKeys();
  }

  _loadKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firebaseKeyPath = prefs.getString('firebaseKeyPath');
      _googleCloudKeyPath = prefs.getString('googleCloudKeyPath');
    });
  }

  _saveKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_firebaseKeyPath != null) {
      prefs.setString('firebaseKeyPath', _firebaseKeyPath!);
    }
    if (_googleCloudKeyPath != null) {
      prefs.setString('googleCloudKeyPath', _googleCloudKeyPath!);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Keys saved successfully')),
    );
  }

  Future<void> _pickFile(bool isFirebase) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      if (isFirebase) {
        setState(() {
          _firebaseKeyPath = file.path;
        });
      } else {
        setState(() {
          _googleCloudKeyPath = file.path;
        });
      }
      _saveKeys();
    } else {
      // User canceled the picker
    }
  }

=======
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKeyController.text = prefs.getString('apiKey') ?? '';
    });
  }

  Future<void> _saveApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', _apiKeyController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('API Key saved')),
    );
  }

>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
<<<<<<< HEAD
            ListTile(
              title: Text('Firebase Key'),
              subtitle: Text(_firebaseKeyPath ?? 'No file selected'),
              trailing: ElevatedButton(
                onPressed: () => _pickFile(true),
                child: Text('Upload'),
              ),
            ),
            ListTile(
              title: Text('Google Cloud Key'),
              subtitle: Text(_googleCloudKeyPath ?? 'No file selected'),
              trailing: ElevatedButton(
                onPressed: () => _pickFile(false),
                child: Text('Upload'),
              ),
=======
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(labelText: 'Enter your OpenAI API Key'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveApiKey,
              child: Text('Save'),
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
            ),
          ],
        ),
      ),
    );
  }
}
