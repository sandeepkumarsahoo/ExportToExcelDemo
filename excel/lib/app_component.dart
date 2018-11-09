import 'package:angular/angular.dart';
import 'dart:convert';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'dart:html';
import 'dart:js';

import 'package:intl/intl.dart';

@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
)
class AppComponent {
  var name = 'Excel Generation';
 var obj = context['config'];
  List<Map<String, dynamic>> notificationReportDataList=[];
  List<dynamic> dataList = [{"Vehicle":"BMW","Date":"30, Jul 2013 09:24 AM","Location":"Hauz Khas, Enclave, New Delhi, Delhi, India","Speed":42},{"Vehicle":"Honda CBR","Date":"30, Jul 2013 12:00 AM","Location":"Military Road,  West Bengal 734013,  India","Speed":0},{"Vehicle":"Supra","Date":"30, Jul 2013 07:53 AM","Location":"Sec-45, St. Angel's School, Gurgaon, Haryana, India","Speed":58},{"Vehicle":"Land Cruiser","Date":"30, Jul 2013 09:35 AM","Location":"DLF Phase I, Marble Market, Gurgaon, Haryana, India","Speed":83},{"Vehicle":"Suzuki Swift","Date":"30, Jul 2013 12:02 AM","Location":"Behind Central Bank RO, Ram Krishna Rd by-lane, Siliguri, West Bengal, India","Speed":0},{"Vehicle":"Honda Civic","Date":"30, Jul 2013 12:00 AM","Location":"Behind Central Bank RO, Ram Krishna Rd by-lane, Siliguri, West Bengal, India","Speed":0}];
 String csv = ""; 
  
  showData(){
    
    var jsonData = [{"Vehicle":"BMW","Date":"30, Jul 2013 09:24 AM","Location":"Hauz Kh"}];
    var jsonvalue = json.encode(jsonData);
//var data = JSON.decode(json);
    //csv=exportToCsv();
    new JsObject(context['result'], [jsonvalue,"excel sheet"]);
   //print(point);
  }
 

  convert() async{
    print('this will be printed');
    Response response =
        await new BrowserClient().get('http://localhost:8089/notifications/');
        //var data = json.encode(response.body);
        
notificationReportDataList =convertToListOfMap(response.body);
//print(notificationReportDataList);
var data = json.encode(notificationReportDataList);

new JsObject(context['result'], [data,"excel sheet"]);

  }

 List<Map<String, dynamic>> convertToListOfMap(String responseBody) {
    print("inside convertToListOfMap method");
    var notificationReportData = json.decode(responseBody);
    List<Map<String, dynamic>> data = asMapList(notificationReportData);
    for (Map<String, dynamic> map in data) {
      map['scheduledDate']=parseAs12HourFormat((map['scheduledDate'] as int));
      map['createdDate']=parseAs12HourFormat((map['createdDate'] as int));
      map.remove(map['sno']);
    } //for end
    print(data);
    return data;
  }
  String parseAs12HourFormat(int epochTime) {
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTime);
      DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ssa');
      return format.format(dateTime);
      // return dateTime.toString();
    } catch (e) {
      print(e);
      return null;
    }
  }

List<Map<String, dynamic>> asMapList(dynamic list) {
  List<Map<String, dynamic>> maps = [];
  if (list is List) {
    for (var map in list) {
      try {
        maps.add(asMap(map));
      } catch (e) {

      }
    }
  }
  return maps;
}

Map<String, dynamic> asMap(dynamic map) {
  if (map is Map) {
    Map<String, dynamic> m = <String, dynamic>{};
    for (dynamic key in map.keys) {
      if (key is String) {
        m[key] = map[key];
      }
    }
    return m;
  }
  throw 'Not a map';
}



}
