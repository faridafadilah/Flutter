package com.example.myresto.controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.example.myresto.dto.FoodRequest;
import com.example.myresto.models.Foods;
import com.example.myresto.repository.FoodRepository;

@RestController
@RequestMapping("/api/foods")
public class FoodController {
  @Autowired
  private FoodRepository repository;

  private final Path root = Paths.get("./imageFood");

  @GetMapping("")
  public ResponseEntity<ResponAPI<List<Foods>>> getAll() {
    // List<Foods> foods = repository.findAll();
    // ResponAPI<List<Foods>> responAPI = new ResponAPI<>();
    // if(foods != null) {
    //   responAPI.setData(foods);
    //   responAPI.setStatus(200);
    //   responAPI.setMessage("Successfully get foods");
    //   return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    // } else {
    //   return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responAPI);
    // }
    try{
      List<Foods> foods = new ArrayList<>();
      repository.findAll().forEach(foods::add);
      ResponAPI<List<Foods>> responAPI = new ResponAPI<>();
      responAPI.setData(foods);
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get foods");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @GetMapping("/{id}")
  public ResponseEntity<ResponAPI<Foods>> getById(@PathVariable("id") long id) {
    Optional<Foods> foods = repository.findById(id);
    ResponAPI<Foods> responAPI = new ResponAPI<>();
    if(foods.isPresent()) {
      responAPI.setData(foods.get());
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get foods");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } else {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responAPI);
    }
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
      if(!file.isEmpty()){
        System.out.println("image ada");
      } else {
        System.out.println("image no present");
      }
      String image = saveImage(file);
      Foods foods = new Foods(body.getTitle(), body.getDescription(), body.getDescription(), body.getPrice(), image);
      repository.save(foods);
      responAPI.setData(foods);
      responAPI.setMessage("Successfully create foodds");
      responAPI.setStatus(200);
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @PostMapping("/{id}")
  public ResponseEntity<ResponAPI<Foods>> update(@ModelAttribute FoodRequest body, @RequestParam(value = "image_file", required = false) MultipartFile file, @PathVariable("id") long id) throws IOException {
    Optional<Foods> foods = repository.findById(id);
    ResponAPI<Foods> responAPI = new ResponAPI<>();
    if(foods.isPresent()) {
      Foods food = foods.get();
      if(file != null) {
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
    String url = ServletUriComponentsBuilder.fromCurrentContextPath().path("/imageFood/").path(uniqueFilename).toUriString();
    return url;
  }

  private void deleteImage(String nameimage) throws IOException {
    String[] separatedUrl = nameimage.split("/");
    String path = separatedUrl[separatedUrl.length - 1];
    String[] separatedPath = path.split("/");
    Path oldFile = root.resolve(separatedPath[separatedPath.length - 1]);
    Files.deleteIfExists(oldFile);
  }
}