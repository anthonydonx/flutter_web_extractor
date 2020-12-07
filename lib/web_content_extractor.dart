library web_content_extractor;

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart'; // Contains a client for making API calls.

class WebContentExtractor {
  String _baseUrl;

  WebContentExtractor(String baseUrl) {
    this._baseUrl = baseUrl;
  }
  // <AttributeName,Selector>
  // Get all[list of attributes] attributes from single page
  Future<List<Map<String, String>>> getAttributesValuesFromUrl(String route, Map<String, String> attributes) async {
    List<Map<String, String>> resultData = [];
    Response response = await _loadPage(_baseUrl + route);
    if (response == null) {
      throw WebContentExtractor("Can't load webpage $_baseUrl+$route");
    }
    Document document = parse(response.body);
    attributes.forEach((attributeName, selector) {
      Map<String, String> tempVal = Map();
      Element element = document.querySelector(selector);
      tempVal[attributeName] = element != null ? element.innerHtml : "NA";
      resultData.add(tempVal);
    });
    return Future.value(resultData);
  }

// Get list of values from single page
  Future<List<String>> getValuesForAttibuteFromUrl(String route, String listSelector) async {
    List<String> resultData = List();
    Response response = await _loadPage(_baseUrl + route);
    if (response == null) {
      throw WebContentExtractor("Can't load webpage $_baseUrl+$route");
    }
    Document document = parse(response.body);
    List<Element> element = document.querySelectorAll(listSelector); // select list of elements
    element.forEach((element) {
      resultData.add(element.innerHtml != null ? element.innerHtml : "NA");
    });

    return Future.value(resultData);
  }

  // attributes map = <AttributeName,Selector>
  // Get all[list of attributes] attributes from provided HTML string
  Future<List<Map<String, String>>> getValuesForAttibuteFromHtml(String html, Map<String, String> attributes) async {
    List<Map<String, String>> resultData = [];
    if (html == null) {
      throw WebContentExtractor("HTML can not be null");
    }
    Document document = parse(html); // pass html string as a document
    attributes.forEach((attributeName, selector) {
      Map<String, String> tempVal = Map();
      Element element = document.querySelector(selector); // select div
      tempVal[attributeName] = element != null ? element.innerHtml : "NA";
      resultData.add(tempVal);
    });
    return Future.value(resultData);
  }

  Future<Response> _loadPage(String url) async {
    var client = Client();
    Response response = await client.get(url);
    return Future.value(response);
  }
}
