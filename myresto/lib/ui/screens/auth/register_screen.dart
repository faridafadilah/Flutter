import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myresto/core/services/auth_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:myresto/ui/widgets/input_field.dart';
import 'package:myresto/ui/widgets/primary_button.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: RegisterBody(),
        ),
      ),
    );
  }
}

class RegisterBody extends StatefulWidget {
  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var emailController = TextEditingController();
  var namaController = TextEditingController();
  var nikController = TextEditingController();
  var tanggalController = TextEditingController();
  var alamatController = TextEditingController();
  var jenisKelaminController = TextEditingController();
  var kotaController = TextEditingController();

  File image;

  void register() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        namaController.text.isNotEmpty &&
        nikController.text.isNotEmpty &&
        tanggalController.text.isNotEmpty &&
        alamatController.text.isNotEmpty &&
        jenisKelaminController.text.isNotEmpty &&
        kotaController.text.isNotEmpty &&
        image != null) {
      if (passwordController.text == confirmPasswordController.text) {
        Map<String, dynamic> data = {
          "username": usernameController.text,
          "password": passwordController.text,
          "email": emailController.text,
          "nama": namaController.text,
          "nik": nikController.text,
          "image": await MultipartFile.fromFile(image.path),
          "tanggalLahir": tanggalController.text.toString(),
          "alamat": alamatController.text,
          "jenisKelamin": jenisKelaminController.text,
          "kota": kotaController.text
        };

        ToastUtils.show("Mencoba Mendaftar..");
        var response = await AuthService.register(data);
        if (response.status == 201) {
          ToastUtils.show(response.message);
          Navigator.pop(context);
        } else {
          ToastUtils.show(response.message);
        }
      } else {
        ToastUtils.show("Password no match!");
      }
    } else {
      ToastUtils.show("Fiel not Empty!");
    }
  }

  void PickTanggal() {
    showMaterialDatePicker(
      context: context,
      selectedDate: DateTime.now(),
      onChanged: (value) {
        tanggalController.text = DateFormat("yyyy-MM-dd").format(value);
      },
    );
  }

  void PickGender() {
    List<String> gender = <String>["Laki-laki", "Perempuan"];
    showMaterialRadioPicker(
      context: context,
      title: "Pilih Gender",
      items: gender,
      onChanged: (value) {
        jenisKelaminController.text = value;
      },
    );
  }

  void imagePick() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          color: Colors.pinkAccent,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back,
                            color: Colors.white, size: 30)),
                  ),
                ),
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                InkWell(
                    onTap: () => imagePick(),
                    child: image == null
                        ? Icon(Icons.account_circle,
                            size: 70, color: Colors.white)
                        : Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                image: FileImage(File(image.path)),
                              ),
                            ),
                          ))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
          child: Column(
            children: <Widget>[
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: usernameController,
                hintText: "Username",
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: passwordController,
                hintText: "Password",
                secureText: true,
              ),
              SizedBox(height: 15),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                secureText: true,
              ),
              SizedBox(height: 15),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.emailAddress,
                controller: emailController,
                hintText: "Email Address",
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: namaController,
                hintText: "Nama Lengkap",
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.number,
                controller: nikController,
                hintText: "NIK",
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: tanggalController,
                hintText: "Tanggal",
                readOnly: true,
                onTap: () => PickTanggal(),
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.newline,
                type: TextInputType.multiline,
                controller: alamatController,
                hintText: "Alamat",
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: jenisKelaminController,
                readOnly: true,
                hintText: "Jenis Kelamin",
                onTap: () => PickGender(),
              ),
              SizedBox(height: 10),
              InputField(
                action: TextInputAction.done,
                type: TextInputType.text,
                controller: kotaController,
                hintText: "Kota",
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: PrimaryButton(
                  color: Colors.pinkAccent,
                  text: "REGISTER",
                  onClick: () => register(),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        )
      ],
    );
  }
}
