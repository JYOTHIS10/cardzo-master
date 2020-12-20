import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

const APIKEY = 'bde4422ffa1068804151b4bfa9d69de2';

// Doc to PDF
class DoctoPdfHome extends StatefulWidget {
  DoctoPdfHome({Key key}) : super(key: key);

  @override
  _DoctoPdfHomeState createState() => _DoctoPdfHomeState();
}

class _DoctoPdfHomeState extends State<DoctoPdfHome> {
  String _fileName;
  String _savePath;
  File _file;
  bool _loading = false;
  bool _error = false;

  void _onPressedSelect() async {
    String path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'doc');
    print(path);
    Directory dir = await getTemporaryDirectory();
    File temp = new File(join(dir.path, 'temp.doc'));
    File actual = new File(path);
    await temp.writeAsBytes(await actual.readAsBytes());
    setState(() {
      _fileName = basenameWithoutExtension(path);
      _savePath = null;
      _file = temp;
    });
  }

  void _onPressedConvert() async {
    setState(() {
      _loading = true;
    });

    var bytes = await _file.readAsBytes();
    final fileString = base64Encode(bytes);

    Map<String, dynamic> args = {
      'apikey': APIKEY,
      'input': 'base64',
      'file': fileString,
      'filename': _fileName,
      'outputformat': 'pdf',
    };

    String url = 'https://api.convertio.co/convert';

    final res = await http
        .post(url, body: jsonEncode(args))
        .then((value) => jsonDecode(value.body));

    print(res);

    if (res['code'] == 200) {
      print('Minutes Left : ' + res['data']['minutes'].toString());
    } else {
      setState(() {
        _error = true;
      });
    }

    url = url + '/' + res['data']['id'] + '/dl';

    var content = await http.get(url).then((value) => jsonDecode(value.body));

    while (content['code'] != 200) {
      sleep(Duration(seconds: 5));
      content = await http.get(url).then((value) => jsonDecode(value.body));
    }

    Directory dir = (await getExternalStorageDirectories())[1];
    String path = join(dir.path, 'Converted');
    dir = new Directory(path);
    await dir.create();

    bytes = base64Decode(content['data']['content']);

    File temp = new File(join(dir.path, _fileName + '.pdf'));

    await temp.writeAsBytes(bytes);

    setState(() {
      _fileName = null;
      _error = false;
      _file = null;
      _loading = false;
      _savePath = temp.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Doc to PDF'),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/word.png'),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: _fileName == null
                      ? new Text('Select Word File')
                      : Text('File : $_fileName'),
                ),
                new ElevatedButton(
                    onPressed: _onPressedSelect, child: Text('Select File')),
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/pdf.png'),
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: _savePath == null
                      ? new Text('Will Be Saved at Application Directory')
                      : Text(
                          'Saved at : $_savePath',
                          textAlign: TextAlign.center,
                        ),
                ),
                _loading ? new CircularProgressIndicator() : new Container(),
                new ElevatedButton(
                    onPressed: _onPressedConvert, child: Text('Convert'))
              ]),
        ));
  }
}

// Pdf to Doc
class PdftoDocHome extends StatefulWidget {
  PdftoDocHome({Key key}) : super(key: key);

  @override
  _PdftoDocHomeState createState() => _PdftoDocHomeState();
}

class _PdftoDocHomeState extends State<PdftoDocHome> {
  String _fileName;
  String _savePath;
  File _file;
  bool _loading = false;
  bool _error = false;

