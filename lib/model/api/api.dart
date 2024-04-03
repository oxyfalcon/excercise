import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:excercise/model/user_model.dart';
import 'package:excercise/utils/config.dart';
import 'package:http/http.dart' as http;

class Api {
  static final Api _api = Api._();

  Api._();

  factory Api() => _api;
  final Uri uri =
      Uri(scheme: "https", host: "api.artic.edu", path: "api/v1/artworks");

  Future<List<UserModel>> getUserModel(int pageNumber) async {
    List<UserModel> userModelList = [];
    ConnectivityResult value = await Connectivity().checkConnectivity();
    if (value == ConnectivityResult.none) {
      return await DatabaseOperations().getUserModelFromDb(pageNumber);
    } else {
      Uri uriWithPage = uri.replace(queryParameters: {
        "page": pageNumber.toString(),
        "limit": pageNumber == 1 ? '' : 5.toString()
      });
      final http.Response response = await http.get(uriWithPage);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        for (Map<String, dynamic> i
            in (jsonResponse["data"] as List<dynamic>)) {
          userModelList.add(UserModel.fromJson(i, pageNumber));
        }
        if (pageNumber == 1) {
          await DatabaseOperations().deleteAll();
        }
        await DatabaseOperations()
            .insertUserModelToDb(userModelList, pageNumber);
        return userModelList;
      } else {
        throw ("Error in api fetching");
      }
    }
  }
}
