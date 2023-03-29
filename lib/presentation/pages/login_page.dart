import 'package:alerts/presentation/general/widgets/general_widget.dart';
import 'package:alerts/presentation/pages/profile_page.dart';
import 'package:alerts/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:alerts/presentation/pages/init_page.dart';
import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/presentation/general/utils/types.dart';
import 'package:alerts/presentation/general/widgets/common_textfield_password_widget.dart';
import 'package:alerts/presentation/general/widgets/common_button_widget.dart';
import 'package:alerts/presentation/general/widgets/common_text_field_widget.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //! creamos los controladores de los TextField para poder ser capturados los
  final TextEditingController _dniController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  //! instanciamos objeto que servirá para validar el formulario donde se
  final loginFormKey = GlobalKey<FormState>();

  //? variable indicador para anunciar carga de los datos
  bool isloanding = false;

  //**------------------------------------------------------ */
  void login() {
    //? hacemos la validación del estado actual de la instancia loginFormKey
    if (loginFormKey.currentState!.validate()) {
      //** para indicar que aparezca el loding de carga */
      isloanding = true;
      setState(() {});
      //**---------------loading la carga --------------------- */
      //! instanciamos objeto del tipo ApiService para poder llamar
      //! a los métodos que posee el tipo ApiService
      ApiService apiService = ApiService();
      //! método de login que posee la clase ApiService
      //! dentro de login enviamos lo capturado por los textfield, deben tener
      //! el ".text" para que pueda ser recepcionado por el api_service
      apiService
          .login(_dniController.text, _passwordController.text)
          .then((value) {
        //! con este tipo de push, hacemos el avance hasta la página indicada y
        //! las demás anteriores se cierran para que no queden ejecutándose en un
        //! segundo plano oculto
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => InitPage(),
          ),
          (route) => false,
        );
      }).catchError((error) {
        //** deshabilitamos el loading para que deje de cargar */
        isloanding = false;
        setState(() {});
        //**-------- fin de deshabilitación del loading carga */
        //? forzamos al captura a un Map para poder trabajar con el error
        //? que nos envia el api_service desde la respuesta del backend
        Map dataError = error as Map;
        //! "error" es tomado desde api_service
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: H4(
              text: dataError["message"],
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                //! rodeamos la Column principal del Widget Form para poder realizar
                //! las validaciones respectivas que se ingresaron en el textfield
                child: Form(
                  //! asignamos al atributo key el verificador creado para el Form
                  key: loginFormKey,
                  child: Column(
                    children: [
                      spacing20Height,
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
                        text: "Iniciar Sesión",
                        fontWeight: FontWeight.w600,
                      ),
                      spacing8Height,
                      CommomTextFieldWidget(
                        controller: _dniController,
                        label: "DNI",
                        hintText: "Tu DNI",
                        type: InputType.dni,
                      ),
                      spacing20Height,
                      CommonTextFieldPasswordWidget(
                        controller: _passwordController,
                      ),
                      spacing30Height,
                      CommonButtonWidget(
                        text: "Iniciar Sesión",
                        onPressed: () {
                          login();
                        },
                      ),
                      spacing20Height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          H5(text: "Aún no estas registrado? "),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );

                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => RegisterPage(),
                              //     ),
                              //     (route) => false);
                            },
                            child: H5(
                              text: " Regístrate",
                              color: kBrandPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //? con operadores ternarios controlamos el loading
          isloanding
              ? Container(
                  color: Colors.white.withOpacity(0.8),
                  child: loadingWidget,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
