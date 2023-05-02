package com.example.myresto.controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.example.myresto.base.ResponAPI;
import com.example.myresto.dto.request.FavoriteRequest;
import com.example.myresto.dto.request.FoodRequest;
import com.example.myresto.dto.response.FoodResponse;
import com.example.myresto.models.Foods;
import com.example.myresto.models.Ulasan;
import com.example.myresto.repository.FoodRepository;
import com.example.myresto.repository.UlasanRepository;
import com.example.myresto.specification.FoodSpecification;

@RestController
@RequestMapping("/api/foods")
public class FoodController {
  @Autowired
  private FoodRepository repository;

  @Autowired
  private FavoriteController favoriteController;

  @Autowired
  private UlasanRepository ulasanRepository;

  private final Path root = Paths.get("./imageFood");

  @GetMapping("/all")
  public ResponseEntity<ResponAPI<List<FoodResponse>>> getAll() {
    try {
      List<FoodResponse> foods = new ArrayList<>();
      repository.findAll().forEach(food -> {
        FoodResponse foodResponse = new FoodResponse();
        foodResponse.setId(food.getId());
        foodResponse.setDescription(food.getDescription());
        foodResponse.setFullDescription(food.getFullDescription());
        foodResponse.setImage(food.getImage());
        foodResponse.setPrice(food.getPrice());
        foodResponse.setTitle(food.getTitle());
        foodResponse.setFavorite(food.getFavorite().getFavorite());
        double averageRating = getAverageRatingByFoodId(food.getId());
        foodResponse.setAverageRating(averageRating); 
        foods.add(foodResponse);
      });
      ResponAPI<List<FoodResponse>> responAPI = new ResponAPI<>();
      responAPI.setData(foods);
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get foods");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @GetMapping("/{id}")
  public ResponseEntity<ResponAPI<FoodResponse>> getById(@PathVariable("id") long id) {
    Optional<Foods> foods = repository.findById(id);
    ResponAPI<FoodResponse> responAPI = new ResponAPI<>();
    if (foods.isPresent()) {
      Foods food = foods.get();
      FoodResponse foodResponse = new FoodResponse();
      foodResponse.setId(food.getId());
      foodResponse.setDescription(food.getDescription());
      foodResponse.setFullDescription(food.getFullDescription());
      foodResponse.setImage(food.getImage());
      foodResponse.setPrice(food.getPrice());
      foodResponse.setTitle(food.getTitle());
      foodResponse.setFavorite(food.getFavorite().getFavorite());
      double averageRating = getAverageRatingByFoodId(food.getId());
      foodResponse.setAverageRating(averageRating); 
      
      responAPI.setData(foodResponse);
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get foods");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } else {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responAPI);
    }
  }

  private double getAverageRatingByFoodId(long foodId) {
    Optional<Foods> food = repository.findById(foodId);
    if (!food.isPresent()) {
      return 0.0;
    }

    List<Ulasan> ulasanList = ulasanRepository.findAllByFood(food.get());
    if (ulasanList.isEmpty()) {
      return 0.0;
    }

    double totalRating = 0.0;
    for (Ulasan ulasan : ulasanList) {
      totalRating += ulasan.getRating();
    }
    return totalRating / ulasanList.size();
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<ResponAPI<Foods>> deleteFood(@PathVariable("id") long id) {
    try {
      ResponAPI<Foods> responAPI = new ResponAPI<>();
      repository.deleteById(id);
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully delete foods");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @PostMapping("")
  public ResponseEntity<ResponAPI<Foods>> createMainForum(@ModelAttribute FoodRequest body,
      @RequestParam("image_file") MultipartFile file) {
    try {
      ResponAPI<Foods> responAPI = new ResponAPI<>();
      if (!file.isEmpty()) {
        System.out.println("image ada");
      } else {
        System.out.println("image no present");
      }
      String image = saveImage(file);
      Foods foods = new Foods(body.getTitle(), body.getDescription(), body.getDescription(), body.getPrice(), image);
      repository.save(foods);

      FavoriteRequest favreq = new FavoriteRequest();
      favreq.setFavorite(false);
      favreq.setFoodId(foods.getId());
      favreq.setUserId(body.getUserId());
      favoriteController.createFavorite(favreq);

      responAPI.setData(foods);
      responAPI.setMessage("Successfully create foodds");
      responAPI.setStatus(200);
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @PostMapping("/{id}")
  public ResponseEntity<ResponAPI<Foods>> update(@ModelAttribute FoodRequest body,
      @RequestParam(value = "image_file", required = false) MultipartFile file, @PathVariable("id") long id)
      throws IOException {
    Optional<Foods> foods = repository.findById(id);
    ResponAPI<Foods> responAPI = new ResponAPI<>();
    if (foods.isPresent()) {
      Foods food = foods.get();
      if (file != null) {
        String imageOld = food.getImage();
        String image = saveImage(file);
        food.setImage(image);
        System.out.println("ada gambar");
        deleteImage(imageOld);
      }
      food.setTitle(body.getTitle());
      food.setDescription(body.getDescription());
      food.setPrice(body.getPrice());
      food.setFullDescription(body.getDescription());
      repository.save(food);

      responAPI.setData(food);
      responAPI.setMessage("Successfully update foodds");
      responAPI.setStatus(200);
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } else {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responAPI);
    }
  }

  private String saveImage(MultipartFile image) throws IOException {
    String originalFilename = StringUtils.cleanPath(image.getOriginalFilename());
    String ext = originalFilename.substring(originalFilename.lastIndexOf('.'));
    String uniqueFilename = UUID.randomUUID().toString() + ext;
    Path filePath = this.root.resolve(uniqueFilename);
    Files.copy(image.getInputStream(), filePath);
    String url = ServletUriComponentsBuilder.fromCurrentContextPath().path("/imageFood/").path(uniqueFilename)
        .toUriString();
    return url;
  }

  private void deleteImage(String nameimage) throws IOException {
    String[] separatedUrl = nameimage.split("/");
    String path = separatedUrl[separatedUrl.length - 1];
    String[] separatedPath = path.split("/");
    Path oldFile = root.resolve(separatedPath[separatedPath.length - 1]);
    Files.deleteIfExists(oldFile);
  }

  @GetMapping("")
  public ResponseEntity<ResponAPI<Page<FoodResponse>>> getAllFoods(
      @RequestParam(required = false) Integer minPrice,
      @RequestParam(required = false) Integer maxPrice,
      @RequestParam(required = false) Boolean isFavorite,
      @RequestParam(required = false) Double minRating,
      @RequestParam(required = false) Double maxRating,
      @RequestParam(required = false) String search,
      @RequestParam(required = false) Integer page,
      @RequestParam(required = false) Integer limit) {
    try {
      Pageable pageable = PageRequest.of(page, limit, Sort.Direction.DESC, "id");

      Specification<Foods> spec = FoodSpecification.filterByCriteria(search, minPrice, maxPrice, minRating, maxRating,
          isFavorite);
      Page<Foods> filteredFoods = repository.findAll(spec, pageable);
      List<FoodResponse> responses;
      if (isFavorite != null && isFavorite) {
        responses = filteredFoods.getContent().stream()
            .filter(food -> food.getFavorite() != null && food.getFavorite().getFavorite())
            .map(FoodResponse::getInstance)
            .collect(Collectors.toList());
      } else {
        responses = filteredFoods.getContent().stream().map(FoodResponse::getInstance).collect(Collectors.toList());
      }
      Page<FoodResponse> data = new PageImpl<>(responses, pageable, filteredFoods.getTotalElements());
      ResponAPI<Page<FoodResponse>> responAPI = new ResponAPI<>();
      responAPI.setData(data);
      responAPI.setMessage("Successfully get foods");
      responAPI.setStatus(200);
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      ResponAPI<Page<FoodResponse>> responAPI = new ResponAPI<>();
      responAPI.setData(null);
      responAPI.setMessage(e.getMessage());
      responAPI.setStatus(500);
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(responAPI);
    }
  }
}