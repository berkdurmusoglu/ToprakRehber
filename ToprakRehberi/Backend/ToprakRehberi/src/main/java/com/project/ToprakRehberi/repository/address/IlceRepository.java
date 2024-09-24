package com.project.ToprakRehberi.repository.address;

import com.project.ToprakRehberi.entities.adres.Il;
import com.project.ToprakRehberi.entities.adres.Ilce;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IlceRepository extends JpaRepository<Ilce, Integer> {
    List<Ilce> findByIlId(int ilId);
    List<Ilce> findByIlceNameContainingIgnoreCaseAndIlId(String ilName, int ilId);
}
