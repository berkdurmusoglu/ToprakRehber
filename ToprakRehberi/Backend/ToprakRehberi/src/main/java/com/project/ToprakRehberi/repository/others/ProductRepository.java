package com.project.ToprakRehberi.repository.others;

import com.project.ToprakRehberi.entities.adres.Il;
import com.project.ToprakRehberi.entities.other.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Integer> {
    List<Product> findByEkimMevsimi(String ekimMevsimi);

    List<Product> findByProductNameContainingIgnoreCase(String productName);

    List<Product> findByEkimMevsimiAndProductNameContainingIgnoreCase(String ekimMevsimi, String productName);
}
