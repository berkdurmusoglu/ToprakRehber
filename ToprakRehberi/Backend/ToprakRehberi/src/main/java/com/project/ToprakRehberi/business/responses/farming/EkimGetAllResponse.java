package com.project.ToprakRehberi.business.responses.farming;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class EkimGetAllResponse {
    private int m2;
    private int land_Id;
    private String product_Id;
    private LocalDate ekimTarihi;
}