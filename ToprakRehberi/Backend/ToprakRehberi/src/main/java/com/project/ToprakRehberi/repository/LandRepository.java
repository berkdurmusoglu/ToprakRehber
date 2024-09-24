package com.project.ToprakRehberi.repository;

import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.User;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface LandRepository extends JpaRepository<Land, Integer> {
    Page<Land> findByUserIdOrderByIdDesc(int userId, Pageable pageable);

    List<Land> findByUserIdOrderByIdDesc(int userId);

    Land findByMahalleId(int mahalleId);

    Land findById(int id);
}
