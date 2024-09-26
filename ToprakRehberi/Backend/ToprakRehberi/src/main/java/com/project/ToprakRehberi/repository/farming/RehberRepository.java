package com.project.ToprakRehberi.repository.farming;

import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.entities.farming.Rehber;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.other.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface RehberRepository extends JpaRepository<Rehber, Integer> {
    Rehber findByMahalleIdAndProductIdAndMevsim(Integer mahalleId, Integer productId, Mevsim mevsim);
    List<Rehber> findByMahalleIdOrderBySonucDesc(int mahalleId);
    List<Rehber> findByProductOrderBySonucDesc(Product product);

    @Query("SELECT r FROM Rehber r WHERE r.mahalle.id IN (SELECT m.id FROM Mahalle m WHERE m.ilce.id = :ilceID) order by r.sonuc desc")
    List<Rehber> filterIlce(int ilceID);

}
