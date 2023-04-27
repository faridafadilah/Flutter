import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myresto/core/models/action_mdl.dart';
import 'package:myresto/core/services/auth_service.dart';
import 'package:myresto/core/utils/toast_utils.dart';
import 'package:myresto/ui/screens/favorite_screen.dart';
import 'package:myresto/ui/screens/history/history_screen.dart';
import 'package:myresto/ui/screens/profile/update_profile_screen.dart';
import 'package:myresto/ui/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(child: ProfileBody()),
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  ProfileBody({Key key}) : super(key: key);
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  String id, username, email, pathPhoto;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  logout() {
    ToastUtils.show("Mencoba Logout");
    savePref();
    Future.delayed(const Duration(milliseconds: 2000), () {
      ToastUtils.show("Berhasil Logout");
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", (Route<dynamic> routes) => false);
    });
  }

  savePref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.remove('username');
      pref.remove('email');
      pref.remove('profile');
      pref.remove('id');
    });
  }

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      id = pref.getString('id');
      username = pref.getString('username');
      email = pref.getString('email');
      pathPhoto = pref.getString('foto');
    });

    if (username == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", (Route<dynamic> routes) => false);
    } else {
      getProfileData();
    }
  }

  String usernameUser,
      emailUser,
      pathPhotoUser,
      alamat,
      nama,
      nik,
      tanggal,
      jenisKelamin,
      kota;
  ActionModel actionModel;

  getProfileData() async {
    try {
      ActionModel response = await AuthService.getByUser(id.toString());
      if (response.data != null) {
        setState(() {
          alamat = response.data.alamat;
          nama = response.data.nama;
          nik = response.data.nik.toString();
          tanggal = response.data.tanggalLahir;
          jenisKelamin = response.data.jenisKelamin;
          kota = response.data.kota;
          actionModel = response;
          pathPhotoUser = response.data.pathPhoto.toString();
          usernameUser = response.data.username;
          emailUser = response.data.email;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Bagian headers
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                color: Colors.pinkAccent,
                child: SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(60),
                          image: pathPhotoUser != null
                              ? DecorationImage(
                                  image: NetworkImage(pathPhotoUser),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Visibility(
                        visible: usernameUser != null,
                        child: Text(
                          usernameUser ?? '',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Visibility(
                          visible: emailUser != null,
                          child: Text(
                            emailUser ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 32,
                            height: 20,
                            child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProfileScreen(
                                          actionModel: actionModel),
                                    )),
                                child: Icon(Icons.edit, color: Colors.white)),
                          ),
                          Container(
                            width: 32,
                            height: 20,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteScreen(),
                                ),
                              ),
                              child: Container(
                                width: 32,
                                height: 20,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 20,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryScreen(),
                                ),
                              ),
                              child: Container(
                                width: 32,
                                height: 20,
                                child: Icon(
                                  Icons.history,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ))),

            //Bagian field login
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Biodata",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 13),
                            Visibility(
                                visible: kota.toString() != null,
                                child: Text(
                                  "Nama Lengkap: " + nama.toString() ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                )),
                            SizedBox(height: 8),
                            Visibility(
                                visible: kota.toString() != null,
                                child: Text(
                                  "Asal Kota: " + kota.toString() ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                )),
                            SizedBox(height: 8),
                            Visibility(
                                visible: kota.toString() != null,
                                child: Text(
                                  "NIK: " + nik.toString() ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                )),
                            SizedBox(height: 8),
                            Visibility(
                                visible: kota.toString() != null,
                                child: Text(
                                  "Alamat: " + alamat.toString() ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                )),
                            SizedBox(height: 8),
                            Visibility(
                                visible: kota.toString() != null,
                                child: Text(
                                  "Jenis Kelamin: " + jenisKelamin.toString() ??
                                      '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                )),
                            SizedBox(height: 8),
                            Visibility(
                                visible: kota.toString() != null,
                                child: Text(
                                  "Tanggal Lahir: " + tanggal.toString() ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: PrimaryButton(
                color: Colors.pinkAccent,
                text: "LOGOUT",
                onClick: () {
                  logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
