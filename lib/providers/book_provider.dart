import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//Import pakage for flutter_dotenv
import 'package:flutter_dotenv/flutter_dotenv.dart';
//Import http
import 'package:http/http.dart' as http;
//Import book model
import 'package:flutter_bookshop_lab_1/models/book.dart';

class BookProvider {
  Future<List<Book>> getBooks() async {
    //Using dotenv for API_URL
    String url = '${dotenv.env['API_URL']}books';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      "Authorization": "bearer $token"
    };

    //Using http to get book data
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return List<Book>.from(
          jsonDecode(response.body)['data'].map((bk) => Book.fromJson(bk)));
    } else {
      throw Exception('Faild to load books');
    }
  }

  Book findByBookId(int bookId, List<Book> items) {
    //Find book by BookId
    return items.firstWhere((bk) => bk.bookId == bookId);
  }

  List<Book> findBookTitle(String searchTitle, List<Book> items) {
    //Find book by Title
    return items
        .where(
            (bk) => bk.title.toLowerCase().contains(searchTitle.toLowerCase()))
        .toList();
  }
}
