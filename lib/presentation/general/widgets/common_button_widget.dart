import 'package:flutter/material.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/general/ui/text.dart';

class CommonButtonWidget extends StatelessWidget {
  //! inicializamos atributos para customizar y reutilizar este widget
  String text;
  VoidCallback onPressed;

  CommonButtonWidget({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        //! la función VoidCallback dependerá según la función que se desea ejecutar
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: kBrandPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            )),
        child: H5(
          //! el label en el botón dependerá de la acción a desear ejecutarse
          text: text,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
