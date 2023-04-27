import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myresto/core/models/action_mdl.dart';
import 'package:myresto/core/services/auth_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:myresto/ui/widgets/input_field.dart';
import 'package:myresto/ui/widgets/primary_button.dart';

class UpdateProfileScreen extends StatelessWidget {
  ActionModel actionModel;
  UpdateProfileScreen({this.actionModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Update Profile"),
      ),
      body: UpdateProfile(actionModel: actionModel),
    );
  }
}

class UpdateProfile extends StatefulWidget {
  ActionModel actionModel;
  UpdateProfile({this.actionModel});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File image;
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var namaController = TextEditingController();
  var nikController = TextEditingController();
  var tanggalController = TextEditingController();
  var alamatController = TextEditingController();
  var jenisKelaminController = TextEditingController();
  var kotaController = TextEditingController();

  void register() async {
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        namaController.text.isNotEmpty &&
        nikController.text.isNotEmpty &&
        tanggalController.text.isNotEmpty &&
        alamatController.text.isNotEmpty &&
        jenisKelaminController.text.isNotEmpty &&
        kotaController.text.isNotEmpty) {
      Map<String, dynamic> data = {
        "username": usernameController.text,
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
      var response = await AuthService.updateProfile(
          data, widget.actionModel.data.id.toString());
      if (response.status == 201) {
        ToastUtils.show(response.message);
        Navigator.pushNamedAndRemoveUntil(
            context, "/profile", (Route<dynamic> routes) => false);
      } else {
        ToastUtils.show(response.message);
      }
    } else {
      ToastUtils.show("Password no match!");
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

  void loadFoods() {
    setState(() {
      usernameController.text = widget.actionModel.data.username;
      emailController.text = widget.actionModel.data.email;
      namaController.text = widget.actionModel.data.nama;
      nikController.text = widget.actionModel.data.nik.toString();
      tanggalController.text = widget.actionModel.data.tanggalLahir;
      alamatController.text = widget.actionModel.data.alamat;
      jenisKelaminController.text = widget.actionModel.data.jenisKelamin;
      kotaController.text = widget.actionModel.data.kota;
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    var imageProvider = image != null
        ? FileImage(image)
        : NetworkImage(widget.actionModel.data.pathPhoto);
    return SingleChildScrollView(
      child: Column(
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
                  SizedBox(height: 10),
                  InkWell(
                      onTap: () => imagePick(),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          image: DecorationImage(
                            image: imageProvider,
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
                    text: "UPDATE",
                    onClick: () => register(),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }
}
