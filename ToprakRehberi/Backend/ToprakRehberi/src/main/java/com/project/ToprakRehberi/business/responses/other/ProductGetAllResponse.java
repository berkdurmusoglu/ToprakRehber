package com.project.ToprakRehberi.business.responses.other;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ProductGetAllResponse {
    private int id;
    private String productName;
    private String image;
    private String hasatMevsimi;
    private String ekimMevsimi;
}