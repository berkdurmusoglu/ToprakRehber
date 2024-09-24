package com.project.ToprakRehberi.repository.farming;

import com.project.ToprakRehberi.entities.farming.Rehber;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.other.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RehberRepository extends JpaRepository<Rehber, Integer> {
    Rehber findByMahalleIdAndProductIdAndMevsim(Integer mahalleId, Integer productId, Mevsim mevsim);
    List<Rehber> findByMahalleIdOrderBySonucDesc(int mahalleId);
    List<Rehber> findByProductOrderBySonucDesc(Product product);
}
