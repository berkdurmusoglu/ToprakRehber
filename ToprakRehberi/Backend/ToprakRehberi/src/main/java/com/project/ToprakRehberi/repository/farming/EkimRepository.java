package com.project.ToprakRehberi.repository.farming;

import com.project.ToprakRehberi.business.responses.farming.HasatGetEkimId;
import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface EkimRepository extends JpaRepository<Ekim, Integer> {
    List<Ekim> findByLandId(int landId);
    Ekim findByLandIdAndProductIdAndEkimTarihiAndStatus(int landId,int ProductId, LocalDate ekimTarihi,EkimStatus status);

    List<Ekim> findByLandIdAndStatusOrderByIdDesc(int landId,EkimStatus status);

    @Query("SELECT e FROM Ekim e WHERE e.land.id IN (SELECT l.id FROM Land l WHERE l.user.id = :userId)")
    List<Ekim> findAllByUserId(int userId);

    @Query("SELECT e FROM Ekim e WHERE e.land.id IN (SELECT l.id FROM Land l WHERE l.user.id = :userId) AND e.status = :status")
    Page<Ekim> findAllByUserId(int userId,EkimStatus status, Pageable pageable);

    @Query("select e from Ekim e where LOWER(e.land.landDescription) like LOWER(CONCAT('%', :name, '%')) and e.land.user.id = :userId order by e.ekimTarihi asc")
    List<Ekim> filterLand(String name, int userId);

    @Query("select e from Ekim e where LOWER(e.product.productName) like LOWER(CONCAT('%', :name, '%')) and e.land.user.id = :userId order by e.ekimTarihi asc")
    List<Ekim> filterProductName(String name, int userId);

    @Query("select  e from Ekim e where e.land.user.id = :userId order by e.m2 desc")
    List<Ekim> sortM2Desc(int userId);

    @Query("select  e from Ekim e where e.land.user.id = :userId order by e.m2 asc ")
    List<Ekim> sortM2Asc(int userId);

    @Query("select  e from Ekim e where e.land.user.id = :userId order by e.ekimTarihi asc ")
    List<Ekim> sortDateAsc(int userId);

    @Query("select  e from Ekim e where e.land.user.id = :userId order by e.ekimTarihi desc")
    List<Ekim> sortDateDesc(int userId);

    @Query("select e from Ekim e where LOWER(e.product.productName) like LOWER(CONCAT('%', :name, '%')) and e.land.user.id = :userId order by e.m2 asc")
    List<Ekim> filterProductSortAsc(String name, int userId);

    @Query("select e from Ekim e where LOWER(e.product.productName) like LOWER(CONCAT('%', :name, '%')) and e.land.user.id = :userId order by e.m2 desc ")
    List<Ekim> filterProductSortDesc(String name, int userId);

    @Query("select e from Ekim e where LOWER(e.land.landDescription) like LOWER(CONCAT('%', :name, '%')) and e.land.user.id = :userId order by e.m2 asc")
    List<Ekim> filterLandAsc(String name, int userId);

    @Query("select e from Ekim e where LOWER(e.land.landDescription) like LOWER(CONCAT('%', :name, '%')) and e.land.user.id = :userId order by e.m2 desc")
    List<Ekim> filterLandDesc(String name, int userId);

}


//SELECT e FROM Ekim e WHERE e.status = :status AND e.land.id IN (SELECT l.id FROM Land l WHERE l.user.id = :userId)"