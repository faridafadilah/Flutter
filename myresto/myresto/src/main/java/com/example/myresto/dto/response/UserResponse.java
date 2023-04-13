package com.example.myresto.dto.response;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserResponse {
  private long id;
  private String username;
  private String email;
  private long nik;
  private Date tanggalLahir;
  private String alamat;
  private String jenisKelamin;
  private String kota;
  private String pathPhoto;
  private String filePhoto;
}
