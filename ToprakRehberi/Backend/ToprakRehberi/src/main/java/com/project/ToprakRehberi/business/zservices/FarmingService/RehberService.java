package com.project.ToprakRehberi.business.zservices.FarmingService;

import com.project.ToprakRehberi.business.responses.farming.RehberGetResponse;
import com.project.ToprakRehberi.entities.enums.Mevsim;

import java.util.List;

public interface RehberService {




    List<RehberGetResponse> getRehberByMahalle(int mahalleId);

    List<RehberGetResponse> getRehberByMahalleWithMevsim(int mahalleId, Mevsim mevsim);

    List<RehberGetResponse> getRehberByProduct(int productId);
}
