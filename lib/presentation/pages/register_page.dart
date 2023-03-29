import 'package:flutter/material.dart';
import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/utils/types.dart';
import 'package:alerts/presentation/general/widgets/common_button_widget.dart';
import 'package:alerts/presentation/general/widgets/common_text_field_widget.dart';
import 'package:alerts/presentation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nombresController = TextEditingController();

  final TextEditingController _dniController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final registerFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  void register() {
    //? hacemos la validación del estado actual de la instancia registerFormKey
    if (registerFormKey.currentState!.validate()) {
      //** para indicar que aparezca el loding de carga */
      isLoading = true;
      setState(() {});
      //! instanciamos objeto del tipo ApiService para poder llamar
      //! a los métodos que posee el tipo ApiService
      ApiService apiService = ApiService();
      //! método de register que posee la clase ApiService
      //! dentro de register enviamos lo capturado por los textfield, deben tener
      //! el ".text" para que pueda ser recepcionado por el api_service
      apiService
          .register(
        _nombresController.text,
        _dniController.text,
        _phoneController.text,
        _addressController.text,
        _passwordController.text,
      )
          .then((value) {
        Navigator.pop(context);
      }).catchError((error) {
        //** deshabilitamos el loading para que deje de cargar */
        isLoading = false;
        setState(() {});
        //**-------- fin de deshabilitación del loading carga */
        //? forzamos al captura a un Map para poder trabajar con el error
        //? que nos envia el api_service desde la respuesta del backend
        Map dataError = error as Map;
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
                child: Form(
                  key: registerFormKey,
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
                      spacing10Height,
                      H4(
                        text: "Iniciar Registro",
                        fontWeight: FontWeight.w600,
                      ),
                      spacing10Height,
                      CommomTextFieldWidget(
                          label: "Nombres Completos:",
                          hintText: "Ingrese su Nombre Completo",
                          type: InputType.text,
                          controller: _nombresController),
                      spacing10Height,
                      CommomTextFieldWidget(
                          label: "DNI:",
                          hintText: "Ingrese su número de DNI",
                          type: InputType.dni,
                          controller: _dniController),
                      spacing10Height,
                      CommomTextFieldWidget(
                          label: "Teléfono:",
                          hintText: "Ingrese su número de teléfono",
                          type: InputType.phone,
                          controller: _phoneController),
                      spacing10Height,
                      CommomTextFieldWidget(
                          label: "Dirección:",
                          hintText: "Ingrese su dirección",
                          type: InputType.text,
                          controller: _addressController),
                      spacing10Height,
                      CommomTextFieldWidget(
                          label: "Password:",
                          hintText: "Crear un password",
                          type: InputType.text,
                          controller: _passwordController),
                      spacing20Height,
                      CommonButtonWidget(
                        text: "Iniciar Registro",
                        onPressed: () {
                          register();
                        },
                      ),
                      spacing10Height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          H5(text: "Ya estas registrado? "),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                  (route) => false);
                            },
                            child: H5(
                              text: " Log In",
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
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: kBrandPrimaryColor,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
