import 'package:dio/dio.dart';

Future<({String name, String iso2})> gessMyCountry() async {
  try {
    final resp1 = await Dio().get('https://ipapi.co/json/');
    return (
      name: resp1.data['country_name'].toString(),
      iso2: resp1.data['country_code'].toString().toUpperCase(),
    );
  } catch (_) {
    try {
      final resp2 = await Dio().get('https://api.myip.com');
      return (
        name: resp2.data['country'].toString(),
        iso2: resp2.data['cc'].toString().toUpperCase(),
      );
    } catch (_) {
      return (name: 'Belgium', iso2: 'BE');
    }
  }
}
