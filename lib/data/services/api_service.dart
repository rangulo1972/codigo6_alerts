import 'dart:async';
import 'dart:convert';
import 'dart:io';

//! importación para el uso de poder traer los servicios desde el backend
import 'package:alerts/domain/models/incident_model.dart';
import 'package:alerts/domain/models/incident_type_model.dart';
import 'package:alerts/domain/models/news_model.dart';
import 'package:alerts/domain/models/user_model.dart';
import 'package:alerts/presentation/general/utils/sp_global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ApiService {
  //**------- Método Register Usuario------- */
  //! método register
  Future<void> register(String name, String dni, String phone, String address,
      String password) async {
    try {
      //! primero especificamos el Uri
      //**-------------- dirección del server donde registar el usuario */
      Uri url = Uri.parse("http://167.99.240.65/API/registro/");
      http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "nombreCompleto": name,
          "dni": dni,
          "telefono": phone,
          "direccion": address,
          "password": password,
        }),
      );
      //** en el caso que tengamos una respuesta positiva desde el post */
      if (response.statusCode == 201) {
        //  print(response.statusCode);
        throw {"message": "Usuario registrado"};
      } else if (response.statusCode == 400) {
        //  print(response.statusCode);
        throw {
          "message": "Teléfono y Dni ya registrados, inténtelo nuevamente..."
        };
      } else {
        throw {"message": "Hubo un problema, volver a intentarlo..."};
      }
      //*--------------- fin del caso postivo en respuestas del post-----
      //! acá especificamos los posibles errores que se tenga para poder ser
      //! manejados en el proyecto
    } on TimeoutException catch (e) {
      //! con el retorno enviamos el error a login_page para ser trabajado
      return Future.error(
          {"message": "Error de conexión con el servidor...$e"});
    } on SocketException catch (e) {
      //! con el retorno enviamos el error a login_page para ser trabajado
      return Future.error({"message": "Error en la conexión a internet...$e"});
    } on Error catch (e) {
      //! con el retorno enviamos el error a login_page para ser trabajado
      return Future.error(
          {"messsage": "Hubo un inconveniente, inténtelo nuevamente...$e"});
    }
  }

  //?-----------------------------------------------------------------------
  //**------- Método Log In------- */
  //! método login
  //! indicamos que recibirá los parámetros dni y password para ser validados
  Future<UserModel> login(String dni, String password) async {
    //! hacemo uso del try / catch ya que puede presentar errores al tratar
    //! de obtener la data desde el server del backend
    try {
      //! primero especificamos el Uri
      //**----------------- dirección del server donde se traerá el servicio */
      Uri url = Uri.parse("http://167.99.240.65/API/login/");
      http.Response response = await http.post(
        url,
        //! headers de acuerdo a como lo solicta el backend para poder realizar
        //! la obtención del login desde el server
        headers: {
          "Content-Type": "application/json",
        },
        //! body de acuerdo a como lo solicta el backend para poder realizar
        //! la obtención del login desde el server
        //** hacemos uso de json del tipo encode para poder realizar el envio */
        body: json.encode({
          //** colocamos como valor los parámetros ingresados para ser validados
          "username": dni,
          "password": password,
        }),
      );
      //** en el caso que tengamos una respuesta positiva desde el post */
      if (response.statusCode == 200) {
        //! creamos un objeto del tipo Map<String,dynamic> que hará la captura de
        //! lo que nos devuelve el server al realizar el post mencionado líneas
        //! arriba
        Map<String, dynamic> data = json.decode(response.body);
        //! instanciamos un objetod el tipo UserModel haciendo uso de los modelos
        //! creados, solamente nos intereza la parte del Map que contiene "user"
        UserModel userModel = UserModel.fromJson(data["user"]);
        //! llamamos a los métodos de la clase del SPGlobal para guardar los
        //! datos que nos obtenemos desde el server al hacer Log In
        //** grabamos isLogin como true en memoria del equipo */
        SPGlobal().isLogin = true;
        //** grabamos el token que recibimos del backend en memoria del equipo*/
        SPGlobal().token = data["access"];
        //! usado para traer los datos del login y presentarlos en perfil
        SPGlobal().nombreCompleto = data["user"]["nombreCompleto"];
        SPGlobal().telefono = data["user"]["telefono"];
        SPGlobal().direccion = data["user"]["direccion"];
        SPGlobal().dni = data["user"]["dni"];
        return userModel;
      } else if (response.statusCode == 400) {
        //! con "throw" se retorna el mensaje de error con credenciales erróneos
        throw {"message": "Credenciales Incorrectos"};
      } else {
        throw {"message": "Hubo un error... "};
      }
      //**-------------------------------------------------------------- */
      //! acá especificamos los posibles errores que se tenga para poder ser
      //! manejados en el proyecto
    } on TimeoutException catch (e) {
      //! con el retorno enviamos el error a login_page para ser trabajado
      return Future.error(
          {"message": "Error de conexión con el servidor...$e"});
    } on SocketException catch (e) {
      //! con el retorno enviamos el error a login_page para ser trabajado
      return Future.error({"message": "Error en la conexión a internet...$e"});
    } on Error catch (e) {
      //! con el retorno enviamos el error a login_page para ser trabajado
      return Future.error(
          {"messsage": "Hubo un inconveniente, inténtelo nuevamente...$e"});
    }
  }
  //**-----------fin método Log In--------------- */

  //?-----------------------------------------------------------------------
  //**------- Método Get de incidencias registradas------- */

  Future<List<IncidentModel>> getIncidents() async {
    //**----------------- dirección del server donde se traerá el servicio */
    Uri url = Uri.parse("http://167.99.240.65/API/incidentes/");
    //! en response se hace la captura de los que se trae del body del get
    http.Response response = await http.get(url);
    //! si se tiene una respuesta stisfactoria del get, nos devuelve un estado
    if (response.statusCode == 200) {
      //! ralizamos el formato de transformación para el uso de los caracteres
      //! especiales del tipo utf-8
      String dataCovert = Utf8Decoder().convert(response.bodyBytes);
      //! lo que se obtiene es una lista del body del response
      List data = json.decode(dataCovert);
      //! creamos una instancia del tipo List<IncidentModel>
      List<IncidentModel> incidents = [];
      //! adicionamos a la instancia la lista obtenida desde response.body
      incidents = data.map((e) => IncidentModel.fromJson(e)).toList();
      return incidents;
    }
    //! en caso no se tenga data alguna retornamos un lista vacía
    return [];
  }
  //**------- fin de método Get de incidencias registradas------- */

  //?-----------------------------------------------------------------------
  //**------- Método Get del tipo de incidencias ------- */

  Future<List<IncidentTypeModel>> getIncidentsType() async {
    //**----------------- dirección del server donde se traerá el servicio */
    Uri url = Uri.parse("http://167.99.240.65/API/incidentes/tipos/");
    //! en response se hace la captura de lo que se trae del body como respuesta
    //! a lo que nos devuelve el Backend (server) cuando se hace el get
    http.Response response = await http.get(url);
    //! si se tiene una respuesta satisfactoria del get, nos devuelve un estado
    if (response.statusCode == 200) {
      //! ralizamos el formato de transformación para el uso de los caracteres
      //! especiales del tipo utf-8
      String dataConvert = Utf8Decoder().convert(response.bodyBytes);
      //! lo que se obtiene es una lista del body del response
      List data = json.decode(dataConvert);
      //! creamos una instancia del tipo List<IncidentTypeModel>
      List<IncidentTypeModel> incidentsType = [];
      //! adicionamos a la instancia la lista obtenida desde response.body
      incidentsType = data.map((e) => IncidentTypeModel.fromJson(e)).toList();
      return incidentsType;
    }
    return [];
  }

  //?-----------------------------------------------------------------------
  //**------- Método Post de registro de incidencias ------- */
  Future<IncidentModel> registerIncident(int type, Position position) async {
    //**----------------- dirección del server donde se traerá el servicio */
    Uri url = Uri.parse("http://167.99.240.65/API/incidentes/crear/");
    //! en response se hace la captura de lo que se trae del body como respuesta
    //! a lo que nos devuelve el Backend (server) cuando se hace el post
    http.Response response = await http.post(
      url,
      //! headers de acuerdo a como lo solicta el backend para poder realizar
      //! el registro de una incidencia en el server
      headers: {
        "Content-Type": "application/json",
        //**------------- uso de Shared Preference para el uso del token */
        "Authorization": "Token ${SPGlobal().token}"
      },
      //! body de acuerdo a como lo solicta el backend para poder realizar
      //! el registro de una incidencia en el server
      //** hacemos uso de json del tipo encode para poder realizar el envio */
      body: json.encode(
        {
          //** colocamos como valor los parámetros ingresados para el registro
          "latitud": position.latitude,
          "longitud": position.longitude,
          "tipoIncidente": type,
          "estado": "Abierto"
        },
      ),
    );
    //! si se tiene una respuesta stisfactoria del get, nos devuelve un estado
    if (response.statusCode == 201) {
      //! ralizamos el formato de transformación para el uso de los caracteres
      //! especiales del tipo utf-8
      String dataCovert = Utf8Decoder().convert(response.bodyBytes);
      //! lo que se obtiene es un Map del body del response
      Map<String, dynamic> data = json.decode(dataCovert);
      IncidentModel incidentModel = IncidentModel.fromJson(data);
      return incidentModel;
    } else {
      //return null;
      throw {"message": "No se pudo registrar el incidente"};
    }
  }

  //?-----------------------------------------------------------------------
  //**------- Método Post de registro de incidencias ------- */
  Future<List<NewsModel>> getNews() async {
    //**----------------- dirección del server donde se traerá el servicio */
    Uri url = Uri.parse("http://167.99.240.65/API/noticias/");
    //! en response se hace la captura de lo que se trae del body como respuesta
    //! a lo que nos devuelve el Backend (server) cuando se hace el get
    http.Response response = await http.get(url);
    //! si se tiene una respuesta satisfactoria del get, nos devuelve un estado
    if (response.statusCode == 200) {
      //! ralizamos el formato de transformación para el uso de los caracteres
      //! especiales del tipo utf-8
      String dataCovert = Utf8Decoder().convert(response.bodyBytes);
      //! lo que se obtiene es una lista del body del response
      List data = json.decode(dataCovert);
      //! creamos una instancia del tipo List<NewsModel>
      List<NewsModel> news = [];
      //! adicionamos a la instancia la lista obtenida desde data
      news = data.map((e) => NewsModel.fromJson(e)).toList();
      return news;
    }
    return [];
  }

  //?-----------------------------------------------------------------------
  //**------- Método Post de registro de noticias ------- */
  //! el tipo de modelo para crear las noticias es del tipo NewModel
  Future<NewsModel> registerNews(NewsModel model) async {
    //**----------------- dirección del server donde se subirá el servicio */
    Uri url = Uri.parse("http://167.99.240.65/API/noticias/");
    //! usamos la opción MultipartRequest para poder realizar una petición del
    //! tipo form-data para el manejo de archivo, imágenes, bits
    http.MultipartRequest request = http.MultipartRequest("POST", url);
    //** definimos los campos que se enviará al server para registrar News */
    //? estos campos son definidos por el Banckend para hacer el resgitro
    request.fields["titulo"] = model.titulo;
    request.fields["link"] = model.link;
    request.fields["fecha"] = model.fecha;
    //**----------------------------------------------------------- */
    //! para poder extraer el tipo de archivo y su extensión
    List<String> dataMine = mime(model.imagen)!.split("/");
    //? para el caso de las imágenes usamos MultiparFile que nos permite crear
    //? archivos para poder ser tomados en el POST y ser subido al server
    http.MultipartFile file = await http.MultipartFile.fromPath(
      "imagen",
      model.imagen,
      contentType: MediaType(dataMine[0], dataMine[1]),
    );
    request.files.add(file);
    //! inicializa el envío de la data
    //! para subir la información de forma fluida
    http.StreamedResponse streamedResponse = await request.send();
    //? streamedResponse se tiene como respuesta del backend una vez que se haya
    //? subido la data al server
    //! en response se hace la captura de lo que se trae del body como respuesta
    //! a lo que nos devuelve el Backend (server) cuando se hace el POST
    http.Response response = await http.Response.fromStream(streamedResponse);
    //! si se tiene una respuesta stisfactoria del get, nos devuelve un estado
    if (response.statusCode == 201) {
      //! ralizamos el formato de transformación para el uso de los caracteres
      //! especiales del tipo utf-8
      String dataCovert = Utf8Decoder().convert(response.bodyBytes);
      //! lo que se obtiene es un Map del body del response
      Map<String, dynamic> data = json.decode(dataCovert);
      NewsModel news = NewsModel.fromJson(data);
      return news;
    } else {
      //return null;
      throw {"message": "No se pudo registrar..."};
    }
  }
}
