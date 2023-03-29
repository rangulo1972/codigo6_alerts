import 'package:alerts/domain/models/incident_type_model.dart';
import 'package:alerts/presentation/pages/modals/register_incident_modal.dart';
import 'package:flutter/material.dart';
import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/domain/models/incident_model.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/widgets/general_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //! instanciamos objeto del tipo ApiService para poder llamar
  ApiService apiService = ApiService();
  //! creamos una lista del tipo IncidentTypeModel que será ennviada a
  //! register_incident_model
  List<IncidentTypeModel> incidentsType = [];

  @override
  void initState() {
    super.initState();
    apiService.getIncidentsType().then(
      (value) {
        incidentsType = value;
      },
    );
  }

  //! método para poder crear una alerta y registrarlo en el server
  void showSendIncident() {
    showDialog(
      context: context,
      builder: (context) {
        //? llevamos todo el contenido a un nuevo widget del tipo stateful para que
        //? podamos realizar los cambios cuando se presione el setState sobre
        //? el widget AlertDialog que está presente superpuesto en la página
        //? anfitrión
        return RegisterIncidentmodal(
          incidentsType: incidentsType,
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBrandPrimaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          showSendIncident();
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                H2(
                  text: "Alertas Generales",
                ),
                spacing12Height,
                FutureBuilder(
                  future: apiService.getIncidents(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //! capturamos los datos que nos trae el FutureBuilder
                      //! que es una lista del tipo IncidentModel
                      List<IncidentModel> incidents = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: incidents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: KkBrandFontColor,
                                  blurRadius: 12,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: H4(
                                text: incidents[index].tipoIncidente.titulo,
                                fontWeight: FontWeight.w600,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H5(
                                      text: incidents[index]
                                          .datosCiudadano
                                          .nombres),
                                  H6(
                                    text:
                                        "DNI: ${incidents[index].datosCiudadano.dni}",
                                  ),
                                  H6(text: incidents[index].fechaCreacion),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Uri uriPhone = Uri(
                                        scheme: "tel",
                                        path: incidents[index]
                                            .datosCiudadano
                                            .telefono,
                                      );
                                      launchUrl(uriPhone);
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/icons/phone.svg",
                                      color: kBrandPrimaryColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Uri url = Uri.parse(
                                        "https://www.google.com/maps/search/?api=1&query=${incidents[index].latitud},${incidents[index].longitud}",
                                      );
                                      launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/icons/map.svg",
                                      color: kBrandPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return loadingWidget;
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
