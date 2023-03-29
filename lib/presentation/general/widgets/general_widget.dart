import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:flutter/material.dart';

//? creación del widget(objeto del tipo widget) que realizará la acción de carga
Center loadingWidget = Center(
  child: SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2.4,
      color: kBrandPrimaryColor,
    ),
  ),
);
