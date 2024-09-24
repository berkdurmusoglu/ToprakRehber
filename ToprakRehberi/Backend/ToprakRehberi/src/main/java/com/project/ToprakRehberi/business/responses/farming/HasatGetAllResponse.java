package com.project.ToprakRehberi.business.responses.farming;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class HasatGetAllResponse {
    private int id;
    private int ekim_Id;
    private int hasatMiktari;
    private String hasat_Sonuc;
    private LocalDate hasatTarihi;
}
