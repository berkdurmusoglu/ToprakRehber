package com.project.ToprakRehberi.repository.address;

import com.project.ToprakRehberi.entities.adres.Ilce;
import com.project.ToprakRehberi.entities.adres.Mahalle;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MahalleRepository extends JpaRepository<Mahalle, Integer> {
    List<Mahalle> findByIlceId(int ilceId);
    List<Mahalle> findByMahalleNameContainingIgnoreCaseAndIlceId(String mahalleName,int ilceId);

}
