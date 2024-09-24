package com.project.ToprakRehberi.business.responses.farming;

import com.project.ToprakRehberi.business.responses.address.MahalleGetByID;
import com.project.ToprakRehberi.business.responses.other.ProductGetAllResponse;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class RehberGetResponse {
    private int id;
    private MahalleGetByID mahalleId;
    private ProductGetAllResponse product;
    private Mevsim mevsim;
    private double sonuc;
}
