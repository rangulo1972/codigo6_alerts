import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:alerts/domain/models/incident_model.dart';
import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/presentation/general/widgets/general_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //! establecemos myMarkers del tipo Set<Marker> porque de este tipo solicita
  //! el atributo del tipo markers
  Set<Marker> myMarkers = {};
  //! instanciamos objeto del tipo ApiService para poder llamar
  //! a los métodos que posee el tipo ApiService
  ApiService apiService = ApiService();

  //! creamos una función para poder mostrar los detalles de los incidents que
  //! se recepcionó desde el backend
  void showIncidentDetail(IncidentModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H5(
                    text: "Detalle de la alerta",
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const Divider(),
              H6(
                text: "Tipo: ${model.tipoIncidente.titulo}",
                fontWeight: FontWeight.w600,
              ),
              H6(
                text: "Ciudadano: ${model.datosCiudadano.nombres}",
                fontWeight: FontWeight.w600,
              ),
              H6(
                text: "DNI: ${model.datosCiudadano.dni}",
                fontWeight: FontWeight.w600,
              ),
              H6(
                text: "Teléfono: ${model.datosCiudadano.telefono}",
                fontWeight: FontWeight.w600,
              ),
              // H6(
              //   text: "Direcció: ",
              //   fontWeight: FontWeight.w600,
              // ),
              H6(
                text: "fecha creado: ${model.fechaCreacion}",
                fontWeight: FontWeight.w600,
              ),
              spacing12Height,
              CommonButtonWidget(
                text: "Aceptar",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: apiService.getIncidents(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            //! captura de los incidentModel para obtener los marcadores y ser
            //! mostrados en el mapa
            List<IncidentModel> incidents = snapshot.data;
            incidents.forEach(
              (item) {
                Marker myMarker = Marker(
                  markerId: MarkerId(myMarkers.length.toString()),
                  position: LatLng(item.latitud, item.longitud),
                  //? para poder mostrar el detalle de los incidentes al presionar
                  //? sobre cada marker
                  onTap: () {
                    showIncidentDetail(item);
                  },
                );
                myMarkers.add(myMarker);
              },
            );
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-8.112048, -79.029186),
                zoom: 4.8,
                // //** zoom para probar los markers */
                // zoom: 14,
                // //**---- fin de zoom para markers */
              ),
              markers: myMarkers,
              //**--------------------------------------- */
              // //! habilitado para poder mostrar en pantalla la inserción manual
              // //! de los markers para ser visualizados en pantalla
              // onTap: (LatLng position) {
              //   //** print para mostrar en consola los markers */
              //   Marker marker = Marker(
              //     //** para poder mostrar más de un marker en el mapa */
              //     markerId: MarkerId(myMarkers.length.toString()),
              //     position: position,
              //   );
              //   myMarkers.add(marker);
              //   setState(() {});
              //   //print(position);
              //   //** --- fin print para mostrar los markers */
              // },
              // //!------------ fin visualizar markers-------------------
              //**---------------------------------------------- */
            );
          }
          return loadingWidget;
        },
      ),
    );
  }
}
