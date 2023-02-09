
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_text_image_test/showdata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as Img;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  TextEditingController cUsername = new TextEditingController();
  TextEditingController cPassword = new TextEditingController();

  Future getImageGallery() async{
    final ImagePicker _picker = ImagePicker();
    //var imageFile = await _picker.pickImage(source: ImageSource.gallery);
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final File? imageFile = File(image!.path);

    setState(() {
      _image = imageFile as File?;
    });
  }

  Future getImageCamera() async{
    final ImagePicker _picker = ImagePicker();
    //var imageFile = await _picker.pickImage(source: ImageSource.camera);
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final File? imageFile = File(image!.path);

    setState(() {
      _image = imageFile as File;
    });
  }

  Future upload(File imageFile) async{
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://192.168.0.103:5000/users");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));

    request.fields['username'] = cUsername.text;
    request.fields['password'] = cPassword.text;
    request.files.add(multipartFile);
    var response = await request.send();

    if(response.statusCode == 200){
      print("image uploaded");
      cUsername.clear();
      cPassword.clear();
      request.files.clear();
      //request.files.clear();
      //print(request.files);
    }else{
      print("upload failed");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('upload image'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Center(
            //   child: _image != null
            //       ? ClipOval(
            //     child: Image.file(
            //       _image!,
            //       width: 160,
            //       height: 160,
            //     ),
            //   )
            //       : FlutterLogo(
            //     size: 160,
            //   ),
            // ),
            TextField(
              controller: cUsername,
              decoration: InputDecoration(
                  hintText: "username"
              ),
            ),


            TextField(
              controller: cPassword,
              decoration: InputDecoration(
                  hintText: "password"
              ),
            ),


            Row(
              children: [
                ElevatedButton(
                  onPressed: getImageGallery,
                  child: const Icon(Icons.image),
                ),
                ElevatedButton(
                  onPressed: getImageCamera,
                  child: const Icon(Icons.camera_alt),
                ),
                Expanded(child: Container()),

              ],
            ),

            ElevatedButton(
              onPressed: (){
                if(cUsername.value.text.isNotEmpty && cPassword.value.text.isNotEmpty && _image.toString().isNotEmpty){
                  upload(_image!);
                }else{
                  print("please fill all the fields");
                }
                //cUsername.value.text.isNotEmpty ? upload(_image!): null;
              },
              child: const Text('Add Data', style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),),
            ),


            ElevatedButton(
              onPressed: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowData()));
                });
              },
              child: const Text('View Data', style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),),
            ),
            
          ],
        ),
      )
    );
  }
}
