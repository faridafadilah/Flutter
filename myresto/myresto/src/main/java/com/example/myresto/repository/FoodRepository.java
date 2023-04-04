package com.example.myresto.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.myresto.models.Foods;

@Repository
public interface FoodRepository extends JpaRepository<Foods, Long> {
  
}
