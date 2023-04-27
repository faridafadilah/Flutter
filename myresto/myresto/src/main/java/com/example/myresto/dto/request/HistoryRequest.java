package com.example.myresto.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class HistoryRequest {
  private long foodId;
  private long userId;
  private long totalPrice;
  private long count;
}
