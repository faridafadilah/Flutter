package com.example.myresto.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.example.myresto.models.Foods;
import com.example.myresto.models.History;
import com.example.myresto.models.Users;

@Repository
public interface HistoryRepository extends JpaRepository<History, Long>, JpaSpecificationExecutor<History> {  
  List<History> findAllByUsers(Users users);

  Optional<History> findByFoodAndUsers(Foods food, Users users);
}
