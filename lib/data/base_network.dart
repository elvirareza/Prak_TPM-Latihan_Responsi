import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_responsi/model/follow_model.dart';
import 'package:latihan_responsi/model/repo_model.dart';
import 'package:latihan_responsi/model/user_model.dart';

Future getUser(String username) async {
  final response = await http
      .get(Uri.parse('https://api.github.com/users/$username'));

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);

    User user = User(
        username: jsonData['login'],
        name: jsonData['name'],
        ava: jsonData['avatar_url'],
        followers: jsonData['followers'],
        following: jsonData['following'],
        repos: jsonData['public_repos']
    );

    debugPrint(jsonData['login']);

    return user;
  } else {
    debugPrint('Error Response');
    throw Exception('Failed to load user');
  }
}

Future getFollow(String username, String action) async {
  final response = await http
      .get(Uri.parse('https://api.github.com/users/$username/$action'));

  if(response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    List<Follow> follows = [];

    for(var data in jsonData) {
      Follow follow = Follow(
        username: data['login'],
        ava: data['avatar_url'],
        type: data['type']
      );
      follows.add(follow);
    }

    return follows;
  } else {
    debugPrint('Error Response');
    throw Exception('Failed to load $action');
  }
}

Future getRepository(String username) async {
  final response = await http
      .get(Uri.parse('https://api.github.com/users/$username/repos'));

  if(response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    List<Repository> repositories = [];

    for(var data in jsonData) {
      Repository repository = Repository(
        name: data['name'],
      );
      repositories.add(repository);
    }

    return repositories;
  } else {
    debugPrint('Error Response');
    throw Exception('Failed to load repository');
  }
}