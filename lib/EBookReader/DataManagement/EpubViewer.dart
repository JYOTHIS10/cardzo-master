import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// epub_scroll_direction
enum EpubScrollDirection { HORIZONTAL, VERTICAL, ALLDIRECTIONS }

// util
class Util {
  static String getHexFromColor(Color color) {
    return '#${color.toString().replaceAll('ColorSwatch(', '').replaceAll('Color(0xff', '').replaceAll('MaterialColor(', '').replaceAll('MaterialAccentColor(', '').replaceAll('primary value: Color(0xff', '').replaceAll('primary', '').replaceAll('value:', '').replaceAll(')', '').trim()}';
  }

  static String getDirection(EpubScrollDirection direction) {
    switch (direction) {
      case EpubScrollDirection.VERTICAL:
        return 'vertical';
      case EpubScrollDirection.HORIZONTAL:
        return 'horizontal';
      case EpubScrollDirection.ALLDIRECTIONS:
        return 'alldirections';
      default:
        return 'alldirections';
    }
  }

  static Future<File> getFileFromAsset(String asset) async {
    final bytes = await rootBundle.load(asset);
    String dir = (await getTemporaryDirectory()).path;
    String path = join(dir, 'temp.epub');
    final buffer =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    print(buffer);
    return File(path).writeAsBytes(buffer);
  }
}

// epub_locator
class EpubLocator {
  String bookId;
  String href;
  int created;
  Locations locations;

  EpubLocator({this.bookId, this.href, this.created, this.locations});

  EpubLocator.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    href = json['href'];
    created = json['created'];
    locations = json['locations'] != null
        ? new Locations.fromJson(json['locations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookId'] = this.bookId;
    data['href'] = this.href;
    data['created'] = this.created;
    if (this.locations != null) {
      data['locations'] = this.locations.toJson();
    }
    return data;
  }
}

class Locations {
  String cfi;

  Locations({this.cfi});

  Locations.fromJson(Map<String, dynamic> json) {
    cfi = json['cfi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cfi'] = this.cfi;
    return data;
  }
}

// epub_viewer
class EpubViewer {
  static const MethodChannel _channel = const MethodChannel('epub_viewer');
  static const EventChannel _pageChannel = const EventChannel('page');

  static void setConfig(
      {Color themeColor = Colors.blue,
      String identifier = 'book',
      bool nightMode = false,
      EpubScrollDirection scrollDirection = EpubScrollDirection.ALLDIRECTIONS,
      bool allowSharing = false,
      bool enableTts = false}) async {
    Map<String, dynamic> agrs = {
      "identifier": identifier,
      "themeColor": Util.getHexFromColor(themeColor),
      "scrollDirection": Util.getDirection(scrollDirection),
      "allowSharing": allowSharing,
      'enableTts': enableTts,
      'nightMode': nightMode
    };
    await _channel.invokeMethod('setConfig', agrs);
  }

  static void open(String bookPath, {EpubLocator lastLocation}) async {
    Map<String, dynamic> agrs = {
      "bookPath": bookPath,
      'lastLocation':
          lastLocation == null ? '' : jsonEncode(lastLocation.toJson()),
    };
    await _channel.invokeMethod('open', agrs);
  }

  static Future openAsset(String bookPath, {EpubLocator lastLocation}) async {
    if (extension(bookPath) == '.epub') {
      Map<String, dynamic> agrs = {
        "bookPath": (await Util.getFileFromAsset(bookPath)).path,
        'lastLocation':
            lastLocation == null ? '' : jsonEncode(lastLocation.toJson()),
      };
      await _channel.invokeMethod('open', agrs);
    } else {
      throw ('${extension(bookPath)} cannot be opened, use an EPUB File');
    }
  }

  static Stream get locatorStream {
    Stream pageStream = _pageChannel
        .receiveBroadcastStream()
        .map((value) => Platform.isAndroid ? value : '{}');
    return pageStream;
  }
}
