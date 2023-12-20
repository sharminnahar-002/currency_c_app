import 'dart:convert';
import 'package:http/http.dart' as http;

    class ApiClient {
      final Uri currencyURL = Uri.https(
          "free.currconv.com", "/api/v7/currencies",
          {"apiKey": "894b5ade7c02f687e534"});

      Future<List<String>> getCurrencies() async {
        http.Response res = await http.get(currencyURL);
        if (res.statusCode == 200) {
          var body = jsonDecode(res.body);
          var list = body["results"];
          List<String> currencies = list.keys.toList();
          print(currencies);
          return currencies;
        } else {
          throw Exception("Failed to connect to API");
        }
      }


      //getting exchange rate
      Future<double?> getRate(String from, String to) async {
        final Uri rateUrl = Uri.https(
            'free.currconv.com', '/api/v7/convert', {
          "apiKey": "894b5ade7c02f687e534",
          "q": "$from\_$to",

          "compact": "ultra"
        });

        try {
          http.Response res = await http.get(rateUrl);
          if (res.statusCode == 200) {
            var body = jsonDecode(res.body);
            // Check if the rate is available in the response
            if (body.containsKey("${from}_${to}")) {
              return body["${from}_${to}"];
            } else {
              print("Rate not found in the response");
              return null;
            }
          } else {
            print("Failed to connect to API");
            return null;
          }
        } catch (e) {
          print("Error fetching exchange rate: $e");
          return null;
        }
      }
    }
