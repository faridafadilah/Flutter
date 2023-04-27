package com.example.myresto.dto.response;

import com.example.myresto.models.Ulasan;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UlasanResponse {
  private long id;
  private String username;
  private double rating;
  private String comment;
  private long foodId;
  private long userId;
  private String tanggal;

  public UlasanResponse(long id, String username, double rating, String comment, long foodId, long userId, String tanggal) {
    this.id = id;
    this.username = username;
    this.rating = rating;
    this.comment = comment;
    this.foodId = foodId;
    this.userId = userId;
    this.tanggal = tanggal;
  }

  public UlasanResponse() {}

  public static UlasanResponse fromCart(Ulasan ulasan){
    long id = ulasan.getId();
    String username = ulasan.getUsers().getNama();
    double rating = ulasan.getRating();
    String comment = ulasan.getComment();
    long foodId = ulasan.getFood().getId();
    long userId = ulasan.getUsers().getId();
    String tanggal = ulasan.getCreatedAt().toString();
    return new UlasanResponse(id, username, rating, comment, foodId, userId, tanggal);
  }
}
