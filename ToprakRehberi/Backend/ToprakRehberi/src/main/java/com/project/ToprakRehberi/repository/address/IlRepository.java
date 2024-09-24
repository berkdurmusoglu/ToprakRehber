package com.project.ToprakRehberi.repository.address;

import com.project.ToprakRehberi.business.responses.address.IlGetAllResponse;
import com.project.ToprakRehberi.entities.adres.Il;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IlRepository extends JpaRepository<Il, Integer> {
    List<Il> findByIlNameContainingIgnoreCase(String ilName);

}
