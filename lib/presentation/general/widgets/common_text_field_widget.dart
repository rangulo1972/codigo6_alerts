import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommomTextFieldWidget extends StatelessWidget {
  String label;
  String hintText;
  InputType type;
  //! este atributo es para poder controlar la captura de datos ingresados
  TextEditingController controller;

  CommomTextFieldWidget({
    required this.label,
    required this.hintText,
    required this.type,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H5(text: "   $label:"),
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
            controller: controller,
            //! este atributo gestiona el type de teclado
            //! según sea type se muestra el tipo de teclado
            keyboardType: type == InputType.dni || type == InputType.phone
                ? TextInputType.number
                : TextInputType.text,
            //! se ajusta la longitud total a colocar según sea el type
            maxLength: type == InputType.dni
                ? 8
                : type == InputType.phone
                    ? 9
                    : null,
            //! con este atributo hacemos que solo se pueda colocar números,
            //! haciendo uso de las expresiones regulares
            inputFormatters: type == InputType.dni || type == InputType.phone
                ? [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))]
                : [],
            decoration: InputDecoration(
              //! colocamos vacío para que no se muestre el valor de maxLength
              counterText: "",
              hintText: hintText,
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
                return "Campo Obligatorio";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
