import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hayt_buyer/Common/ClassList.dart';
import 'package:hayt_buyer/Common/Constants.dart';
import 'package:hayt_buyer/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

Dio dio = new Dio();

class AppServices {
  static Future<SaveDataClass> BuyreSignUp(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Buyer/buyeraddAPI';
    print("Buyer Registration URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Buyer Registration Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Buyer Registration Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> BuyreUpdateProfile(String id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Buyer/buyerupdateAPI/${id}';
    print("Buyer Update URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Buyer Update Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Buyer Update Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> BuyerLogin(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Buyer/login';
    print("Buyer Login URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Buyer Login Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        List list = [];
        if (jsonResponse["data"].toString() == "0") {
          list = [
            {
              "id": jsonResponse['value']["id"],
              "firstname": jsonResponse['value']["name"],
              "lastname": jsonResponse['value']["surname"],
              "dob": jsonResponse['value']["dob"],
              "phone": jsonResponse['value']["phoneno"],
              "email": jsonResponse['value']["email"],
              "password": jsonResponse['value']["password"],
              "city_id": jsonResponse['value']["city_id"],
            }
          ];
        }
        saveDataClass.value = list;
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Buyer Login Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SellerSignUp(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Registration/selleraddAPI';
    print("Seller Registration URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Seller Registration Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Seller Registration Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetAllSeller(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Registration/Seller';
    print("Get All Seller url: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Selller Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']["all_users"];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Selller Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetAllServices(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Services/service';
    print("Get All Services URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Services Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Services Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddService(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Services/serviceaddAPI';
    print("Service Add URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Service Add Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Service Add Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> UpdateService(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Services/serviceupdateAPI/${id}';
    print("Service Update URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Service Update Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Service Update Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetAllProducts(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Product/product';
    print("GEt ALL products URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Products Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Products Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetRelatedProducts(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Product/relatedproducts/${id}';
    print("Get Related products URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get Related Products Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Related Products Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddProduct(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Product/productaddAPI';
    print("Product Add URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Product Add Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Product Add Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> UpdateProduct(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Product/productupdateAPI/${id}';
    print("Product Update URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Product Update Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Product Update Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddFeed(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Feeds/feedsaddAPI';
    print("Feed Add URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Feed Add Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Feed Add Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> UpdateFeed(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Feeds/feedsupdateAPI/${id}';
    print("Feed Update URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Feed Update Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Feed Update Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetAllFeeds(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Feeds/feeds/${id}';
    print("Get All feeds URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Feeds Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']['all_users'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Feeds Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AdminProfileUpdate(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Registration/AdminupdateAPI/id';
    print("Admin Profile Update URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Admin Profile Update Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Admin Profile Update Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> DeleteProduct(data) async {
    String url = API_URL + 'Product/productdeleteAPI/${data}';
    print("Delete Product URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: {});
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Delete Product Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Delete Product Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> DeleteService(data) async {
    String url = API_URL + 'Services/servicedeleteAPI/${data}';
    print("Delete Service URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: {});
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Delete Service Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Delete Service Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> DeleteFeed(data) async {
    String url = API_URL + 'Feeds/feedsdeleteAPI/${data}';
    print("Delete Feed URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: {});
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Delete Feed Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Delete Feed Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddToFav(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Favourite/favouriteaddAPI';
    print("Add to Favorite URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Add to Favorite Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Add to Favorite Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetFav(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Favourite/chatlist/${id}';
    print("Get Favorites URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        print("Get Favorites Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Favorites Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetUsersToSellerChatList(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'usertoseller/chatlist';
    print("Get Users to Seller Chat URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        print("Get Users to Seller Chat Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Users to Seller Chat Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SendUsertosellerMessage(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'usertoseller/message';
    print("User to Sellere Add URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("User to Sellere Add Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("User to Sellere Add Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetUsertosellerChatMsg(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'usertoseller/chathistory';
    print("Get Usertoseller Chat msg URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        print("Get Usertoseller Chat msg Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Usertoseller Chat msg Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetUsersToAdminChatList(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'usertoadmin/chatlist';
    print("Get Users to Admin Chat URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        print("Get Users to Admin Chat Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Users to Admin Chat Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SendUsertoAdminMessage(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'usertoadmin/message';
    print("User to Admin Add URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("User to Admin Add Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("User to Admin Add Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetUsertoAdminChatMsg(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'usertoadmin/chathistory';
    print("Get UsertoAdmin Chat msg URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        print("Get UsertoAdmin Chat msg Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get UsertoAdmin Chat msg Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> CheckOut(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Checkout/checkoutaddAPI';
    print("Checkout URL: ${url}");
    dio.options.contentType = Headers.jsonContentType;

    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Checkout Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();

        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Checkout Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetOrderHistory(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Checkout/checkouthistory/${id}';
    print("GEt ALL products URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Products Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Products Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GiveFeedLike(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Like/likeaddAPI';
    print("Give Feed Like URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Give Feed Like Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();

        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Give Feed Like Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> RemoveFeedLike(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Like/likedeleteAPI/id';
    print("Remove Feed Like URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Remove Feed Like Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Remove Feed Like Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddFeedComment(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Comment/commentaddAPI';
    print("Add Feed Comment URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Add Feed Comment Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Add Feed Comment Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetFeedComments(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Feeds/feedidcommentlist/${id}';
    print("Get Feed Comment URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        print("Get Feed Comment Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Feed Comment Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetAllCategory(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Category/allcategories';
    print("Get All Category URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Category Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']["all_users"];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Category Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddCategory(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Category/categoryaddAPI';
    print("Category Add URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Category Add Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Category Add Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> UpdateCategory(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Category/categoryupdateAPI/${id}';
    print("Category Update URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Category Update Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Category Update Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> DeleteCategory(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Category/categorydeleteAPI/${id}';
    print("Category Delete URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        print("Category Delete Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Category Delete Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SearchShop(String search, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Search/searchshop/${search}';
    print("Get All Category URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All Category Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']["all_users"];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All Category Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SearchProduct(String search, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Search/searchproduct/${search}';
    print("Search Product URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Search Product Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']["all_users"];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Search Product Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SearchService(String search, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Search/searchservice/${search}';
    print("Search Service URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Search Service Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']["all_users"];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Search Service Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SellerProductProfile(String id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Profile/productprofile/${id}';
    print("Seller Product Profile URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Seller Product Profile Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Seller Product Profile Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SellerServiceProfile(String id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Profile/serviceprofile/${id}';
    print("Seller Service Profile URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Seller Service Profile Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Seller Service Profile Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> SellerFeedsProfile(String id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Profile/feedsprofile/${id}';
    print("Seller Feeds Profile URL ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Seller Feeds Profile Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Seller Feeds Profile Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> GetProductRatings(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Rating/ratingbyproductid/${id}';
    print("Get Product Rating URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get Product Rating Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']["all_users"];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Product Rating Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddFollow(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Follow/followaddAPI';
    print("Add Follow URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Add Follow Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();

        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Add Follow Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> DeleteFollow(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Follow/followdeleteAPI/${id}';
    print("Delete Follow URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Delete Follow Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();

        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Delete Follow Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> ProductsByCategory(id, body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Product/productbycategory/${id}';
    print("Get Product by Category URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get Product by Category Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get Product by Category Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<List<CityClass>> GetCity() async {
    String url = API_URL + 'City/location';
    print("Get City URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<CityClass> city = [];
        print("Get City Response: " + response.data);
        final jsonResponse = json.decode(response.data);
        CityClassData cityData = new CityClassData.fromJson(jsonResponse);
        city = cityData.value;

        return city;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      print("Get City Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<List> GetAllCity(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'City/location';
    print("Get All City URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        print("Get All City Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
        saveDataClass.value = jsonResponse['value']['all_users'];
        List list = [];
        if (jsonResponse['data'].toString() == "0" &&
            jsonResponse['value']['all_users'].length > 0) {
          for (int i = 0; i < jsonResponse['value']['all_users'].length; i++) {
            list.add(jsonResponse['value']['all_users'][i]);
          }
          // list = jsonResponse['value']['all_users'];
        }
        return list;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Get All City Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> Transalate(String input) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString(cnst.Session.language);
    final translator = GoogleTranslator();
    SaveDataClass saveDataClass =
        new SaveDataClass(message: 'No Data', data: "1");
    var translation =
        await translator.translate(input, from: 'en', to: language);
    saveDataClass.message = "Success";
    saveDataClass.data = translation.text.toString();
    return saveDataClass;
  }
}
