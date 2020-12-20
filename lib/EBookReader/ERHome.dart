import 'package:flutter/material.dart';
import 'BlocManagement/ERBloc.dart';
import 'Components/ERHomeComponants.dart';
import 'DataManagement/ERData.dart';

class ERHome extends StatelessWidget {
  ERHome({Key key, this.title}) : super(key: key);

  final String title;

  Widget build(BuildContext context) {
    final Bloc bloc = new Bloc();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ebook Reader',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new BlocProvider(
        bloc: bloc,
        child: ERBody(),
      ),
    );
  }
}

class ERBody extends StatelessWidget {
  ERBody() : super();

  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return new StreamBuilder<List<EBookDetails>>(
      stream: bloc.eBookListStream(),
      initialData: bloc.initEBookList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<EBookDetails>> snapshot) {
        if (snapshot.hasData == false) {
          return new Center(
            child: Text('Loading...'),
          );
        }

        return new Scaffold(
          appBar: eRHAppBar(bloc, snapshot.data),
          body: createBooksGrid(bloc, snapshot.data),
        );
      },
    );
  }
}
