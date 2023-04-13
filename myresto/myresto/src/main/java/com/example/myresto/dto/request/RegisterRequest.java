package com.example.myresto.dto.request;

import java.util.Date;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {
  private String username;
  @NotBlank
  @Size(max = 120)
  private String password;
  @Email
  private String email;
  private String nama;
  private long nik;
  private String tanggalLahir;
  private String alamat;
  private String jenisKelamin;
  private String kota;
}
