package com.example.myresto.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import com.example.myresto.dto.request.UlasanRequest;
import com.example.myresto.dto.response.UlasanResponse;
import com.example.myresto.models.Foods;
import com.example.myresto.models.History;
import com.example.myresto.models.Ulasan;
import com.example.myresto.models.Users;
import com.example.myresto.repository.FoodRepository;
import com.example.myresto.repository.HistoryRepository;
import com.example.myresto.repository.UlasanRepository;
import com.example.myresto.repository.UserRepository;

@RequestMapping("/api/ulasan")
@RestController
public class UlasanController {
  @Autowired
  private UlasanRepository repository;

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private FoodRepository foodRepository;

  @Autowired
  private HistoryRepository historyRepository;

  @PostMapping("")
  public ResponseEntity<ResponAPI<UlasanResponse>> createUlasan(@ModelAttribute UlasanRequest body) {
    ResponAPI<UlasanResponse> responAPI = new ResponAPI<>();
    
    System.out.println(body.getUserId()+ " "+body.getFoodId());
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

    Optional<History> hOptional = historyRepository.findById(body.getHistoryId());
    if (!hOptional.isPresent()) {
      responAPI.setMessage("Data History tidak ditemukan!");
      responAPI.setStatus(HttpStatus.BAD_REQUEST.value());
      return ResponseEntity.badRequest().body(responAPI);
    }

    try {
      Ulasan ulasan = new Ulasan();
      Foods foods = fOptional.get();
      Users users = uOptional.get();
      History history = hOptional.get();

      ulasan.setComment(body.getComment());
      ulasan.setFood(foods);
      ulasan.setUsers(users);
      ulasan.setHistory(history);
      ulasan.setCreatedAt(new Date());
      ulasan.setRating(body.getRating());
      repository.save(ulasan);

      UlasanResponse ulasanResponse = UlasanResponse.fromCart(ulasan);
      responAPI.setData(ulasanResponse);
      responAPI.setMessage("Successfully add cart");
      responAPI.setStatus(HttpStatus.CREATED.value());
      return ResponseEntity.ok(responAPI);
    } catch (Exception e) {
      responAPI.setMessage(e.getMessage());
      responAPI.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responAPI);
    }
  }

  @DeleteMapping("/{id}")
  public boolean deleteUlasan(@PathVariable("id") long id) {
    Optional<Ulasan> uOptional = repository.findById(id);
    if(!uOptional.isPresent()) {
      return false;
    }
    repository.deleteById(id);
    return true;
  }

  @GetMapping("/all/{id}")
public ResponseEntity<ResponAPI<List<UlasanResponse>>> getAll(@PathVariable("id") long id) {
    try {
        ResponAPI<List<UlasanResponse>> responAPI = new ResponAPI<>();
        Optional<Foods> uOptional = foodRepository.findById(id);
        if (!uOptional.isPresent()) {
            responAPI.setMessage("Data User tidak ditemukan!");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
        }
        List<UlasanResponse> ulasanResponses = new ArrayList<>();
        Map<String, Double> userRatingMap = new HashMap<>();
        repository.findAllByFood(uOptional.get()).forEach(ulas -> {
            String username = ulas.getUsers().getNama();
            Double rating = ulas.getRating();
            if (userRatingMap.containsKey(username)) {
                Double currentRating = userRatingMap.get(username);
                if (currentRating > rating) {
                    userRatingMap.put(username, rating);
                }
            } else {
                userRatingMap.put(username, rating);
                UlasanResponse response = new UlasanResponse();
                response.setId(ulas.getId());
                response.setFoodId(ulas.getFood().getId());
                response.setUserId(ulas.getUsers().getId());
                response.setTanggal(ulas.getCreatedAt().toString());
                response.setComment(ulas.getComment());
                response.setRating(ulas.getRating());
                response.setUsername(username);
                ulasanResponses.add(response);
            }
        });

        responAPI.setData(ulasanResponses);
        responAPI.setStatus(200);
        responAPI.setMessage("Successfully get ulasan");
        return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
        return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}

  @GetMapping("/{id}")
  public ResponseEntity<ResponAPI<UlasanResponse>> getById(@PathVariable("id") long historyId) {
    ResponAPI<UlasanResponse> responAPI = new ResponAPI<>();
    try {
    Optional<History> hOptional = historyRepository.findById(historyId);
    if (!hOptional.isPresent()) {
      responAPI.setMessage("Data tidak ditemukan!");
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
    }
    History history = hOptional.get();
    Optional<Ulasan> uOptional = repository.findByHistory(history);
    if (!uOptional.isPresent()) {
      responAPI.setMessage("Data tidak ditemukan!");
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
    }
    Ulasan ulasan = uOptional.get();
    UlasanResponse ulasanResponse = UlasanResponse.fromCart(ulasan);
      responAPI.setData(ulasanResponse);
      responAPI.setMessage("Successfully get ulasan");
      responAPI.setStatus(HttpStatus.CREATED.value());
      return ResponseEntity.ok(responAPI);
    } catch (Exception e) {
      responAPI.setMessage(e.getMessage());
      responAPI.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responAPI);
    }
  }
}
