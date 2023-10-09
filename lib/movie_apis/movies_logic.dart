import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_recommendation/services/services.dart';

final dio = Dio();
List<String> suggestions_list = [];
List<String> suggestion_id=[];
var current_page=0;


List<List<String>> cards_data=[];

void getMovies(String movie_name) async {
  String url_request = "https://api.themoviedb.org/3/search/movie?query="+movie_name+"&api_key=d8c611217ff7ed44a1597cdfe5d520e7";
  final response = await dio.get(url_request);
  print(response);
  Map<String, dynamic> data = json.decode(response.toString());
  // print(data);

  try {
    var data_two = data['results'];
    // print(data_two); // This will print the entire list of movies
    suggestions_list.clear();
    suggestion_id.clear();
    for (final x in data_two) {
      // Iterate through the map and print each item
      print(x['original_title']);
      suggestion_id.add(x['id'].toString());
      suggestions_list.add(x['original_title'].toString());
    }
    print(suggestions_list);
  } catch (e) {
    // Handle any exceptions here
    print(e);
  }
}

Future<Widget> get_movie_widget(String movie_id) async {

  String url_request = "https://api.themoviedb.org/3/movie/"+movie_id.toString()+"?api_key=d8c611217ff7ed44a1597cdfe5d520e7";


  final response = await dio.get(url_request);
  print(response);
  Map<String, dynamic> data = json.decode(response.toString());
  Widget wid=SizedBox();
  try {
      var title=data['title'].toString();
      var overview=data['overview'].toString();
      var poster_path=data['poster_path'].toString();
      var rating=data['vote_average'].toString();
      var image_path="https://image.tmdb.org/t/p/w500/"+poster_path.toString();
      wid=SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title,style: TextStyle(
                    fontSize: 30
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: return_image_widget(image_path),
              ),
              Text(rating,style: TextStyle(
                  fontSize: 30
              )),


                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     children: [
                       Text("Overview",style: TextStyle(
                          fontSize: 20
                )),
                     ],
                   ),
                 ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(overview,style: TextStyle(
                    fontSize: 15
                )),
              )
            ],
          ),
      );
  } catch (e) {
    // Handle any exceptions here
    print(e);
  }
  return wid;
}

Future<List<List<String>>> getByPreference(String year,String page,String sortBy) async {
  if(year==""){
    year="2023";
  }

  String url_request = "https://api.themoviedb.org/3/discover/movie?&api_key=d8c611217ff7ed44a1597cdfe5d520e7&page="+page.toString()+"&primary_release_year="+year.toString()+"&sort_by="+sortBy.toString();


  final response = await dio.get(url_request);
  print(response);
  Map<String, dynamic> data = json.decode(response.toString());
  print(data);
  try {
    var data_two = data['results'];
    current_page=data['total_pages'];
    // print(data_two); // This will print the entire list of movies
    cards_data.clear();
    for (final x in data_two) {
      // Iterate through the map and print each item
      var title=x['title'];
      var sub_title=x['overview'];
      var poster_path=x['poster_path'];
      var release_date=x['release_date'];
      var movie_id=x['id'];
      var image_path="https://image.tmdb.org/t/p/w500/"+poster_path.toString();
      List<String> s=[];
      s.add(title.toString());
      s.add(sub_title.toString());
      s.add(image_path.toString());
      s.add(release_date.toString());
      s.add(movie_id.toString());
      cards_data.add(s);
    }
    print(suggestions_list);
  } catch (e) {
    // Handle any exceptions here
    print(e);
  }
  print(cards_data);
  return cards_data;
}