  void _onPressedSelect() async {
    String path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'pdf');
    print(path);
    Directory dir = await getTemporaryDirectory();
    File temp = new File(join(dir.path, 'temp.pdf'));
    File actual = new File(path);
    await temp.writeAsBytes(await actual.readAsBytes());
    setState(() {
      _fileName = basenameWithoutExtension(path);
      _savePath = null;
      _file = temp;
    });
  }

  void _onPressedConvert() async {
    setState(() {
      _loading = true;
    });

    var bytes = await _file.readAsBytes();
    final fileString = base64Encode(bytes);

    Map<String, dynamic> args = {
      'apikey': APIKEY,
      'input': 'base64',
      'file': fileString,
      'filename': _fileName,
      'outputformat': 'doc',
    };

    String url = 'https://api.convertio.co/convert';

    final res = await http
        .post(url, body: jsonEncode(args))
        .then((value) => jsonDecode(value.body));

    print(res);

    if (res['code'] == 200) {
      print('Minutes Left : ' + res['data']['minutes'].toString());
    } else {
      setState(() {
        _error = true;
      });
    }

    url = url + '/' + res['data']['id'] + '/dl';

    var content = await http.get(url).then((value) => jsonDecode(value.body));

    while (content['code'] != 200) {
      sleep(Duration(seconds: 5));
      content = await http.get(url).then((value) => jsonDecode(value.body));
    }

    Directory dir = (await getExternalStorageDirectories())[1];
    String path = join(dir.path, 'Converted');
    dir = new Directory(path);
    await dir.create();

    bytes = base64Decode(content['data']['content']);

    File temp = new File(join(dir.path, _fileName + '.doc'));

    await temp.writeAsBytes(bytes);

    setState(() {
      _fileName = null;
      _error = false;
      _file = null;
      _loading = false;
      _savePath = temp.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('PDF to Doc'),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/pdf.png'),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: _fileName == null
                      ? new Text('Select PDF File')
                      : Text('File : $_fileName'),
                ),
                new ElevatedButton(
                    onPressed: _onPressedSelect, child: Text('Select File')),
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/word.png'),
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: _savePath == null
                      ? new Text('Will Be Saved at Application Directory')
                      : Text(
                          'Saved at : $_savePath',
                          textAlign: TextAlign.center,
                        ),
                ),
                _loading ? new CircularProgressIndicator() : new Container(),
                new ElevatedButton(
                    onPressed: _onPressedConvert, child: Text('Convert'))
              ]),
        ));
  }
}

// JPG to PNG
class JpgtoPngHome extends StatefulWidget {
  JpgtoPngHome({Key key}) : super(key: key);

  @override
  _JpgtoPngHomeState createState() => _JpgtoPngHomeState();
}

class _JpgtoPngHomeState extends State<JpgtoPngHome> {
  String _fileName;
  String _savePath;
  File _file;
  bool _loading = false;
  bool _error = false;

  void _onPressedSelect() async {
    String path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'jpg');
    print(path);
    Directory dir = await getTemporaryDirectory();
    File temp = new File(join(dir.path, 'temp.jpg'));
    File actual = new File(path);
    await temp.writeAsBytes(await actual.readAsBytes());
    setState(() {
      _fileName = basenameWithoutExtension(path);
      _savePath = null;
      _file = temp;
    });
  }

  void _onPressedConvert() async {
    setState(() {
      _loading = true;
    });

    var bytes = await _file.readAsBytes();
    final fileString = base64Encode(bytes);

    Map<String, dynamic> args = {
      'apikey': APIKEY,
      'input': 'base64',
      'file': fileString,
      'filename': _fileName,
      'outputformat': 'png',
    };

    String url = 'https://api.convertio.co/convert';

    final res = await http
        .post(url, body: jsonEncode(args))
        .then((value) => jsonDecode(value.body));

    print(res);

    if (res['code'] == 200) {
      print('Minutes Left : ' + res['data']['minutes'].toString());
    } else {
      setState(() {
        _error = true;
      });
    }

    url = url + '/' + res['data']['id'] + '/dl';

    var content = await http.get(url).then((value) => jsonDecode(value.body));

    while (content['code'] != 200) {
      sleep(Duration(seconds: 5));
      content = await http.get(url).then((value) => jsonDecode(value.body));
    }

    Directory dir = (await getExternalStorageDirectories())[1];
    String path = join(dir.path, 'Converted');
    dir = new Directory(path);
    await dir.create();

    bytes = base64Decode(content['data']['content']);

    File temp = new File(join(dir.path, _fileName + '.png'));

    await temp.writeAsBytes(bytes);

    setState(() {
      _fileName = null;
      _error = false;
      _file = null;
      _loading = false;
      _savePath = temp.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('JPG to PNG'),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/jpg.png'),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: _fileName == null
                      ? new Text('Select JPG Image')
                      : Text('File : $_fileName'),
                ),
                new ElevatedButton(
                    onPressed: _onPressedSelect, child: Text('Select File')),
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/png.png'),
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: _savePath == null
                      ? new Text('Will Be Saved at Application Directory')
                      : Text(
                          'Saved at : $_savePath',
                          textAlign: TextAlign.center,
                        ),
                ),
                _loading ? new CircularProgressIndicator() : new Container(),
                new ElevatedButton(
                    onPressed: _onPressedConvert, child: Text('Convert'))
              ]),
        ));
  }
}

