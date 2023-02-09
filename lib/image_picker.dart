import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({Key? key}) : super(key: key);

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? image;
  Future pickImage(ImageSource source) async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    }on PlatformException catch(e){
      print("failed to pick image: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        padding: EdgeInsets.all(32),
        width: size.width,
        child: Column(
          children: [
            Spacer(),
            image != null
            ? ClipOval(
              child: Image.file(
                image!,
                width: 260,
                height: 400,
              ),
            ) : FlutterLogo(size: 160,),

            // image != null
            //     ? ImageWidget(
            //   image: image!,
            //   onClick: (source)=> pickImage(source)
            // ) : FlutterLogo(size: 160,),

            SizedBox(height: 25,),
            Text(
              'Image Picker', style: TextStyle(fontSize: 40),),
            SizedBox(height: 47,),
            ElevatedButton(
                onPressed: ()=> pickImage(ImageSource.gallery),
                child: Icon(Icons.image_outlined)),
            SizedBox(height: 47,),
            ElevatedButton(
                onPressed: ()=> pickImage(ImageSource.camera),
                child: Icon(Icons.camera_alt_outlined)),
            Spacer()
          ],
        ),
      ),
    );
  }
}
