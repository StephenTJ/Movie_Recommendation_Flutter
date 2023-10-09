import 'package:flutter/material.dart';
import 'package:movie_recommendation/movie_apis/movies_logic.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                MaterialButton(
                    color: Colors.grey.shade500,
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                Text("   Movie Details"),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<Widget>(
                  future: get_movie_widget(widget.id), // Pass the movie ID here
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Container(child: CircularProgressIndicator(),height: 100,width: 100,));;
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? Text('No data available');
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}