// PNG to JPG
class PngtoJpgHome extends StatefulWidget {
  PngtoJpgHome({Key key}) : super(key: key);

  @override
  _PngtoJpgHomeState createState() => _PngtoJpgHomeState();
}

class _PngtoJpgHomeState extends State<PngtoJpgHome> {
  String _fileName;
  String _savePath;
  File _file;
  bool _loading = false;
  bool _error = false;

  void _onPressedSelect() async {
    String path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'png');
    print(path);
    Directory dir = await getTemporaryDirectory();
    File temp = new File(join(dir.path, 'temp.png'));
    File actual = new File(path);
    await temp.writeAsBytes(await actual.readAsBytes());
    setState(() {
      _fileName = basenameWithoutExtension(path);
      _savePath = null;
      _file = temp;
    });
  }

  void _onPressedConvert() async {
    setState(() {
      _loading = true;
    });

    var bytes = await _file.readAsBytes();
    final fileString = base64Encode(bytes);

    Map<String, dynamic> args = {
      'apikey': APIKEY,
      'input': 'base64',
      'file': fileString,
      'filename': _fileName,
      'outputformat': 'jpg',
    };

    String url = 'https://api.convertio.co/convert';

    final res = await http
        .post(url, body: jsonEncode(args))
        .then((value) => jsonDecode(value.body));

    print(res);

    if (res['code'] == 200) {
      print('Minutes Left : ' + res['data']['minutes'].toString());
    } else {
      setState(() {
        _error = true;
      });
    }

    url = url + '/' + res['data']['id'] + '/dl';

    var content = await http.get(url).then((value) => jsonDecode(value.body));

    while (content['code'] != 200) {
      sleep(Duration(seconds: 5));
      content = await http.get(url).then((value) => jsonDecode(value.body));
    }

    Directory dir = (await getExternalStorageDirectories())[1];
    String path = join(dir.path, 'Converted');
    dir = new Directory(path);
    await dir.create();

    bytes = base64Decode(content['data']['content']);

    File temp = new File(join(dir.path, _fileName + '.jpg'));

    await temp.writeAsBytes(bytes);

    setState(() {
      _fileName = null;
      _error = false;
      _file = null;
      _loading = false;
      _savePath = temp.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('PNG to JPG'),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/png.png'),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: _fileName == null
                      ? new Text('Select PNG Image')
                      : Text('File : $_fileName'),
                ),
                new ElevatedButton(
                    onPressed: _onPressedSelect, child: Text('Select File')),
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/jpg.png'),
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: _savePath == null
                      ? new Text('Will Be Saved at Application Directory')
                      : Text(
                          'Saved at : $_savePath',
                          textAlign: TextAlign.center,
                        ),
                ),
                _loading ? new CircularProgressIndicator() : new Container(),
                new ElevatedButton(
                    onPressed: _onPressedConvert, child: Text('Convert'))
              ]),
        ));
  }
}

// AZW3 to EPUB
class AzwtoEpubHome extends StatefulWidget {
  AzwtoEpubHome({Key key}) : super(key: key);

  @override
  _AzwtoEpubHomeState createState() => _AzwtoEpubHomeState();
}

class _AzwtoEpubHomeState extends State<AzwtoEpubHome> {
  String _fileName;
  String _savePath;
  File _file;
  bool _loading = false;
  bool _error = false;

