import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function? onSelectImage;

  const ImageInput(this.onSelectImage, {super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    //Armazenar imagens no diretorio da app;
    //appDir pega o local de armazenamento;
    final appDir = await syspath.getApplicationDocumentsDirectory();
    //fileName referesse apenas ao nome da imagem;
    String fileName = path.basename(_storedImage!.path);
    //savedImage salva a imagem com o caminho especifico;
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName',
    );
    //Passa a imagem p/ a função callback notificando no formulário;
    widget.onSelectImage!(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.5),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                    _storedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
              )
              : const Text('Nenhuma Imagem!'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tirar Foto'),
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
