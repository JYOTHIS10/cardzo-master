import 'package:flutter/material.dart';

//Main App drawer it display on left-Top corner of app
class DocDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeData.dark().canvasColor,
          child: Image.asset('lib/DocScanner/Model/images/ic_launcher.png'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("About this App"),
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text("Share this App"),
        )
      ],
    );
  }
}
