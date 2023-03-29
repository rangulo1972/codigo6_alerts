import 'package:flutter/material.dart';
import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/domain/models/incident_type_model.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/widgets/common_button_widget.dart';
import 'package:alerts/presentation/general/widgets/general_widget.dart';
import 'package:geolocator/geolocator.dart';

class RegisterIncidentmodal extends StatefulWidget {
  List<IncidentTypeModel> incidentsType;

  RegisterIncidentmodal({
    required this.incidentsType,
  });

  @override
  State<RegisterIncidentmodal> createState() => _RegisterIncidentmodalState();
}

class _RegisterIncidentmodalState extends State<RegisterIncidentmodal> {
  int indexIncidentType = 1;
  bool isLoading = false;

  ApiService apiService = ApiService();

  registerIncident() async {
    isLoading = true;
    setState(() {});
    Position position = await Geolocator.getCurrentPosition();
    //print(position);
    apiService.registerIncident(indexIncidentType, position).then((value) {
      isLoading = false;
      setState(() {});
      Navigator.pop(context);
    }).catchError((error) {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  H5(
                    text: "Enviar Alerta",
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: KkBrandFontColor.withOpacity(0.07),
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: DropdownButton(
                  value: indexIncidentType,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(14),
                  items: widget.incidentsType
                      .map((e) => DropdownMenuItem(
                            value: e.id,
                            child: H6(
                              text: e.titulo,
                              fontWeight: FontWeight.w600,
                            ),
                          ))
                      .toList(),
                  onChanged: (int? value) {
                    indexIncidentType = value!;
                    setState(() {});
                  },
                ),
              ),
              spacing16Height,
              CommonButtonWidget(
                text: "Enviar Alerta",
                onPressed: () {
                  registerIncident();
                },
              ),
            ],
          ),
        ),
        isLoading
            ? Container(
                color: Colors.white.withOpacity(0.7),
                child: loadingWidget,
              )
            : const SizedBox(),
      ],
    );
  }
}
