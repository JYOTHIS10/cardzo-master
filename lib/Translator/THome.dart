import 'package:flutter/material.dart';
import 'TComponents.dart';

class THome extends StatelessWidget {
  THome({Key key, this.title}) : super(key: key);

  final String title;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: new TBody(),
    );
  }
}

class TBody extends StatefulWidget {
  TBody({Key key}) : super(key: key);

  @override
  _TBodyState createState() => _TBodyState();
}

class _TBodyState extends State<TBody> {
  TextEditingController getController = TextEditingController();
  TextEditingController outController = TextEditingController();
  bool fetching = false;
  bool engToMal = true;

  void translate() async {
    String s;

    if (getController.text == '') {
      setState(() {
        outController.text = 'Please enter some text';
      });
      return;
    }

    setState(() {
      fetching = true;
      outController.text = 'Translating. Please Wait... ';
    });

    if (engToMal) {
      s = await englishToMalayalam(getController.text).then((value) => value);
    } else {
      s = await malayalamToEnglish(getController.text).then((value) => value);
    }

    setState(() {
      outController.text = s;
      fetching = false;
    });
  }

  void switchTranslation() {
    print(engToMal);
    setState(() {
      engToMal = !engToMal;
      getController.text = '';
      outController.text = '';
    });
  }

  void clearText() {
    setState(() {
      getController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        children: [
          new Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 50),
            child: new Center(
              child: Text(
                engToMal ? 'English to Malayalam' : 'Malayalam To English',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          new TextField(
            controller: getController,
            maxLines: 4,
            decoration: InputDecoration(hintText: "Enter your text here"),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: new RaisedButton(
              onPressed: translate,
              child: Text('Translate'),
            ),
          ),
          new Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new RaisedButton(
                    onPressed: clearText,
                    child: Text('Clear Text'),
                  ),
                  new RaisedButton(
                    onPressed: switchTranslation,
                    child: Text(engToMal
                        ? 'Malayalam To English'
                        : 'English To Malayalam'),
                  ),
                ],
              )),
          new TextField(
            readOnly: true,
            maxLines: 4,
            controller: outController,
            decoration: InputDecoration(
              hintText: "Translation will be visible here",
            ),
          ),
          new Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: new Center(
                child: fetching ? new CircularProgressIndicator() : null,
              ))
        ],
      ),
    );
  }
}
