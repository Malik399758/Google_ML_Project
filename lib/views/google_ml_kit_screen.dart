
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class GoogleMlKitScreen extends StatefulWidget {
  const GoogleMlKitScreen({super.key});

  @override
  State<GoogleMlKitScreen> createState() => _GoogleMlKitScreenState();
}

class _GoogleMlKitScreenState extends State<GoogleMlKitScreen> {
  File? _image;
  String resultText = '';

  // image pick from gallery
  Future<void> imageFromGallery(ImageSource imageSource)async{
    try{
      final selectedImage = await ImagePicker().pickImage(source: imageSource);

      if(selectedImage != null){
        setState(() {
          _image = File(selectedImage.path);
        });
      }

    }catch(e){
      print('Image selected error ${e.toString()}');
    }
  }


  // Read text from image
  Future<void> readText()async{
    try{
      InputImage inputImage = InputImage.fromFile(_image!);
      final TextRecognizer textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      if(_image == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image first')));
      }

      setState(() {
        resultText = recognizedText.text;
      });
      textRecognizer.close();
    }catch(e){
      print('Text recognition error ${e.toString()}');

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Text Recognition',style: TextStyle(fontSize: 21),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height : 300,
              width : 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _image != null ? Image.file(_image!.absolute,fit: BoxFit.cover,) : Center(child: Text('No image selected')),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  //imageFromGallery();
                  bottomSheet();
                },
                    child: Text('Select image')),
                ElevatedButton(onPressed: (){
                  readText();
                },
                    child: Text('Text Recognition')),

              ],
            ),
            Center(child: Text(resultText.toString(),style: TextStyle(fontSize: 15),textAlign: TextAlign.center,)),
          ],
        ),
      ),
    );
  }
  Future<void> bottomSheet()async{
    return showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                imageFromGallery(ImageSource.gallery);
                Navigator.pop(context);
              },
                child: Icon(Icons.image,size: 40,)),
            GestureDetector(
              onTap: (){
                imageFromGallery(ImageSource.camera);
                Navigator.pop(context);
              },
                child: Icon(Icons.camera_alt,size: 40,))
          ],
        ),
      );
    });
  }
}
