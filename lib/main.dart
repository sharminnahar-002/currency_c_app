import 'package:flutter/material.dart';
import 'package:currency_converter/widgets/drop_down.dart';
import 'package:currency_converter/services/api_client.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();

  Color mainColor = const Color(0xFF212936);
  Color secondColor = const Color(0xFF2849E5);

  List<String> currencies = [];
  String from = 'USD';
  String to = 'EUR';

  double rate = 0.0;
  String result = '';
  String convertedResult = '';

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    try {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    } catch (e) {
      _handleError("An error occurred while loading currencies", e);
    }
  }

  Future<void> _convertCurrency() async {
    if (from.isNotEmpty && to.isNotEmpty && convertedResult.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        double? exchangeRate = await client.getRate(from, to);

        if (exchangeRate != null) {
          setState(() {
            result =
                (exchangeRate * double.parse(convertedResult)).toStringAsFixed(3);
          });
        } else {
          _handleError("Exchange rate is null for $from to $to", null);
          setState(() {
            result = 'Error: Exchange rate not available. Using default rate.';
          });
        }
      } catch (e) {
        _handleError("An error occurred during currency conversion", e);
        setState(() {
          result = 'Error: Unable to convert currency';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      _handleError("Please select both 'from' and 'to' currencies", null);
    }
  }

  void _handleError(String message, dynamic error) {
    print("$message: $error");
    // Handle the error as needed, e.g., log, display a user-friendly message, etc.
  }

  bool isLoading = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 124, 14, 51),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: [
                  "*Currency Converter*",
                 
                ].map((text) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    margin: const EdgeInsets.only(bottom: 50.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            convertedResult = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Input value to convert",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            color: secondColor,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: textEditingController,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customDropDown(currencies, from, (val) {
                            setState(() {
                              from = val!;
                            });
                          }),
                          FloatingActionButton(
                            onPressed: () {
                              String temp = from;
                              setState(() {
                                from = to;
                                to = temp;
                              });
                            },
                            child: const Icon(Icons.swap_horiz),
                            elevation: 0.0,
                            backgroundColor: secondColor,
                          ),
                          customDropDown(currencies, to, (val) {
                            setState(() {
                              to = val!;
                            });
                          }),
                        ],
                      ),
                      SizedBox(height: 50.0),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Result",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              result,
                              style: TextStyle(
                                color: secondColor,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.0), // Add some vertical space
                          ],
                        ),
                      ),

                      SizedBox(height: 50.0), // Add some additional vertical space

                      ElevatedButton(
                        onPressed: () {
                          if (convertedResult.isNotEmpty) {
                            _convertCurrency();
                          } else {
                            print("Please provide a valid amount to convert.");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 9, 152, 105),
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Convert',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0), // Add some additional vertical space
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



