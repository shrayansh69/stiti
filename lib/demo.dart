import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

class PdfModel extends ChangeNotifier {
  int currentPage = 0;
  int totalPages = 0;

  void updateTotalPages(int pages) {
    totalPages = pages;
    notifyListeners();
  }

  void nextPage() {
    currentPage++;
    notifyListeners();
  }

  void resetPage() {
    currentPage = 0;
    notifyListeners();
  }
}

class PdfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: 'assets/sample.pdf',
              onPageChanged: (page, total) {
                Provider.of<PdfModel>(context, listen: false).currentPage =
                    page!;
                Provider.of<PdfModel>(context, listen: false)
                    .updateTotalPages(total!);
              },
            ),
          ),
          Consumer<PdfModel>(
            builder: (context, pdfModel, _) => ElevatedButton(
              onPressed: () {
                if (pdfModel.currentPage < pdfModel.totalPages - 1) {
                  pdfModel.nextPage();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestScreen()),
                  );
                }
              },
              child: Text(
                pdfModel.currentPage < pdfModel.totalPages - 1
                    ? 'Next'
                    : 'Start Test',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Multiple Choice Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement your logic for displaying and handling questions
              // This is just a placeholder button
              Navigator.pop(context); // Go back to PDF screen
            },
            child: Text('Finish Test'),
          ),
        ],
      ),
    );
  }
}
