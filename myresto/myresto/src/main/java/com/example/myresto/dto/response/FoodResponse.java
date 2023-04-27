package com.example.myresto.dto.response;

import java.util.List;

import com.example.myresto.models.Favorite;
import com.example.myresto.models.Foods;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FoodResponse {
  private Long id;
  private String title;
  private String description;
  private String fullDescription;
  private int price;
  private String image;
  private boolean favorite;

  public FoodResponse(Long id, String title, String description, String fullDescription, int price, String image,
      boolean favorite) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.fullDescription = fullDescription;
    this.price = price;
    this.image = image;
    this.favorite = favorite;
  }

  public FoodResponse() {}

  public void setFavorite(List<Favorite> favorites) {
    for (Favorite fav : favorites) {
      if (fav.getFood().getId().equals(this.id) && fav.getFavorite() == true) {
        this.favorite = true;
        return;
      } else {
        this.favorite = false;
        return;
      }
    }
  }

  public static FoodResponse getInstance(Foods foods) {
    FoodResponse dto = new FoodResponse();
    if(foods != null) {
      try {
        dto.setId(foods.getId());
        dto.setDescription(foods.getDescription());
        dto.setFavorite(foods.getFavorite());
        dto.setFullDescription(foods.getFullDescription());
        dto.setImage(foods.getImage());
        dto.setPrice(foods.getPrice());
        dto.setTitle(foods.getTitle());
        return dto;
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return null;
  }
}
