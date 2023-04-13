package com.example.myresto.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.myresto.models.Favorite;
import com.example.myresto.models.Foods;
import com.example.myresto.models.Users;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
  Optional<Favorite> findByFoodAndUsers(Foods food, Users users);

  List<Favorite> findAllByUsersAndFavorite(Users users, boolean favorite);

  List<Favorite> findAllByUsers(Users users);
}