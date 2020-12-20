import 'package:Cardzo/DocScanner/Providers/documentProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DSHome.dart';

//Doc Scanner Main Class
class Scanner extends StatefulWidget {
  Scanner({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScannerState createState() => _ScannerState();
}


class _ScannerState extends State<Scanner> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DocumentProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.green),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.green)),

        home: DSHome(), //Go to Doc Scanner main page
      ),
    );
  }
}
