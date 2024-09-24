package com.project.ToprakRehberi.business.zservices;

import com.project.ToprakRehberi.business.requests.land.LandAddRequest;
import com.project.ToprakRehberi.business.requests.land.LandUpdateRequest;
import com.project.ToprakRehberi.business.responses.land.LandGetAllResponse;
import com.project.ToprakRehberi.business.responses.land.LandGetByID;
import com.project.ToprakRehberi.business.responses.land.LandGetByUserID;
import com.project.ToprakRehberi.entities.Land;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface LandService {
    void addLand(LandAddRequest landAddRequest);
    void deleteLand(int id);

    List<LandGetAllResponse> getAllLands();
    LandGetByID getLandByID(int id);
    List<LandGetByUserID> getLandByUserIDWithPagination(int userId, int page, int size);
    List<LandGetByUserID> getLandByUserID(int user_id);

    Land updateLand(LandUpdateRequest landUpdateRequest);
    void saveLandImage(int landId, MultipartFile file) throws IOException;
    String getLandImage(int userId);
}
