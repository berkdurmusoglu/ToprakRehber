package com.project.ToprakRehberi.repository.farming;

import com.project.ToprakRehberi.entities.farming.Hasat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface HasatRepository extends JpaRepository<Hasat, Integer> {
    boolean existsByEkimId(int ekimId);
    Hasat findByEkimId(int ekimId);

    @Query("SELECT h from Hasat h WHERE h.ekim.id IN (SELECT e.id FROM Ekim e WHERE e.land.id IN (SELECT l.id FROM Land l WHERE l.user.id = :userId))")
    List<Hasat> findHasatByUserID(@Param("userId") int userId);

    @Query("SELECT h from Hasat h WHERE h.ekim.id IN (SELECT e.id FROM Ekim e WHERE e.land.id  = :landID)")
    List<Hasat> findHasatByLandID(@Param("landID") int landID);
}
