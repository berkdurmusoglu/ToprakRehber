package com.project.ToprakRehberi.business.responses.address;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class IlceGetByiLID {
    private int id;
    private String ilceName;
    private int il_Id;
}
