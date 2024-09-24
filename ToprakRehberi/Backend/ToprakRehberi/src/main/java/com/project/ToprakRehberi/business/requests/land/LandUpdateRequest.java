package com.project.ToprakRehberi.business.requests.land;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class LandUpdateRequest {
    private int id;
    private String landTip;
    private String m2;
}
