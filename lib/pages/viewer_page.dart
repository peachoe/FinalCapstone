import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthomeui/util/user_provider.dart';

class ViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Viewer Mode (${user?.name})'),
      ),
      body: Center(
        child: Text('Viewer Mode Page'),
      ),
    );
  }
}