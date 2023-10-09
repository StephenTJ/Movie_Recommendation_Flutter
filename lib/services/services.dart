import 'package:flutter/material.dart';
import 'package:movie_recommendation/Screens/movie_detail_screen.dart';

import '../movie_apis/movies_logic.dart';

List<String> generateListOfYears() {
  List<String> years = [];
  final int currentYear = DateTime.now().year;
  for (int i = currentYear; i >= 1900; i--) {
    years.add(i.toString());
  }
  return years;
}

List<String> generateListOfPages() {
  List<String> pages = [];
  for (int i = 1; i <= 100; i++) {
    pages.add(i.toString());
  }
  return pages;
}

FutureBuilder<List<List<String>>?> get_cards_data(
    String selectedYear, String sortBy, String selectedPage) {
  return FutureBuilder<List<List<String>>?>(
    future: getByPreference(
        selectedYear == null ? "" : selectedYear.toString(),
        selectedPage == null ? "" : selectedPage.toString(),
        sortBy == null ? "" : sortBy.toString()),
    builder: (context, snapshot) {
      if (snapshot.hasData &&
          snapshot.connectionState == ConnectionState.done) {
        final data = snapshot.data!;

        // Create a ListView.builder for the outer list
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, outerIndex) {
            // Create a ListView.builder for the inner list
            return Card(
              margin: EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      data[outerIndex][0].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                          height: 300,
                          width: 300,
                          child: return_image_widget(
                              data[outerIndex][2].toString())),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                        child: MaterialButton(
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetail(
                                    id: data[outerIndex][4].toString(),
                                  ),
                                ));
                          },
                          child: Container(
                            child: Text(
                              'Open Movie',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Center(child: Container(child: CircularProgressIndicator(),height: 100,width: 100,));
      }
    },
  );
}

Widget return_image_widget(imageUrl) {
  if (imageUrl.endsWith("null")) {
    return Icon(
      Icons.image,
      size: 300,
    ); // Render an Icon if the string ends with "null"
  } else {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ));
  }
}
