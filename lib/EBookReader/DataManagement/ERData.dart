import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:epub/epub.dart';

// Ebook Details Class
class EBookDetails {
  // Book Attributes
  int _id;
  String _title;
  String _author;
  String _imagePath;
  String _fileName;

  // Default Constructor
  EBookDetails(this._title, this._author, this._imagePath, this._fileName);

  // Constructor Used to get data from Database
  EBookDetails.db(
      this._id, this._title, this._author, this._imagePath, this._fileName);

  // Getters
  String get title => _title;
  String get imagePath => _imagePath;
  String get author => _author;
  int get id => _id;
  String get fileName => _fileName;

  // Setters
  set setTitle(String title) {
    _title = title;
  }

  set setAuthor(String author) {
    _author = author;
  }

  set setThumbnail(String imagePath) {
    _imagePath = imagePath;
  }

  set setFileName(String fileName) {
    _fileName = fileName;
  }

  // Convert Object to Map for Database Insertion
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': _title,
      'author': _author,
      'imagepath': _imagePath,
      'filename': _fileName
    };
  }

  // == Operator Overload
  bool operator ==(other) =>
      (other is EBookDetails) &&
      (other._id == _id) &&
      (other._title == _title) &&
      (other._imagePath == _imagePath) &&
      (other._fileName == _fileName);

  // getHash override
  int get hashCode =>
      _id.hashCode ^ _title.hashCode ^ _imagePath.hashCode ^ _fileName.hashCode;
}

// Class for Database Operations
class ERDBHelper {
  // Database and Tablenames
  static final _dbName = 'erdatabase.db';
  static final _dbVersion = 1;
  static final _booksTable = 'bookstable';

  // bookstable Column Names
  static final _idColumn = '_id';
  static final _titleColumn = 'title';
  static final _authorColumn = 'author';
  static final _imagePathColumn = 'imagepath';
  static final _fileNameColumn = 'filename';

  // Making class as singleton using Private Constructor
  ERDBHelper._privateConstructor();
  static final ERDBHelper instance = ERDBHelper._privateConstructor();

  // Creating a static Database instance
  static Database _database;

  // Used to get the static database instance
  Future<Database> get database async {
    if (_database != null) return _database;

    // Initialize database if it is not initialized
    _database = await _initDatabase();
    return _database;
  }

  // Database Creation and Initialization Function
  Future<Database> _initDatabase() async {
    // Getting the Application Documents Directory Path
    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String databasePath = join(applicationDirectory.path, _dbName);

    // Opening the database at the Path obtained
    return await openDatabase(databasePath,
        version: _dbVersion, onCreate: _onCreate);
  }

  // onCreate function used to create Books Table
  Future _onCreate(Database db, int version) async {
    // Executing the sql query for table creation
    return await db.execute(''' 
    CREATE TABLE $_booksTable ( 
      
      $_idColumn INTEGER PRIMARY KEY, 
      $_titleColumn TEXT NOT NULL, 
      $_authorColumn TEXT NOT NULL, 
      $_imagePathColumn TEXT,
      $_fileNameColumn TEXT NOT NULL
      
      )
    ''');
  }

  // Insertion - Bookstable
  Future<int> insertBooks(Map<String, dynamic> values) async {
    // getting static database instance
    Database db = await instance.database;
    // executing insertion to database
    return await db.insert(_booksTable, values);
  }

  // Get All Books - Bookstable
  Future<List<Map<String, dynamic>>> getAllBooks() async {
    Database db = await instance.database;

    return await db.query(_booksTable);
  }

  // Get Book By Title - Bookstable
  Future<List<Map<String, dynamic>>> getBooksByTitle(String title) async {
    Database db = await instance.database;

    return await db.query(_booksTable, where: 'title = ?', whereArgs: [
      title,
    ]);
  }

  // Updation - Bookstable
  Future<int> updateBooks(Map<String, dynamic> values, int id) async {
    Database db = await instance.database;

    return await db.update(_booksTable, values, where: '_id = ?', whereArgs: [
      id,
    ]);
  }

  // Deletion - Bookstable
  Future<int> deleteBooks(int id) async {
    Database db = await instance.database;

    return await db.delete(_booksTable, where: 'id = ?', whereArgs: [
      id,
    ]);
  }

  // Deletion of All Books From Database - Bookstable
  Future<int> deleteAllBooks() async {
    Database db = await instance.database;

    return await db.delete(_booksTable);
  }
}

// Managing Storing of EBook in Memory
class ERStore {
  // Function for importing file to application directory Books
  static Future<List> importEbook(File ebook) async {
    Directory dir = await getExternalStorageDirectory();

    // Creating Books directory in application directory
    Directory booksDir = new Directory(join(dir.path, 'Books'));
    await booksDir.create();

    int startIndex = ebook.path.lastIndexOf(Platform.pathSeparator) + 1;

    // Creating new File for Storing the book
    File bookFile =
        new File(join(booksDir.path, ebook.path.substring(startIndex)));
    await bookFile.create();

    // Getting the bytes from file and storing it to new file created
    // final bytes = await rootBundle.load(ebook.path);
    // final bytes = await ebook.open(mode: FileMode.read).asStream();
    final bytes = await ebook.readAsBytes();
    // final buffer =
    //     bytes.buffer.asInt8List(bytes.offsetInBytes, bytes.lengthInBytes);

    // Book Writing Successful
    await bookFile.writeAsBytes(bytes);

    print(await booksDir.list().toList());

    // Returning the EpubBook and new File as List of Two
    // in the form [EpubBook , File]
    return [
      await EpubReader.readBook(await bookFile.readAsBytes())
          .then((value) => value),
      bookFile,
    ];
  }

  static Future<Map<String, dynamic>> fetchDetails(
      EpubBook eBook, File bookFile) async {
    String _title = eBook.Title;
    String _author = eBook.Author;
    String _image;

    int startIndex = bookFile.path.lastIndexOf(Platform.pathSeparator) + 1;
    String _fileName = bookFile.path.substring(startIndex);

    return {
      'title': _title,
      'author': _author,
      'imagePath': _image,
      'fileName': _fileName
    };
  }

  // Function to delete a book from memory
  static deleteBook(File book) async {
    await book.delete();
  }
}
