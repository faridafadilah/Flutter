package com.example.myresto.models;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import com.fasterxml.jackson.annotation.JsonBackReference;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Foods {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  
  @Column(nullable = false)
  private String title;

  @Column(nullable = false)
  private String description;

  @Column(name = "full_description", nullable = false)
  private String fullDescription;

  @Column(nullable = false)
  private int price;

  @Column(nullable = false)
  private String image;

  public Foods(String title, String description, String fullDescription, int price, String image) {
    this.title = title;
    this.description = description;
    this.fullDescription = fullDescription;
    this.price = price;
    this.image = image;
  }

  @JsonBackReference
  @OneToMany(mappedBy = "food")
  private List<Cart> carts;
  
  @JsonBackReference
  @OneToMany(mappedBy = "food")
  private List<Favorite> favorite;

  @JsonBackReference
  @OneToMany(mappedBy = "food")
  private List<Ulasan> ulasan;

  public boolean isFavorite() {
    if (favorite == null || favorite.isEmpty()) {
        return false;
    }
    return true;
  }
}
