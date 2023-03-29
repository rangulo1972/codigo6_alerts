import 'package:shared_preferences/shared_preferences.dart';

//! creamos la clase SharedPreferenceGlobal para poder guardar datos en memmoria
//! del equipo
//? en este caso guardaremos el token que nos devuelve el server al llegar hacer
//? log In, además de una variable para indicar que ya se inició sesión

class SPGlobal {
  //? con el uso de Singleton podemos usar la clase en todo el proyecto de forma
  //? fácil para poder acceder a los métodos de la clase
  //**--- inicio singleton */
  static final SPGlobal _instance = SPGlobal._();
  SPGlobal._();

  factory SPGlobal() {
    return _instance;
  }
  //**-----fin singleton */

  //! iniciamos una variable del tipo SharedPreferences
  //? anteponemos "late" porque se trabaja con Future
  late SharedPreferences prefs;

  //** -- método inicial de SharedPreference */
  initSharedPreferences() async {
    //! obteniendo el Shared Preference
    prefs = await SharedPreferences.getInstance();
  }
  //**---- fin método inicial de SharedPreference */

  //!------------------------------------------------
  //** Los métodos están personalizados de acuerdo a los parámetros que nos
  //** brinda el backend, estos son verificados e identificados cuando hacemos
  //** de las prueba con el postman para saber que datos son requeridos y
  //** recibidos desde el backend del server
  //**------------------------------------------------------------------ */
  //! método para guardar el token que nos brinda el server al hacer Log In
  //? con el "set" realizamos el guardado de la data que nos remite el server
  set token(String value) {
    //! indicamos que lo que se grabrá será del tipo String, le ponemos nombre
    //! y asociamos ese nombre con el valor recibido por el server
    prefs.setString("token", value);
  }

  //**--------------------------------------------------------------------- */
  //?------------------------------------------------------------------
  //! establecemos el Shared preference para poder grabar en memoria local
  //! los datos que nos devuelve el backend al momento de hacer log In y poder
  //! ser mostrados correctamente en la página de profile_page
  set nombreCompleto(String value) {
    prefs.setString("nombreCompleto", value);
  }

  set telefono(String value) {
    prefs.setString("telefono", value);
  }

  set direccion(String value) {
    prefs.setString("direccion", value);
  }

  set dni(String value) {
    prefs.setString("dni", value);
  }

  //*---------------------------------------------------------------------
  String get nombreCompleto => prefs.getString("nombreCompleto") ?? "";
  String get telefono => prefs.getString("telefono") ?? "";
  String get direccion => prefs.getString("direccion") ?? "";
  String get dni => prefs.getString("dni") ?? "";
  //?------------------------------------------------------------------

  //**-------------------------------------------------------------------- */
  //! método para obtener el token que se tiene en memoria del equipo local
  //? con el "get" realizamos la captura del valor asociado con "token" que se
  //? tiene grabado en memoria del equipo
  //** si el valor es null se retornará un string vacío */
  String get token => prefs.getString("token") ?? "";

  //? acá especificamos que se guardrá una variable de valor del tipo bool
  //? esta será la que indicará si ya se realizaó el Log In en el server
  set isLogin(bool value) {
    //** cuando el log In sea exitoso se guardará en memoria del equipo la
    //** variable "isLogin" con el valor bool de true
    //! al cerrar sesión está variable debe ser cambiado a "false"
    prefs.setBool("isLogin", true);
  }

  //! método get del isLogin para poder realizar la lectura de lo que se tiene
  //! en memoria del equipo
  bool get isLogin => prefs.getBool("isLogin") ?? false;
}
