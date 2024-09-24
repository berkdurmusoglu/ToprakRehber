package com.project.ToprakRehberi.business.responses.address;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class IlceGetAllResponse {
    private int id;
    private String ilceName;
    private int il_Id;
}
