import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Api with ChangeNotifier {
  final _baseUrl = 'apigw.nubentos.com:443';
  final _authorization = 'api_key';
  final _bearer = 'Bearer ';
  final _subLink = '/t/nubentos.com/ncovapi/2.0.0/';

  String _numToString(int number) {
    String cases;
    if (number > 999999999) {
      cases = number.toString().substring(0, 3) + 'B+';
    } else if (number > 99999999) {
      cases = number.toString().substring(0, 2) + 'B+';
    } else if (number > 9999999) {
      cases = number.toString().substring(0, 3) + 'M+';
    } else if (number > 999999) {
      cases = number.toString().substring(0, 2) + 'M+';
    } else if (number > 99999) {
      cases = number.toString().substring(0, 3) + 'K+';
    } else if (number > 9999) {
      cases = number.toString().substring(0, 2) + 'K+';
    } else {
      cases = number.toString();
    }
    return cases;
  }

  Future<int> getAndSetToken() async {
    final header = {
      HttpHeaders.authorizationHeader: _authorization,
    };
    final response = await http.post(
        Uri.https(_baseUrl, '/token', {'grant_type': 'client_credentials'}),
        headers: header);
    final responseData = json.decode(response.body);
    final _token = responseData['access_token'];
    final int _expiry = responseData['expires_in'];
    final expiryTime =
        DateTime.now().add(Duration(seconds: _expiry)).toString();
    final storage = new FlutterSecureStorage();

    await storage.write(key: 'token', value: _token);
    await storage.write(key: 'expire', value: expiryTime);
    print(_token);
    print(_expiry);
    notifyListeners();
    return response.statusCode;
  }

  Future<void> _checkTokenExpiry() async {
    final storage = new FlutterSecureStorage();
    final expiry = DateTime.parse(await storage.read(key: 'expire'));
    if (!DateTime.now().isAfter(expiry)) {
      return;
    } else {
      await getAndSetToken();
      return;
    }
  }

  Future<Map<String, String>> _getAuthHeader() async {
    final token = await FlutterSecureStorage().read(key: 'token');
    return {
      HttpHeaders.authorizationHeader: _bearer + token,
      HttpHeaders.acceptHeader: "application/json",
    };
  }

  Future<int> _getTotalCases({String country}) async {
    final header = await _getAuthHeader();
    final response = await http.get(
        Uri.https(_baseUrl, _subLink + 'cases', {'country': country}),
        headers: header);
    final data = json.decode(response.body)[0];
    return data['data'];
  }

  Future<int> _getActiveCases({String country}) async {
    final header = await _getAuthHeader();
    final response = await http.get(
        Uri.https(_baseUrl, _subLink + 'active', {'country': country}),
        headers: header);
    final data = json.decode(response.body)[0];
    return data['data'];
  }

  Future<int> _getRecoveredCases({String country}) async {
    final header = await _getAuthHeader();
    final response = await http.get(
        Uri.https(_baseUrl, _subLink + 'recovered', {'country': country}),
        headers: header);
    final data = json.decode(response.body)[0];
    return data['data'];
  }

  Future<Map<String, int>> getCases({String country = 'World'}) async {
    await _checkTokenExpiry();
    final int response1 = await _getTotalCases(country: country);
    final int response2 = await _getActiveCases(country: country);
    final int response3 = await _getRecoveredCases(country: country);
    return {
      'total': response1,
      'active': response2,
      'recovered': response3,
    };
  }

  Future<List<String>> getTodayCasesDeaths({String country = 'World'}) async {
    await _checkTokenExpiry();
    final header = await _getAuthHeader();

    final response1 = await http.get(
        Uri.https(_baseUrl, _subLink + 'todayCases', {'country': country}),
        headers: header);
    final response2 = await http.get(
        Uri.https(_baseUrl, _subLink + 'todayDeaths', {'country': country}),
        headers: header);

    final caseData = json.decode(response1.body)[0];
    final deathData = json.decode(response2.body)[0];
    final dateString = caseData['date'];
    final dateObject = DateTime.parse(dateString);
    final String date =
        "${dateObject.day.toString().padLeft(2, '0')}/${dateObject.month.toString().padLeft(2, '0')}/${dateObject.year.toString()}";
    final String cases = _numToString(caseData['data']);
    final String deaths = _numToString(deathData['data']);
    return [cases, deaths, date];
  }

  Future<List<String>> getTestAndTestPerMillion(
      {String country = 'World'}) async {
    await _checkTokenExpiry();
    final header = await _getAuthHeader();

    final response1 = await http.get(
        Uri.https(_baseUrl, _subLink + 'totalTests', {'country': country}),
        headers: header);
    final response2 = await http.get(
        Uri.https(
            _baseUrl, _subLink + 'testsPerOneMillion', {'country': country}),
        headers: header);
    final totalTests = json.decode(response1.body)[0];
    final totalTestPerMillion = json.decode(response2.body)[0];
    final dateString = totalTests['date'];
    final dateObject = DateTime.parse(dateString);
    final String date =
        "${dateObject.day.toString().padLeft(2, '0')}/${dateObject.month.toString().padLeft(2, '0')}/${dateObject.year.toString()}";
    final String tests = _numToString(totalTests['data']);
    final String testsPerMillion = _numToString(totalTestPerMillion['data']);
    return [tests, testsPerMillion, date];
  }

  Future<List<String>> getCasesAndDeathsPerMillion(
      {String country = 'World'}) async {
    await _checkTokenExpiry();
    final header = await _getAuthHeader();

    final response1 = await http.get(
        Uri.https(
            _baseUrl, _subLink + 'casesPerOneMillion', {'country': country}),
        headers: header);
    final response2 = await http.get(
        Uri.https(
            _baseUrl, _subLink + 'deathsPerOneMillion', {'country': country}),
        headers: header);

    final totalCases = json.decode(response1.body)[0];
    final totalDeaths = json.decode(response2.body)[0];
    final dateString = totalCases['date'];
    final dateObject = DateTime.parse(dateString);
    final String date =
        "${dateObject.day.toString().padLeft(2, '0')}/${dateObject.month.toString().padLeft(2, '0')}/${dateObject.year.toString()}";
    final String cases = _numToString(totalCases['data']);
    final String deaths = _numToString(totalDeaths['data']);
    return [cases, deaths, date];
  }
}
