package com.example.myresto.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.myresto.models.Foods;

@Repository
public interface FoodRepository extends JpaRepository<Foods, Long>, JpaSpecificationExecutor<Foods> {
  List<Foods> findByTitleContaining(String title);

  @Query("SELECT MAX(u.rating) FROM Ulasan u WHERE u.food.id = :foodId")
  Double findMaxRating(@Param("foodId") Long foodId);

  @Query("SELECT MIN(u.rating) FROM Ulasan u WHERE u.food.id = :foodId")
  Double findMinRating(@Param("foodId") Long foodId);
}
