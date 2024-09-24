package com.project.ToprakRehberi.business.zservices.FarmingService;

import com.project.ToprakRehberi.business.requests.other.HasatCreateRequest;
import com.project.ToprakRehberi.business.responses.farming.HasatGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.HasatGetEkimId;

import java.util.List;

public interface HasatService {


    List<HasatGetEkimId> getHasatListByUserID(int userId);

    List<HasatGetEkimId> getHasatByLandID(int landID);

    HasatGetEkimId GetHasatByEkimID(int ekimID);

    HasatGetEkimId GetHasatByID(int hasatID);

    void CreateHasat(HasatCreateRequest hasatCreateRequest);
}
