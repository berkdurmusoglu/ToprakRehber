package com.project.ToprakRehberi.business.responses.land;

import com.project.ToprakRehberi.business.responses.address.MahalleGetByID;
import com.project.ToprakRehberi.business.responses.farming.EkimGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimWithLand;
import com.project.ToprakRehberi.business.responses.user.UserGetAllResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetByID;
import com.project.ToprakRehberi.entities.enums.LandTypes;
import com.project.ToprakRehberi.entities.farming.Ekim;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class LandGetByID {
    private int id;
    @Enumerated(EnumType.STRING)
    private LandTypes landTip;
    private int m2;
    private int ekimM2;
    private String landDescription;
    private UserGetByID user_Id;
    private MahalleGetByID mahalle;
}
