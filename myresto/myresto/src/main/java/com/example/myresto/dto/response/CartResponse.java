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

  public CartResponse(String title, int price, long quantity, String photoFood, long id) {
    this.title = title;
    this.price = price;
    this.quantity = quantity;
    this.photoFood = photoFood;
    this.id = id;
  }

  public CartResponse() {}

  public static CartResponse fromCart(Cart cart) {
    String title = cart.getFood().getTitle();
    int price = cart.getFood().getPrice();
    long quantity = cart.getQuantity();
    String photoFood = cart.getFood().getImage();
    long id = cart.getId();
    return new CartResponse(title, price, quantity, photoFood, id);
  }
}
