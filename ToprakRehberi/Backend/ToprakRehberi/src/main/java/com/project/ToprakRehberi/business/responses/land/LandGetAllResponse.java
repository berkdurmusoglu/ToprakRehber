package com.project.ToprakRehberi.business.responses.land;

import com.project.ToprakRehberi.business.responses.user.UserGetByID;
import com.project.ToprakRehberi.entities.enums.LandTypes;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LandGetAllResponse {
    private int id;
    @Enumerated(EnumType.STRING)
    private LandTypes landTip;
    private int m2;
    private int ekimM2;
    private String landDescription;
    private UserGetByID user_Id;
    private String mahalle_Id;

}