package com.example.myresto.dto.response;

import com.example.myresto.models.Favorite;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FavoriteResponse {
  private long foodId;
  private long idFavorite;
  private String title;
  private int price;
  private String photoFood;
  private String description;
  private boolean favorite;

  public FavoriteResponse(long foodId, long idFavorite, String title, int price, String photoFood, String description, boolean favorite) {
    this.foodId = foodId;
    this.idFavorite = idFavorite;
    this.title = title;
    this.price = price;
    this.photoFood = photoFood;
    this.description = description;
    this.favorite = favorite;
  }

  public FavoriteResponse() {}

  public static FavoriteResponse fromCart(Favorite favorite) {
    String title = favorite.getFood().getTitle();
    int price = favorite.getFood().getPrice();
    String description = favorite.getFood().getDescription();
    String photoFood = favorite.getFood().getImage();
    long idFavorite = favorite.getId();
    long foodId = favorite.getFood().getId();
    boolean isFavorite = favorite.getFavorite();
    return new FavoriteResponse(foodId, idFavorite, title, price, photoFood, description, isFavorite);
  }
}
