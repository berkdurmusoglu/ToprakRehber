package com.project.ToprakRehberi.business.requests.land;

import com.project.ToprakRehberi.entities.enums.LandTypes;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LandAddRequest {
    @Enumerated(EnumType.STRING)
    private LandTypes landTip;
    @NotNull
    private int m2;
    @NotNull
    private String landDescription;
    @NotNull
    private int user_Id;
    @NotNull
    private int mahalle_Id;
}