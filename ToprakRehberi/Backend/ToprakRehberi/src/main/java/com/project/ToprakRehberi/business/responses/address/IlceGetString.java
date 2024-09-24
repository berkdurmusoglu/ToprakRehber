package com.project.ToprakRehberi.business.responses.address;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class IlceGetString {
    private int id;
    private String ilceName;
    private String il_Id;
}
