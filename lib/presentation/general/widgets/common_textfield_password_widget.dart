import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';

class CommonTextFieldPasswordWidget extends StatefulWidget {
  //! este atributo es para poder controlar la captura de datos ingresados
  TextEditingController controller;

  CommonTextFieldPasswordWidget({
    required this.controller,
  });

  @override
  State<CommonTextFieldPasswordWidget> createState() =>
      _CommonTextFieldPasswordWidgetState();
}

class _CommonTextFieldPasswordWidgetState
    extends State<CommonTextFieldPasswordWidget> {
  //! variable que por default es True y controlará la visibilidad del teclado
  bool isInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H5(text: " Contraseña:"),
        spacing8Height,
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          //! inicialmente era un TextField, luego lo pasamos a un TextFormField
          //! para poder realizar las validaciones de los datos ingresados desde
          //! teclado del equipo
          child: TextFormField(
            //! este atributo es para poder hacer la captura de los datos
            //! ingresados en el textfield
            //? uso de widget para poder traer el atributo creado en un stateful
            controller: widget.controller,
            //! atributo para no ver lo que se escribe en pantalla
            obscureText: isInvisible,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  //! lo escribimos así para que pueda alternar su estado cuando
                  //! se pulsa sobre el ícono
                  isInvisible = !isInvisible;
                  setState(() {});
                },
                icon: Icon(
                  //! operador ternario de la sentencia If
                  isInvisible
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  //! operador ternario de la sentencia If
                  color: isInvisible ? kBrandPrimaryColor : KkBrandFontColor,
                ),
              ),
              hintText: "Tu Contraseña",
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              //**--- atributos para el caso de los errores en el llenado */
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              //**------ fin usado para los errores en el llenado */
            ),
            //! acá se realiza la validación de los datos ingresados
            validator: (String? value) {
              if (value != null && value.isEmpty) {
                return "Campo Oblitario";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
