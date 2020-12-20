import 'dart:async';
import 'dart:io';
import 'package:Cardzo/EBookReader/DataManagement/ERData.dart';
import 'package:Cardzo/EBookReader/DataManagement/EpubViewer.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

// The Business Logic Component Class
class Bloc {
  // The Stream is based on this books list
  List<EBookDetails> _eBookList = [];

  // Database instance for DB Operations
  static final dbHelper = ERDBHelper.instance;

  // Constructor - Here we set the listner operations
  Bloc() {
    _eBookDeleteAllController.stream.listen(_handleDeleteAll);
  }

  // Closing All Sinks and Streams
  void dispose() {
    _eBookListSubject.close();
    _eBookDeleteAllController.close();
  }

  // Getting books details from Databases and Puts into Stream
  List<EBookDetails> initEBookList() {
    EpubViewer.setConfig(
        themeColor: Colors.blueGrey,
        identifier: "Book",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: false,
        enableTts: true,
        nightMode: false);
    // Get books from database then converts map to object
    // Makes a list of objects
    dbHelper.getAllBooks().then((booksMapList) {
      List<EBookDetails> _bookList = booksMapList
          .map((book) => new EBookDetails.db(book['_id'], book['title'],
              book['author'], book['imagepath'], book['filename']))
          .toList();
      // Initialize to the list
      _eBookList = _bookList;
      // Put list into stream
      _eBookListSubject.add(_eBookList);
    });
    return _eBookList;
  }

// ToDo ToDo ''''''''''''''''''''''''''''''''''''''''''''
  // Importing Book and Storing details to database
  void importBook(String path) async {
    List list = await ERStore.importEbook(new File(path));
    Map<String, dynamic> data =
        await ERStore.fetchDetails(list[0], list[1]).then((value) => value);
    int val = await dbHelper.insertBooks(data);
    print('Inserted : $val');
    initEBookList();
  }

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // Opening the ebook
  void openBook(EBookDetails book) async {
    Directory booksDir = await getExternalStorageDirectories().then((value) {
      return Directory(join(value[0].path, 'Books'));
    });
    EpubViewer.open(join(booksDir.path, book.fileName));
    print(book.fileName);
  }

  // Delete All Books
  void _handleDeleteAll(List<EBookDetails> _eBookList) async {
    int val = await dbHelper.deleteAllBooks();
    Directory booksDir = (await getExternalStorageDirectories())[0];
    booksDir = Directory(join(booksDir.path, 'Books'));
    await booksDir.delete(recursive: true);
    print('Deleted $val Books');
    // Getting book details from DB and Updates Stream
    initEBookList();
  }

  // Streams
  final _eBookListSubject = BehaviorSubject<List<EBookDetails>>();
  Stream<List<EBookDetails>> eBookListStream() => _eBookListSubject.stream;

  // Sinks
  // Deleting All Ebooks From Database Controller
  final _eBookDeleteAllController = StreamController<List<EBookDetails>>();
  Sink<List<EBookDetails>> eBookDeleteAll() => _eBookDeleteAllController.sink;

  // TODO Updating Ebook Controller

  // TODO Deleting Ebook Controller
}

// BlocProvide InheritedWidget
class BlocProvider extends InheritedWidget {
  // Bloc object
  final Bloc bloc;

  BlocProvider({Key key, @required this.bloc, Widget child})
      : super(key: key, child: child);

  // Notify the widgets upon stream change
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  // For staticly using bloc object by of
  static Bloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<BlocProvider>().bloc);
}
