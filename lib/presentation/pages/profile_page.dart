import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/utils/sp_global.dart';
import 'package:alerts/presentation/general/widgets/common_button_widget.dart';
import 'package:alerts/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String nombre = SPGlobal().nombreCompleto;
  final String telefono = SPGlobal().telefono;
  final String direccion = SPGlobal().direccion;
  final String dni = SPGlobal().dni;
  @override
  Widget build(BuildContext context) {
    // print(":::::$nombre");
    // print(":::::$telefono");
    // print(":::::$direccion");
    // print(":::::$dni");
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network(
                  "https://www.municayma.gob.pe/wp-content/uploads/2021/07/escudo-solo.png",
                  height: 90,
                ),
                spacing8Height,
                H4(
                  text: "Municipalidad Distrital de Cayma",
                  color: KkBrandFontColor,
                  fontWeight: FontWeight.w600,
                ),
                spacing8Height,
                H1(
                  text: "Alerta Cayma",
                ),
                spacing20Height,
                H4(
                  text: "Perfil de Usuario",
                  fontWeight: FontWeight.w600,
                ),
                spacing12Height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H5(text: "Nombre de Usuario:"),
                        H4(text: nombre),
                        spacing4Height,
                        H5(text: "Teléfono:"),
                        H4(text: telefono),
                        spacing4Height,
                        H5(text: "Dirección:"),
                        H4(text: direccion),
                        spacing4Height,
                        H5(text: "DNI:"),
                        H4(text: dni),
                      ],
                    ),
                  ],
                ),
                spacing30Height,
                CommonButtonWidget(
                  text: "Cerrar Sesión",
                  onPressed: () {
                    //! Limpiamos los datos que se tienen guardados en memoria interna
                    //! del equipo realizado mendiante Shared Preference
                    SPGlobal().isLogin = false;
                    SPGlobal().token = "";
                    SPGlobal().nombreCompleto = "";
                    SPGlobal().telefono = "";
                    SPGlobal().direccion = "";
                    SPGlobal().dni = "";
                    //? hacemos que muestre login_page para solicitar nuevamente el
                    //? ingreso mediante la identificación que nos solicta
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
