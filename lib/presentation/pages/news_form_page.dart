import 'package:alerts/data/services/api_service.dart';
import 'package:alerts/domain/models/news_model.dart';
import 'package:alerts/presentation/general/widgets/general_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:alerts/presentation/general/ui/spacing.dart';
import 'package:alerts/presentation/general/ui/text.dart';
import 'package:alerts/presentation/general/utils/types.dart';
import 'package:alerts/presentation/general/widgets/common_button_widget.dart';
import 'package:alerts/presentation/general/widgets/common_text_field_widget.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class NewsFormPage extends StatefulWidget {
  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  //! creamos los controladores de los TextField para poder ser capturados la data
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _linkController = TextEditingController();

  //! instanciamos una clase del tipo ImagePicker para poder acceder a sus
  ImagePicker imagePicker = ImagePicker();

  //! variable que puede ser nulo para la captura de las imágenes que se obtine
  XFile? image;

  //! variable parta controlar el formulario de envío de la noticia
  final formKey = GlobalKey<FormState>();

  //! variable para poder crear mensages de errores
  String errorMessage = "";

  //! para el control del widget loading
  bool isLoading = false;

  //! esta función hace el llamado para subir las imágenes desde la galería
  Future<void> getImageGallery() async {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      errorMessage = "";
      setState(() {});
    }
  }

  //! esta función hace el llamado para subir las imágenes desde la cámara
  Future<void> getImageCamera() async {
    image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      errorMessage = "";
      setState(() {});
    }
  }

  //! función para registrar noticias
  registerNews() async {
    if (formKey.currentState!.validate()) {
      if (image != null) {
        errorMessage = "";
        isLoading = true;
        setState(() {});
        //! instanciamos la clase ApiService para poder usar los métodos de ella
        ApiService apiService = ApiService();
        //**--acá se especifica la ruta donde se traerá la imagen creada comprimida */
        //! image es un XFile (objeto de la libreria Picker) no es igual que el objeto
        //! newImageFile que es un objeto nativo de Flutter(Dart) reducido en size
        //? toma image de la ruta que se indica, se comprime la imagen y cra una
        //? nueva imagen comprimida en otra rutaque será la que se usará para
        //?subir al server
        File newImageFile = await FlutterNativeImage.compressImage(image!.path);
        //? reutilizamos la clase del tipo Newsmodel
        NewsModel model = NewsModel(
          id: 0,
          link: _linkController.text,
          titulo: _titleController.text,
          fecha: DateTime.now().toString().substring(0, 10),
          imagen: newImageFile.path,
        );
        //* hacemos el llamado del método registerNews de la clase ApisService y
        //* enviamos el parámetro del tipo model para ser subido al server
        apiService.registerNews(model).then((value) {
          isLoading = false;
          Navigator.pop(context);
        }).catchError((error) {
          isLoading = false;
          setState(() {});
        });
      } else {
        errorMessage = "Selecciona una imagen";
        setState(() {});
      }
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
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      H2(
                        text: "Registrar Notica",
                      ),
                      spacing30Height,
                      CommomTextFieldWidget(
                        label: "Título:",
                        hintText: "Ingresa un título",
                        type: InputType.text,
                        controller: _titleController,
                      ),
                      spacing20Height,
                      CommomTextFieldWidget(
                        label: "Link:",
                        hintText: "Ingresa un link",
                        type: InputType.text,
                        controller: _linkController,
                      ),
                      spacing20Height,
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getImageGallery();
                              },
                              icon: const Icon(Icons.image),
                              label: H5(
                                text: "Galería",
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          spacing12Width,
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getImageCamera();
                              },
                              icon: const Icon(Icons.camera),
                              label: H5(
                                text: "Cámara",
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      spacing20Height,
                      //! acá se visualizará la imagen que se desea enviar
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            //! condicionamos para visualizar la imágen a cargar
                            image: image != null
                                ? FileImage(File(image!.path))
                                : const AssetImage(
                                        //**-- imagen que se visulizará al inicio -- */
                                        "assets/images/placeholder.webp")
                                    //? forzamos a comportarse como ImageProvider
                                    as ImageProvider,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            H5(
                              text: errorMessage,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CommonButtonWidget(
                text: "Registrar",
                onPressed: () {
                  registerNews();
                },
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.6),
                  child: loadingWidget,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
