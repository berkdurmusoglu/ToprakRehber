package com.project.ToprakRehberi.business.requests.other;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class RehberCreateRequest {
    private int mahalleId;
    private int productId;
    private double sonuc;
}
