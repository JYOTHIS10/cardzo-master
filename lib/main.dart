import 'DocScanner/DSmain.dart';
import 'DocTools/DTHome.dart';
import 'EBookReader/ERHome.dart';
import 'Translator/THome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Cardzo());
}

// App Class
class Cardzo extends StatelessWidget {
  Cardzo({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cardzo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new CardzoHome(title: 'Cardzo - Main App'),
    );
  }
}

// App Home Page Class
class CardzoHome extends StatelessWidget {
  final String title;

  CardzoHome({this.title}) : super();
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(title)]),
          actions: <Widget>[]),
      body: new HomePage(),
    );
  }
}

// Home Activity
class HomePage extends StatelessWidget {
  HomePage() : super();

  // Navigates to Doc Scanner
  void _navToDocScanner(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Scanner(title: "Doc Scanner"),
        ));
  }

  void _navToTranslator(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new THome(title: "Translator"),
        ));
  }

  // navigate to Doc Tools
  void _navToDocTools(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new DTHome(title: 'Doc Tools'),
        ));
  }

  // navigate to EBook Reader
  void _navToEReader(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new ERHome(title: 'EBook Reader'),
        ));
  }

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Spacer(),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createButtons('Doc Scanner', _navToDocScanner, context),
            createButtons('Doc Tools', _navToDocTools, context),
            createButtons('EBook Reader', _navToEReader, context),
          ],
        ),
        new Spacer(),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createButtons('Translator', _navToTranslator, context),
            // createButtons('Doc Tools', _navToDocTools, context),
            // createButtons('EBook Reader', _navToEReader, context),
          ],
        ),
        new Spacer(),
      ],
    );
  }
}

// Returns the button in card
Widget createButtons(String label, onPress, context) {
  return new GestureDetector(
    onTap: () {
      onPress(context);
    },
    child: new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: new Container(
        height: 100,
        width: 100,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Spacer(),
            new Icon(Icons.alarm),
            new Spacer(),
            new Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            new Spacer(),
          ],
        ),
      ),
    ),
  );
}
