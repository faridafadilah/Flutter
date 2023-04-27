package com.example.myresto.dto.response;

import com.example.myresto.models.History;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class HistoryResponse {
  private Long id;
  private long foodId;
  private String title;
  private long price;
  private String image;
  private long userId;
  private String tanggal;
  private long count;
  private long totalPrice;

  public HistoryResponse(Long id, long foodId, String title, Long price, String image, long userId, String tanggal, long count, long totalPrice) {
    this.id = id;
    this.foodId = foodId;
    this.title = title;
    this.price = price;
    this.image = image;
    this.userId = userId;
    this.tanggal = tanggal;
    this.count = count;
    this.totalPrice = totalPrice;
  }

  public HistoryResponse() {}

  public static HistoryResponse fromCart(History history) {
    Long id = history.getId();
    long foodId = history.getFood().getId();
    String title = history.getFood().getTitle();
    long totalPrice = history.getTotalPrice();
    String image = history.getFood().getImage();
    long userId = history.getUsers().getId();
    String tanggal = history.getCreatedAt().toString();
    long count = history.getCount();
    long price = history.getFood().getPrice();
    return new HistoryResponse(id, foodId, title, price, image, userId, tanggal, count, totalPrice);
  }
  
}
