import 'package:alerts/presentation/pages/init_page.dart';
import 'package:flutter/material.dart';
import 'package:alerts/presentation/general/utils/sp_global.dart';
import 'package:alerts/presentation/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  //! Script necesario para la inicialización de las clases que se desea
  //! iniciar desde un primer momento antes de llamar a las páginas del proyecto
  WidgetsFlutterBinding.ensureInitialized();
  //! acá inicializamos el Shared Preference
  //* instanciamos prefs del tipo Shared Preference
  //* con el uso de singleton lo instanciamos de esta manera
  SPGlobal prefs = SPGlobal();
  //* indicamos que la instancia "prefs" que se inicie, como es un Future se
  //* indica el await
  await prefs.initSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alert App',
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(),
      ),
      home: PreInit(),
    );
  }
}

//! creamos la clase PreInit para poder realizar el llamado de las páginas
//! según lo que se tenga almacenado en el Shared Preference
class PreInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //? con el operador ternario consultamos si isLogin es true, para que no
    //? presente Initpage, caso contrario nos pedirá realizar el Log In
    return SPGlobal().isLogin ? InitPage() : LoginPage();
  }
}
