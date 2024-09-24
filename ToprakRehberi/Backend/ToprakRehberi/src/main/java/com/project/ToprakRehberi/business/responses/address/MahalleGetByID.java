package com.project.ToprakRehberi.business.responses.address;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class MahalleGetByID {
    private int id;
    private String mahalleName;
    private IlceGetString ilce_Id;
}
