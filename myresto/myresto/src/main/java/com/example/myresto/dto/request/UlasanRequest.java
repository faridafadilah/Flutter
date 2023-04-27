package com.example.myresto.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UlasanRequest {
  private long foodId;
  private long userId;
  private String comment;
  private double rating;
  private long historyId;
}
