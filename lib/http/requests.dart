import 'package:http/http.dart' as http;
class CustomHttpRequests{


  static Future<bool> checkExistingUser(String number) async{
    var url = "http://192.168.0.108/public/api/check-user-exists/$number";
    var response = await http.get(url,
      headers: {
        "Accept":"application/json",
      },
    );
    if(response.body=="found")
      {
        return true;
      }
    else if(response.body=="not-found")
      {
        return false;
      }
    return false;
  }

  static Future<String> login (String phone, String password)async{
    try{
      final url = 'http://192.168.0.108/public/api/login';
      var response = await http.post(url,
          headers: {
            "Accept":"application/json",
          },
          body: {
            'phone': phone,
            'password': password,
          }
      );
      if(response.statusCode==200)
      {
        return response.body;
      }
      else
      {
        throw('Error: Something wrong');
      }
    }
    catch(e){
      return e.toString();
    }
  }

  static Future<String> me (String token)async{
    try{
      final url = 'http://192.168.0.108/public/api/me';
      var response = await http.get(url,
        headers: {
          "Authorization":"bearer $token",
        }
      );
      if(response.statusCode==200)
      {
        return response.body;
      }
      else
      {
        throw('Error: Something wrong ${response.statusCode}');
      }
    }
    catch(e){
      return e.toString();
    }
  }
}