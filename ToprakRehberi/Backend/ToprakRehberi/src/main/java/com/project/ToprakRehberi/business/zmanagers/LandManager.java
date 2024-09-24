package com.project.ToprakRehberi.business.zmanagers;

import com.project.ToprakRehberi.business.requests.land.LandAddRequest;
import com.project.ToprakRehberi.business.requests.land.LandUpdateRequest;
import com.project.ToprakRehberi.business.responses.land.LandGetAllResponse;
import com.project.ToprakRehberi.business.responses.land.LandGetByID;
import com.project.ToprakRehberi.business.responses.land.LandGetByUserID;
import com.project.ToprakRehberi.business.rules.LandRules;
import com.project.ToprakRehberi.business.zservices.LandService;
import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.User;
import com.project.ToprakRehberi.repository.LandRepository;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class LandManager implements LandService {
    private LandRepository landRepository;
    private ModelMapperService modelMapperService;
    private LandRules landRules;

    @Override
    public void addLand(LandAddRequest landAddRequest) {

        Land land = this.modelMapperService.forRequest().map(landAddRequest, Land.class);
        land.setEkimM2(land.getM2());
        this.landRepository.save(land);
    }

    @Override
    public List<LandGetAllResponse> getAllLands() {
        List<Land> lands = this.landRepository.findAll();
        List<LandGetAllResponse> allLandList = lands.stream().map(land -> this.modelMapperService.forResponse().map(land, LandGetAllResponse.class)).toList();
        return allLandList;
    }

    @Override
    public LandGetByID getLandByID(int id) {

        Land land = this.landRepository.findById(id);
        return this.modelMapperService.forResponse().map(land, LandGetByID.class);
    }

    @Override
    public List<LandGetByUserID> getLandByUserID(int user_id) {
        return landRules.checkLand(user_id);
    }

    @Override
    public List<LandGetByUserID> getLandByUserIDWithPagination(int userId, int page, int size) {
        return landRules.checkLandsbyUserforGet(userId, page, size);
    }

    @Override
    public Land updateLand(LandUpdateRequest landUpdateRequest) {
        Land land = this.modelMapperService.forRequest().map(landUpdateRequest, Land.class);
        this.landRepository.save(land);
        return land;
    }

    @Override
    public void saveLandImage(int landId, MultipartFile file) throws IOException {
        Land opLand = landRepository.findById(landId);
        if (opLand!=null) {
            String imagePath = "uploads/lands" + file.getOriginalFilename();
            Path path = Paths.get(imagePath);
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
            opLand.setLandImage(imagePath);  // If storing the image path
            landRepository.save(opLand);
        } else {
            throw new RuntimeException("User not found with ID: " + landId);
        }
    }

    @Override
    public String getLandImage(int userId) {
        Land land = landRepository.findById(userId);
        if (land != null) {
            return land.getLandImage(); // Resim yolu (uploads/image.jpg gibi)
        }
        return null;
    }


    @Override
    public void deleteLand(int id) {
        Land land = landRepository.findById(id);
        landRepository.delete(land);
    }

}
