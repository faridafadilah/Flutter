package com.example.myresto.models;

import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import com.fasterxml.jackson.annotation.JsonBackReference;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Users {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;
  private String username;
  @Email
  private String email;
  private String nama;
  @Column(unique = true)
  private long nik;
  private String tanggalLahir;
  private String alamat;
  private String jenisKelamin;
  private String kota;
  private String pathPhoto;
  private String filePhoto;
  @NotBlank
  @Size(max = 120)
  private String password;

  @JsonBackReference
  @OneToMany(mappedBy = "users")
  private List<Cart> carts;
}
