package com.project.ToprakRehberi.business.requests.other;

import com.project.ToprakRehberi.business.responses.farming.RehberGetResponse;
import com.project.ToprakRehberi.entities.enums.HasatSonuc;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class HasatCreateRequest {
    @NotNull
    private int ekim_Id;
    @NotNull
    private int hasatMiktari;
    @Enumerated(EnumType.STRING)
    private HasatSonuc hasatSonuc;
    private LocalDate hasatTarihi;
}
