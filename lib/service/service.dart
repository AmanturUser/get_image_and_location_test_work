import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthClient{
  var client = http.Client();


  Future<bool> postProductPhotoAdd( List<XFile> file,String comment,LocationData? myLocation) async {

    var url = Uri.parse('https://flutter-sandbox.free.beeceptor.com/upload_photo/');
    var request = http.MultipartRequest('POST', url);


    for(var i=0;i<file.length;i++) {
      var fileBytes$i = await file[i].readAsBytes();
      var httpImage$i = http.MultipartFile.fromBytes(
          'Images', fileBytes$i.toList(),contentType:   MediaType('image', 'jpeg'), filename: file[i].name);


//for completeing the request
    request.files.add(httpImage$i);}

// final responseData = json.decode();

    request.fields['comment'] = comment;
    if(myLocation!=null){
      request.fields['latitude'] = (myLocation.latitude!).toString();
      request.fields['longitude'] =  (myLocation.longitude!).toString();
    }else{

      request.fields['latitude'] = '38.897675';
      request.fields['longitude'] = '-77.036547';
    }


    var response =await request.send();

//for getting and decoding the response into json format
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode==201) {
      print("SUCCESS");
      print(responsed.body);
      return true;
    }
    else {
      print(response.statusCode);
      print(responsed.body);
      print("ERROR");
      return false;
    }
  }
}