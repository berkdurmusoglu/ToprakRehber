package com.project.ToprakRehberi.business.responses.farming;

import com.project.ToprakRehberi.business.responses.land.LandGetByID;
import com.project.ToprakRehberi.business.responses.other.ProductGetAllResponse;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class EkimWithLand {
    private int id;
    private int m2;
    private LandGetByID land;
    private ProductGetAllResponse product;
    private LocalDate ekimTarihi;
    private Mevsim mevsim;
    private int ekimDay;
}