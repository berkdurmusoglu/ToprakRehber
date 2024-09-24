package com.project.ToprakRehberi.business.responses.farming;

import com.project.ToprakRehberi.entities.enums.HasatSonuc;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class HasatGetEkimId {
    private int id;
    private EkimWithLand ekim_Id;
    @Enumerated(EnumType.STRING)
    private HasatSonuc hasat_sonuc;
    private int hasatMiktari;
    private LocalDate hasatTarihi;
}
