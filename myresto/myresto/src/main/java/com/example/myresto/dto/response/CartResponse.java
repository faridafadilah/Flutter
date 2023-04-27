package com.example.myresto.dto.response;

import com.example.myresto.models.Cart;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CartResponse {
  private long id;
  private String title;
  private int price;
  private long quantity;
  private String photoFood;
  private long foodId;

  public CartResponse(String title, int price, long quantity, String photoFood, long id, long foodId) {
    this.title = title;
    this.price = price;
    this.quantity = quantity;
    this.photoFood = photoFood;
    this.id = id;
    this.foodId = foodId;
  }

  public CartResponse() {}

  public static CartResponse fromCart(Cart cart) {
    String title = cart.getFood().getTitle();
    int price = cart.getFood().getPrice();
    long quantity = cart.getQuantity();
    String photoFood = cart.getFood().getImage();
    long id = cart.getId();
    long foodId = cart.getFood().getId();
    return new CartResponse(title, price, quantity, photoFood, id, foodId);
  }
}
