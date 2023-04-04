import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myresto/core/models/foods_mdl.dart';
import 'package:myresto/core/services/food_services.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:myresto/ui/widgets/custom_textfield.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Add Food"),
      ),
      body: AddBody(),
    );
  }
}

class AddBody extends StatefulWidget {
  @override
  _AddBodyState createState() => _AddBodyState();
}

class _AddBodyState extends State<AddBody> {
  int _counter = 0;
  File image;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var fullDescriptionControlelr = TextEditingController();
  var priceController = TextEditingController();

  void imagePick() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
      });
    }
  }

  void addMakanan() async {
    _counter++;

    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        fullDescriptionControlelr.text.isNotEmpty &&
        image != null) {
      FoodModel foodModel = FoodModel(
          title: titleController.text,
          description: descriptionController.text,
          price: int.parse(priceController.text),
          fullDescription: fullDescriptionControlelr.text,
          id: '$_counter',
          imageFile: await MultipartFile.fromFile(image.path));
      ToastUtils.show("Membuat Makanan");

      FoodResponse response = await FoodsServices.createFood(foodModel);
      if (response.status == 200) {
        ToastUtils.show(response.message);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/dashboard", (Route<dynamic> routes) => false);
        });
      } else {
        ToastUtils.show(response.message);
      }
    } else {
      ToastUtils.show("Field not empty!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              child: InkWell(
                onTap: () => imagePick(),
                child: image != null
                    ? Image.file(
                        image,
                        width: 100,
                        height: 100,
                      )
                    : Icon(
                        Icons.add_photo_alternate,
                        color: Colors.pinkAccent,
                        size: 100,
                      ),
              ),
            ),
          ),
          SizedBox(height: 20),
          CustomTextField(
              action: TextInputAction.done,
              type: TextInputType.text,
              controller: titleController,
              hinText: 'Nama Makanan'),
          SizedBox(height: 10),
          CustomTextField(
              action: TextInputAction.done,
              type: TextInputType.text,
              controller: descriptionController,
              hinText: 'Deskripsi'),
          SizedBox(height: 10),
          CustomTextField(
              action: TextInputAction.done,
              type: TextInputType.multiline,
              controller: fullDescriptionControlelr,
              hinText: 'Full Deskripsi'),
          SizedBox(height: 10),
          CustomTextField(
              action: TextInputAction.done,
              type: TextInputType.number,
              controller: priceController,
              hinText: 'Harga'),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => addMakanan(),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Foods',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
