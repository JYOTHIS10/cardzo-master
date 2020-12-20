import 'package:flutter/material.dart';
import 'DTComponents/DTComponents.dart';

class HomeButtons {
  // Card Buttons In Home of Doc Tools
  Widget homeGridButton(
      String label, dynamic icon, BuildContext context, home) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => home,
            ));
      },
      child: new Card(
        margin: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        child: new Container(
          height: 100,
          width: 100,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Padding(
                padding: EdgeInsets.all(10),
                child: new Icon(icon),
              ),
              new Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
