package com.example.myresto.specification;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;

import org.springframework.data.jpa.domain.Specification;

import com.example.myresto.models.Foods;
import com.example.myresto.models.Ulasan;

public interface FoodSpecification extends Specification<Foods> {
  public static Specification<Foods> filterByCriteria(
      String title,
      Integer minPrice,
      Integer maxPrice,
      Double minRating,
      Double maxRating,
      Boolean isFavorite) {
    return (root, query, builder) -> {
      Join<Foods, Ulasan> ulasanJoin = root.join("ulasan", JoinType.LEFT);
      List<Predicate> predicates = new ArrayList<>();

      if (title != null) {
        predicates.add(builder.like(builder.lower(root.get("title")), "%" + title.toLowerCase() + "%"));
      }

      if (minPrice != null) {
        predicates.add(builder.greaterThanOrEqualTo(root.get("price"), minPrice));
      }

      if (maxPrice != null) {
        predicates.add(builder.lessThanOrEqualTo(root.get("price"), maxPrice));
      }

      if (minRating != null) {
        predicates.add(builder.greaterThanOrEqualTo(ulasanJoin.get("rating"), minRating));
      }

      if (maxRating != null) {
        predicates.add(builder.lessThanOrEqualTo(ulasanJoin.get("rating"), maxRating));
      }

      if (isFavorite != null) {
        if (isFavorite) {
          predicates.add(builder.isNotEmpty(root.get("favorite")));
        } else {
          predicates.add(builder.isEmpty(root.get("favorite")));
        }
      }

      return builder.and(predicates.toArray(new Predicate[0]));
    };
  }
}
