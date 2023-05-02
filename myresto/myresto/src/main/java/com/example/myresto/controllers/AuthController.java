package com.example.myresto.controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;
import java.util.UUID;

import javax.validation.Valid;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.example.myresto.base.ResponAPI;
import com.example.myresto.dto.request.LoginRequest;
import com.example.myresto.dto.request.RegisterRequest;
import com.example.myresto.dto.response.UserResponse;
import com.example.myresto.models.Users;
import com.example.myresto.repository.UserRepository;
import com.example.myresto.security.jwt.JwtUtils;
import com.example.myresto.security.services.UserDetailslmpl;

@RestController
@RequestMapping("/api")
public class AuthController {
  private final Path root = Paths.get("./imageUser");

  @Autowired
  private UserRepository repository;

  @Autowired
  AuthenticationManager authenticationManager;

  @Autowired
  JwtUtils jwtUtils;

  @Autowired
  PasswordEncoder encoder;

  @PostMapping("/register")
  public ResponseEntity<ResponAPI<Users>> register(@ModelAttribute RegisterRequest req,
      @RequestParam("image") MultipartFile file) {
    try {
      ResponAPI<Users> responAPI = new ResponAPI<>();
      Users users = new Users();
      users.setUsername(req.getUsername());
      users.setAlamat(req.getAlamat());
      users.setEmail(req.getEmail());
      users.setJenisKelamin(req.getJenisKelamin());
      users.setKota(req.getKota());
      users.setNama(req.getNama());
      users.setNik(req.getNik());
      users.setTanggalLahir(req.getTanggalLahir());
      users.setPassword(encoder.encode(req.getPassword()));
      String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
      String ext = originalFilename.substring(originalFilename.lastIndexOf('.'));
      String uniqueFilename = UUID.randomUUID().toString() + ext;
      Path filePath = this.root.resolve(uniqueFilename);
      Files.copy(file.getInputStream(), filePath);
      String url = ServletUriComponentsBuilder.fromCurrentContextPath().path("/imageUser/").path(uniqueFilename)
          .toUriString();
      users.setPathPhoto(url);
      users.setFilePhoto(uniqueFilename);
      repository.save(users);

      responAPI.setData(users);
      responAPI.setStatus(HttpStatus.CREATED.value());
      responAPI.setMessage("Successfully register account");
      return ResponseEntity.status(HttpStatus.CREATED).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @PostMapping("/signin")
  public ResponseEntity<?> authenticateUser(@Valid @ModelAttribute LoginRequest loginRequest) {
    try {
      Authentication authentication = authenticationManager
          .authenticate(
              new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

      SecurityContextHolder.getContext().setAuthentication(authentication);

      UserDetailslmpl userDetails = (UserDetailslmpl) authentication.getPrincipal();

      String jwt = jwtUtils.generateJwtToken(userDetails);
      System.out.println("jwt" + jwt);

      Optional<Users> userOp = repository.findByUsername(loginRequest.getUsername());
      if (!userOp.isPresent()) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Data tidak ditemukan!");
      }
      ResponAPI<Users> responAPI = new ResponAPI<>();
      responAPI.setData(userOp.get());
      responAPI.setStatus(HttpStatus.OK.value());
      responAPI.setMessage("Login Berhasil!");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } catch (BadCredentialsException ex) {
      // handle incorrect username or password here
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect username or password");
    }
  }

  @GetMapping("/profile/{id}")
  public ResponseEntity<ResponAPI<Users>> getById(@PathVariable("id") long id) {
    Optional<Users> users = repository.findById(id);
    ResponAPI<Users> responAPI = new ResponAPI<>();
    if (users.isPresent()) {
      responAPI.setData(users.get());
      responAPI.setStatus(200);
      responAPI.setMessage("Successfully get profile!");
      return ResponseEntity.status(HttpStatus.OK).body(responAPI);
    } else {
      responAPI.setMessage("Failed get profile!");
      return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responAPI);
    }
  }

  @PostMapping("/profile/{id}")
  public ResponseEntity<ResponAPI<Users>> updateProfile(@ModelAttribute RegisterRequest req,
      @RequestParam(required = false, value = "image") MultipartFile file, @PathVariable("id") long id) {
    try {
      ResponAPI<Users> responAPI = new ResponAPI<>();
      Optional<Users> userOp = repository.findById(id);
      if (!userOp.isPresent()) {
        responAPI.setMessage("User Not Found!");
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responAPI);
      }

      Users users = userOp.get();
      String userImage = users.getFilePhoto();
      users.setUsername(req.getUsername());
      users.setAlamat(req.getAlamat());
      users.setEmail(req.getEmail());
      users.setJenisKelamin(req.getJenisKelamin());
      users.setKota(req.getKota());
      users.setNama(req.getNama());
      users.setNik(req.getNik());
      users.setTanggalLahir(req.getTanggalLahir());

      if (file != null && !file.isEmpty()) {
        if (userImage != null) {
          Path oldFile = root.resolve(userImage);
          Files.deleteIfExists(oldFile);
        }
        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        String ext = originalFilename.substring(originalFilename.lastIndexOf('.'));
        String uniqueFilename = UUID.randomUUID().toString() + ext;
        Path filePath = this.root.resolve(uniqueFilename);
        Files.copy(file.getInputStream(), filePath);
        String url = ServletUriComponentsBuilder.fromCurrentContextPath().path("/imageUser/").path(uniqueFilename)
            .toUriString();
        users.setPathPhoto(url);
        users.setFilePhoto(uniqueFilename);
      }

      repository.save(users);
      responAPI.setData(users);
      responAPI.setStatus(HttpStatus.CREATED.value());
      responAPI.setMessage("Successfully register account");
      return ResponseEntity.status(HttpStatus.CREATED).body(responAPI);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
