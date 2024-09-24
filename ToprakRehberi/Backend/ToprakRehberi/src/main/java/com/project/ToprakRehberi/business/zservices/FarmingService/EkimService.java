package com.project.ToprakRehberi.business.zservices.FarmingService;

import com.project.ToprakRehberi.business.requests.other.EkimCreateRequest;
import com.project.ToprakRehberi.business.responses.address.IlGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimWithLand;

import java.util.List;

public interface EkimService {

    List<EkimWithLand> getEkimlerByUserId(int userId);

    List<EkimWithLand> getEkimlerByUser(int userId, int page, int size);

    List<EkimWithLand> GetEkimByLand(int landId);


    EkimWithLand GetEkimWithID(int id);

    void CreateEkim(EkimCreateRequest ekimCreateRequest);

    List<EkimWithLand> filterByLandDescription(String filter,int userID);

    List<EkimWithLand> filterByPName(String filter,int userID);

    List<EkimWithLand> sortByM2Desc(int userID);

    List<EkimWithLand> sortByM2Asc(int userID);

    List<EkimWithLand> sortByDateDesc(int userID);

    List<EkimWithLand> sortByDateAsc(int userID);

    List<EkimWithLand> filterLandSortDesc(int userID,String filter);

    List<EkimWithLand> filterLandSortAsc(int userID,String filter);

    List<EkimWithLand> filterProductSortDesc(int userID,String filter);

    List<EkimWithLand> filterProductSortAsc(int userID,String filter);
}
