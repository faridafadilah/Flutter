package com.example.myresto.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.myresto.models.Cart;
import com.example.myresto.models.Foods;
import com.example.myresto.models.Users;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
  List<Cart> findAllByUsers(Users users);

  Optional<Cart> findByFoodAndUsers(Foods food, Users users);

}
