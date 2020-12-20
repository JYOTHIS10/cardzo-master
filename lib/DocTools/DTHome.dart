import 'package:flutter/material.dart';
import 'DTHomeComponents.dart';
import 'DTComponents/DTComponents.dart';

class DTHome extends StatelessWidget {
  DTHome({Key key, this.title}) : super(key: key);

  final String title;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: new DTBody(),
    );
  }
}

class DTBody extends StatelessWidget {
  DTBody() : super();

  final HomeButtons homeButtons = HomeButtons();

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            homeButtons.homeGridButton(
                'DOC to PDF', Icons.dock, context, new DoctoPdfHome()),
            homeButtons.homeGridButton(
                'PDF to DOC', Icons.dock, context, new PdftoDocHome()),
            homeButtons.homeGridButton(
                'JPG to PNG', Icons.dock, context, new JpgtoPngHome()),
          ],
        ),
        new Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            homeButtons.homeGridButton(
                'PNG to JPG', Icons.dock, context, new PngtoJpgHome()),
            homeButtons.homeGridButton(
                'AZW to EPUB', Icons.dock, context, new AzwtoEpubHome()),
            homeButtons.homeGridButton(
                'EPUB to AZW', Icons.dock, context, new EpubtoAzwHome()),
          ],
        ),
        // new Flex(
        //   direction: Axis.horizontal,
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     homeButtons.homeGridButton('Document Convertor', Icons.dock),
        //     homeButtons.homeGridButton('Document Compressor', Icons.dock),
        //     homeButtons.homeGridButton('PDF Splitter', Icons.dock),
        //   ],
        // )
      ],
    );
  }
}
