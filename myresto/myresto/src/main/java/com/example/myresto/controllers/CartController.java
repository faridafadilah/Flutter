package com.example.myresto.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.myresto.base.ResponAPI;
import com.example.myresto.dto.request.CartRequest;
import com.example.myresto.dto.response.CartResponse;
import com.example.myresto.models.Cart;
import com.example.myresto.models.Foods;
import com.example.myresto.models.Users;
import com.example.myresto.repository.CartRepository;
import com.example.myresto.repository.FoodRepository;
import com.example.myresto.repository.UserRepository;

@RestController
@RequestMapping("/api/carts")
public class CartController {
  @Autowired
  private CartRepository repository;

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private FoodRepository foodRepository;

  @PostMapping("")
  public ResponseEntity<ResponAPI<CartResponse>> createCart(@ModelAttribute CartRequest body) {
    ResponAPI<CartResponse> responAPI = new ResponAPI<>();
    Optional<Foods> fOptional = foodRepository.findById(body.getFoodId());
    if (!fOptional.isPresent()) {
      responAPI.setMessage("Data Food tidak ditemukan!");
      responAPI.setStatus(HttpStatus.BAD_REQUEST.value());
      return ResponseEntity.badRequest().body(responAPI);
    }

    Optional<Users> uOptional = userRepository.findById(body.getUserId());
    if (!uOptional.isPresent()) {
      responAPI.setMessage("Data User tidak ditemukan!");
      responAPI.setStatus(HttpStatus.BAD_REQUEST.value());
      return ResponseEntity.badRequest().body(responAPI);
    }

    try {
      Cart cart = new Cart();
      Foods foods = fOptional.get();
      Users users = uOptional.get();
      Optional<Cart> cOptional = repository.findByFoodAndUsers(foods, users);
      if (cOptional.isPresent()) {
        responAPI.setMessage("Data Sudah dimasukan ke cart!");
        responAPI.setStatus(HttpStatus.BAD_REQUEST.value());
        return ResponseEntity.badRequest().body(responAPI);
      }
  
      cart.setQuantity(body.getQuantity());
      cart.setFood(foods);
      cart.setUsers(users);
      repository.save(cart);

      CartResponse cartResponse = CartResponse.fromCart(cart);
      responAPI.setData(cartResponse);
      responAPI.setMessage("Successfully add cart");
      responAPI.setStatus(HttpStatus.OK.value());
      return ResponseEntity.ok(responAPI);
    } catch (Exception e) {
      responAPI.setMessage(e.getMessage());
      responAPI.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responAPI);
    }
  }

  @PostMapping("/{id}")
  public ResponseEntity<ResponAPI<CartResponse>> updateCart(@ModelAttribute CartRequest body,
      @PathVariable("id") long id) {
    ResponAPI<CartResponse> responAPI = new ResponAPI<>();
    Optional<Cart> cOptional = repository.findById(id);
    if (!cOptional.isPresent()) {
      responAPI.setMessage("Data Food tidak ditemukan!");
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
    }
    try {
      Cart cart = cOptional.get();
      cart.setQuantity(body.getQuantity());
      repository.save(cart);

      CartResponse cartResponse = CartResponse.fromCart(cart);
      responAPI.setData(cartResponse);
      responAPI.setMessage("Successfully add cart");
      responAPI.setStatus(200);
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @GetMapping("/{id}")
  public ResponseEntity<ResponAPI<List<CartResponse>>> getAll(@PathVariable("id") long id) {
    try {
      ResponAPI<List<CartResponse>> responAPI = new ResponAPI<>();
      Optional<Users> uOptional = userRepository.findById(id);
      if (!uOptional.isPresent()) {
        responAPI.setMessage("Data User tidak ditemukan!");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
      }
      List<CartResponse> cartResponses = new ArrayList<>();
      repository.findAllByUsers(uOptional.get()).forEach(cart -> {
        CartResponse cartResponse = new CartResponse();
        cartResponse.setTitle(cart.getFood().getTitle());
        cartResponse.setPrice(cart.getFood().getPrice());
        cartResponse.setQuantity(cart.getQuantity());
        cartResponse.setPhotoFood(cart.getFood().getImage());
        cartResponse.setId(cart.getId());
        cartResponse.setFoodId(cart.getFood().getId());
        cartResponses.add(cartResponse);
      });
      responAPI.setData(cartResponses);

      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get Cart");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @DeleteMapping("/{id}")
  public boolean deleteCart(@PathVariable("id") long id) {
    Optional<Cart> uOptional = repository.findById(id);
    if (!uOptional.isPresent()) {
      return false;
    }
    repository.deleteById(id);
    return true;
  }
}
