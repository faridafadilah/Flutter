package com.example.myresto.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FavoriteRequest {
  private Long foodId;
  private boolean favorite;
  private Long userId;
}
