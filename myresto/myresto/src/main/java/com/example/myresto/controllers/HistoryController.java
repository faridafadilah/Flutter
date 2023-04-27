package com.example.myresto.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.myresto.base.ResponAPI;
import com.example.myresto.dto.request.HistoryRequest;
import com.example.myresto.dto.response.HistoryResponse;
import com.example.myresto.models.Foods;
import com.example.myresto.models.History;
import com.example.myresto.models.Users;
import com.example.myresto.repository.FoodRepository;
import com.example.myresto.repository.HistoryRepository;
import com.example.myresto.repository.UserRepository;
import com.example.myresto.specification.HistorySpecification;

@RequestMapping("/api/history")
@RestController
public class HistoryController {
  @Autowired
  private HistoryRepository repository;

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private FoodRepository foodRepository;

  @Autowired
  private HistorySpecification specification;

  @PostMapping("")
  public ResponseEntity<ResponAPI<HistoryResponse>> createHistory(@ModelAttribute HistoryRequest body) {
    ResponAPI<HistoryResponse> responAPI = new ResponAPI<>();
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
      History history = new History();
      Foods foods = fOptional.get();
      Users users = uOptional.get();
      history.setCreatedAt(new Date());
      history.setFood(foods);
      history.setUsers(users);
      history.setTotalPrice(body.getTotalPrice());
      history.setCount(body.getCount());
      repository.save(history);

      HistoryResponse historyResponse = HistoryResponse.fromCart(history);
      responAPI.setData(historyResponse);
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
  public boolean deleteCart(@PathVariable("id") long id) {
    Optional<History> hOptional = repository.findById(id);
    if (!hOptional.isPresent()) {
      return false;
    }
    repository.deleteById(id);
    return true;
  }

  @GetMapping("/all/{id}")
  public ResponseEntity<ResponAPI<Page<HistoryResponse>>> getAll(
      @PathVariable("id") long id,
      @RequestParam(required = false) Integer page,
      @RequestParam(required = false) Integer limit
    ) {
    try {
      ResponAPI<Page<HistoryResponse>> responAPI = new ResponAPI<>();
      Pageable pageable = PageRequest.of(page, limit, Sort.Direction.DESC, "id");
      Page<History> settingPage = repository.findAll(specification.userEqual(id), pageable);
      List<HistoryResponse> responses = settingPage.getContent().stream().map(HistoryResponse::fromCart)
      .collect(Collectors.toList());

      Page<HistoryResponse> data = new PageImpl<>(responses, pageable, settingPage.getTotalElements());
      responAPI.setData(data);
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get ulasan");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      ResponAPI<Page<HistoryResponse>> responAPI = new ResponAPI<>();
      responAPI.setMessage(e.getMessage());
      responAPI.setStatus(500);
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(responAPI);
    }
  } 

  @GetMapping("/{id}")
  public ResponseEntity<ResponAPI<HistoryResponse>> getById(@PathVariable("id") long id) {
    ResponAPI<HistoryResponse> responAPI = new ResponAPI<>();
    try {
    Optional<History> hOptional = repository.findById(id);
    if (!hOptional.isPresent()) {
      responAPI.setMessage("Data tidak ditemukan!");
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responAPI);
    }
    History history = hOptional.get();
    HistoryResponse historyResponse = HistoryResponse.fromCart(history);
      responAPI.setData(historyResponse);
      responAPI.setMessage("Successfully get history");
      responAPI.setStatus(HttpStatus.CREATED.value());
      return ResponseEntity.ok(responAPI);
    } catch (Exception e) {
      responAPI.setMessage(e.getMessage());
      responAPI.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responAPI);
    }
  }

}
