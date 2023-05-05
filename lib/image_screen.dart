import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemprorary = File(image.path);
      setState(() => this.image = imageTemprorary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _uploadImageDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true, //true-out side click dissmisses
        builder: (param) {
          return AlertDialog(
            title: Text('Upload image'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                    print('----------> uploaded from gallery');
                    Navigator.pop(context);
                  },
                  child: Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('---------> Image: $image');
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                    print('---------->uploaded from camera');
                  },
                  child: Text('Camera'),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ca image picker ref'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
             // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image != null ?
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0),
                        child: ClipOval(
                          child: Image.file(
                            image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,),
                        ),
                      ):FlutterLogo(),
                      SizedBox(width: 20,),
                      SizedBox(
                        height: 40,
                        width: 125,
                        child: ElevatedButton(
                            onPressed: () {
                              _uploadImageDialog(context);
                            },
                            child: Text('+ Add Photo')),
                      )
                    ],
                  ),

              ],
            ),
          ),
         ));
  }
}
