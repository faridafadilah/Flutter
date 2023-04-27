package com.example.myresto.specification;

import javax.persistence.criteria.Join;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Component;

import com.example.myresto.models.History;
import com.example.myresto.models.Users;

@Component
public class HistorySpecification {
  public Specification<History> userEqual(long id) {
    return (Specification<History>) (root, cq, cb) -> {
      if(id == 0) {
        return null;
      } else {
        Join<History, Users> userJoin = root.join("users");
        return cb.equal(userJoin.get("id"), id);
      }
    };
  }
}
