package com.example.myresto.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.myresto.base.ResponAPI;
import com.example.myresto.dto.request.FavoriteRequest;
import com.example.myresto.dto.response.FavoriteResponse;
import com.example.myresto.models.Favorite;
import com.example.myresto.models.Foods;
import com.example.myresto.models.Users;
import com.example.myresto.repository.FavoriteRepository;
import com.example.myresto.repository.FoodRepository;
import com.example.myresto.repository.UserRepository;

@RequestMapping("/api/favorite")
@RestController
public class FavoriteController {
  @Autowired
  private FavoriteRepository repository;

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private FoodRepository foodRepository;
  
  public boolean createFavorite(FavoriteRequest body) {
    Optional<Foods> fOptional = foodRepository.findById(body.getFoodId());
    if (!fOptional.isPresent()) {
      return false;
    }

    Optional<Users> uOptional = userRepository.findById(body.getUserId());
    if (!uOptional.isPresent()) {
      return false;
    }

    try {
      Favorite favorite = new Favorite();
      Foods foods = fOptional.get();
      Users users = uOptional.get();
      Optional<Favorite> cOptional = repository.findByFoodAndUsers(foods, users);
      if (cOptional.isPresent()) {
       return false;
      }
  
     favorite.setFavorite(false);
     favorite.setFood(foods);
     favorite.setUsers(users);
     repository.save(favorite);
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  @PostMapping("/{id}")
  public ResponseEntity<ResponAPI<FavoriteResponse>> updateCart(@ModelAttribute FavoriteRequest body, @PathVariable("id") long id) {
    ResponAPI<FavoriteResponse> responAPI = new ResponAPI<>();
    Optional<Favorite> cOptional = repository.findById(id);
    if (!cOptional.isPresent()) {
      responAPI.setMessage("Data Food tidak ditemukan!");
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
    }
    try {
      Favorite favorite = cOptional.get();
      System.out.println(body.isFavorite());
      favorite.setFavorite(body.isFavorite());
      repository.save(favorite);

      FavoriteResponse favResponse = FavoriteResponse.fromCart(favorite);
      responAPI.setData(favResponse);
      responAPI.setMessage("Successfully favorite food");
      responAPI.setStatus(200);
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @GetMapping("/{id}")
  public ResponseEntity<ResponAPI<List<FavoriteResponse>>> getAll(@PathVariable("id") long id) {
    try {
      ResponAPI<List<FavoriteResponse>> responAPI = new ResponAPI<>();
      Optional<Users> uOptional = userRepository.findById(id);
      if (!uOptional.isPresent()) {
        responAPI.setMessage("Data User tidak ditemukan!");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
      }
      List<FavoriteResponse> favoriteResponses = new ArrayList<>();
      repository.findAllByUsersAndFavorite(uOptional.get(), true).forEach(cart -> {
        FavoriteResponse favoriteResponse = new FavoriteResponse();
       favoriteResponse.setIdFavorite(cart.getId());
       favoriteResponse.setFoodId(cart.getFood().getId());
       favoriteResponse.setDescription(cart.getFood().getDescription());
       favoriteResponse.setPhotoFood(cart.getFood().getImage());
       favoriteResponse.setPrice(cart.getFood().getPrice());
       favoriteResponse.setTitle(cart.getFood().getTitle());
       favoriteResponse.setFavorite(cart.getFavorite());
       favoriteResponses.add(favoriteResponse);
      });
      responAPI.setData(favoriteResponses);

      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get Cart");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @GetMapping("/all/{id}")
  public ResponseEntity<ResponAPI<List<FavoriteResponse>>> getAllFav(@PathVariable("id") long id) {
    try {
      ResponAPI<List<FavoriteResponse>> responAPI = new ResponAPI<>();
      Optional<Users> uOptional = userRepository.findById(id);
      if (!uOptional.isPresent()) {
        responAPI.setMessage("Data User tidak ditemukan!");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
      }
      List<FavoriteResponse> favoriteResponses = new ArrayList<>();
      repository.findAllByUsers(uOptional.get()).forEach(cart -> {
        FavoriteResponse favoriteResponse = new FavoriteResponse();
       favoriteResponse.setIdFavorite(cart.getId());
       favoriteResponse.setFoodId(cart.getFood().getId());
       favoriteResponse.setDescription(cart.getFood().getDescription());
       favoriteResponse.setPhotoFood(cart.getFood().getImage());
       favoriteResponse.setPrice(cart.getFood().getPrice());
       favoriteResponse.setTitle(cart.getFood().getTitle());
       favoriteResponse.setFavorite(cart.getFavorite());
       favoriteResponses.add(favoriteResponse);
      });
      responAPI.setData(favoriteResponses);

      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get Cart");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