  void _onPressedSelect() async {
    String path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'azw3');
    print(path);
    Directory dir = await getTemporaryDirectory();
    File temp = new File(join(dir.path, 'temp.azw'));
    File actual = new File(path);
    await temp.writeAsBytes(await actual.readAsBytes());
    setState(() {
      _fileName = basenameWithoutExtension(path);
      _savePath = null;
      _file = temp;
    });
  }

  void _onPressedConvert() async {
    setState(() {
      _loading = true;
    });

    var bytes = await _file.readAsBytes();
    final fileString = base64Encode(bytes);

    Map<String, dynamic> args = {
      'apikey': APIKEY,
      'input': 'base64',
      'file': fileString,
      'filename': _fileName,
      'outputformat': 'epub',
    };

    String url = 'https://api.convertio.co/convert';

    final res = await http
        .post(url, body: jsonEncode(args))
        .then((value) => jsonDecode(value.body));

    print(res);

    if (res['code'] == 200) {
      print('Minutes Left : ' + res['data']['minutes'].toString());
    } else {
      setState(() {
        _error = true;
      });
    }

    url = url + '/' + res['data']['id'] + '/dl';

    var content = await http.get(url).then((value) => jsonDecode(value.body));

    while (content['code'] != 200) {
      sleep(Duration(seconds: 5));
      content = await http.get(url).then((value) => jsonDecode(value.body));
    }

    Directory dir = (await getExternalStorageDirectories())[1];
    String path = join(dir.path, 'Converted');
    dir = new Directory(path);
    await dir.create();

    bytes = base64Decode(content['data']['content']);

    File temp = new File(join(dir.path, _fileName + '.epub'));

    await temp.writeAsBytes(bytes);

    setState(() {
      _fileName = null;
      _error = false;
      _file = null;
      _loading = false;
      _savePath = temp.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('AZW to EPUB'),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/png.png'),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: _fileName == null
                      ? new Text('Select AZW File')
                      : Text('File : $_fileName'),
                ),
                new ElevatedButton(
                    onPressed: _onPressedSelect, child: Text('Select File')),
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/jpg.png'),
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: _savePath == null
                      ? new Text('Will Be Saved at Application Directory')
                      : Text(
                          'Saved at : $_savePath',
                          textAlign: TextAlign.center,
                        ),
                ),
                _loading ? new CircularProgressIndicator() : new Container(),
                new ElevatedButton(
                    onPressed: _onPressedConvert, child: Text('Convert'))
              ]),
        ));
  }
}

// EPUB to AZW3
class EpubtoAzwHome extends StatefulWidget {
  EpubtoAzwHome({Key key}) : super(key: key);

  @override
  _EpubtoAzwHomeState createState() => _EpubtoAzwHomeState();
}

class _EpubtoAzwHomeState extends State<EpubtoAzwHome> {
  String _fileName;
  String _savePath;
  File _file;
  bool _loading = false;
  bool _error = false;

  void _onPressedSelect() async {
    String path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'epub');
    print(path);
    Directory dir = await getTemporaryDirectory();
    File temp = new File(join(dir.path, 'temp.epub'));
    File actual = new File(path);
    await temp.writeAsBytes(await actual.readAsBytes());
    setState(() {
      _fileName = basenameWithoutExtension(path);
      _savePath = null;
      _file = temp;
    });
  }

  void _onPressedConvert() async {
    setState(() {
      _loading = true;
    });

    var bytes = await _file.readAsBytes();
    final fileString = base64Encode(bytes);

    Map<String, dynamic> args = {
      'apikey': APIKEY,
      'input': 'base64',
      'file': fileString,
      'filename': _fileName,
      'outputformat': 'azw3',
    };

    String url = 'https://api.convertio.co/convert';

    final res = await http
        .post(url, body: jsonEncode(args))
        .then((value) => jsonDecode(value.body));

    print(res);

    if (res['code'] == 200) {
      print('Minutes Left : ' + res['data']['minutes'].toString());
    } else {
      setState(() {
        _error = true;
      });
    }

    url = url + '/' + res['data']['id'] + '/dl';

    var content = await http.get(url).then((value) => jsonDecode(value.body));

    while (content['code'] != 200) {
      sleep(Duration(seconds: 5));
      content = await http.get(url).then((value) => jsonDecode(value.body));
    }

    Directory dir = (await getExternalStorageDirectories())[1];
    String path = join(dir.path, 'Converted');
    dir = new Directory(path);
    await dir.create();

    bytes = base64Decode(content['data']['content']);

    File temp = new File(join(dir.path, _fileName + '.azw3'));

    await temp.writeAsBytes(bytes);

    setState(() {
      _fileName = null;
      _error = false;
      _file = null;
      _loading = false;
      _savePath = temp.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('EPUB to AZW'),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/png.png'),
                ),
                new Container(
                  margin: EdgeInsets.all(10),
                  child: _fileName == null
                      ? new Text('Select EPUB File')
                      : Text('File : $_fileName'),
                ),
                new ElevatedButton(
                    onPressed: _onPressedSelect, child: Text('Select File')),
                new Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/icons/jpg.png'),
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: _savePath == null
                      ? new Text('Will Be Saved at Application Directory')
                      : Text(
                          'Saved at : $_savePath',
                          textAlign: TextAlign.center,
                        ),
                ),
                _loading ? new CircularProgressIndicator() : new Container(),
                new ElevatedButton(
                    onPressed: _onPressedConvert, child: Text('Convert'))
              ]),
        ));
  }
}
