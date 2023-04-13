package com.example.myresto.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CartRequest {
  private Long foodId;
  private Long quantity;
  private Long userId;
}
