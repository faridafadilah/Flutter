class ActionModel {
  int status;
  String message;
  Data data;

  ActionModel({this.status, this.message, this.data});

  ActionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String username;
  String email;
  int nik;
  String tanggalLahir;
  String alamat;
  String jenisKelamin;
  String kota;
  String pathPhoto;
  String filePhoto;
  String nama;

  Data(
      {this.id,
      this.username,
      this.email,
      this.alamat,
      this.filePhoto,
      this.jenisKelamin,
      this.kota,
      this.nik,
      this.pathPhoto,
      this.tanggalLahir,
      this.nama});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    nik = json['nik'];
    tanggalLahir = json['tanggalLahir'];
    alamat = json['alamat'];
    jenisKelamin = json['jenisKelamin'];
    kota = json['kota'];
    pathPhoto = json['pathPhoto'];
    filePhoto = json['filePhoto'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['nik'] = this.nik;
    data['tanggalLahir'] = this.tanggalLahir;
    data['alamat'] = this.alamat;
    data['jenisKelamin'] = this.jenisKelamin;
    data['kota'] = this.kota;
    data['pathPhoto'] = this.pathPhoto;
    data['filePhoto'] = this.filePhoto;
    data['nama'] = this.nama;
    return data;
  }
}
