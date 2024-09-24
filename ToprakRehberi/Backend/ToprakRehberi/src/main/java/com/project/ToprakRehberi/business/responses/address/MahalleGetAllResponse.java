package com.project.ToprakRehberi.business.responses.address;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class MahalleGetAllResponse {
    private int id;
    private String mahalleName;
    private int ilce_Id;
}