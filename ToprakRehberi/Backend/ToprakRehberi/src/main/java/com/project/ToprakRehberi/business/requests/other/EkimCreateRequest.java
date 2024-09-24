package com.project.ToprakRehberi.business.requests.other;

import com.project.ToprakRehberi.entities.enums.EkimStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EkimCreateRequest {
    private int m2;
    private int land_Id;
    private int product_Id;
    private EkimStatus status = EkimStatus.AKTIF;
    private LocalDate ekimTarihi;
}
