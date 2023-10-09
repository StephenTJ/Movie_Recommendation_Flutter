import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:movie_recommendation/movie_apis/movies_logic.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:movie_recommendation/services/services.dart';

import 'Screens/movie_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recommendation',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Movie Recommendation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchValue = "";
  List<String> suggestions_list_one = suggestions_list;

  final List<String> type = ['movie', 'series', 'episode'];
  String? selectedType;

  final List<String> page = generateListOfPages();
  String? selectedPage;

  final List<String> years = generateListOfYears();
  String? selectedYear;

  final List<String> sortBy = [
    "popularity.asc",
    "popularity.desc",
    "revenue.asc",
    "revenue.desc",
    "primary_release_date.asc",
    "primary_release_date.desc",
    "vote_average.asc",
    "vote_average.desc",
    "vote_count.asc",
    "vote_count.desc"
  ];
  String? selected_sortBy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
          title: Text('Movie Recommendation'),
          onSearch: (value) => setState(() {
                searchValue = value;
                getMovies(searchValue);
                suggestions_list_one = suggestions_list;
              }),
          suggestions: suggestions_list_one,
          onSuggestionTap: (suggest){
            int index=0;
            for (int i = 0; i < suggestions_list.length; i++) {
              if (suggestions_list[i] == searchValue) {
                index=i;
                break;
              }
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetail(
                    id: suggestion_id[index],
                  ),
                ));
          },
      ),
      body: Container(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("Year", style: TextStyle(fontSize: 20)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: years
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedYear,
                          onChanged: (String? value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Sort", style: TextStyle(fontSize: 20)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: sortBy
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selected_sortBy,
                          onChanged: (String? value) {
                            setState(() {
                              selected_sortBy = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Pages", style: TextStyle(fontSize: 20)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: page
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedPage,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPage = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                child: get_cards_data(
                  selectedYear == null ? "" : selectedYear.toString(),
                  selected_sortBy == null ? "" : selected_sortBy.toString(),
                  selectedPage == null ? "" : selectedPage.toString(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
