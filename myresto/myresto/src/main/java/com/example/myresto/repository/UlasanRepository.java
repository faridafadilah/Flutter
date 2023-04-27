package com.example.myresto.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.myresto.models.Foods;
import com.example.myresto.models.History;
import com.example.myresto.models.Ulasan;
import com.example.myresto.models.Users;

@Repository
public interface UlasanRepository extends JpaRepository<Ulasan, Long> {
  List<Ulasan> findAllByUsers(Users users);
  Optional<Ulasan> findByHistory(History history);
  Optional<Ulasan> findByFoodAndUsers(Foods food, Users users);
  List<Ulasan> findAllByFood(Foods food);
}
