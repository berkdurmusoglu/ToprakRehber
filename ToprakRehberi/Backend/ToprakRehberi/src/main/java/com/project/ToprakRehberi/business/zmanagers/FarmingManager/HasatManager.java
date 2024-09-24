package com.project.ToprakRehberi.business.zmanagers.FarmingManager;


import com.project.ToprakRehberi.business.requests.other.HasatCreateRequest;
import com.project.ToprakRehberi.business.responses.farming.EkimWithLand;
import com.project.ToprakRehberi.business.responses.farming.HasatGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.HasatGetEkimId;
import com.project.ToprakRehberi.business.rules.OtherRules;
import com.project.ToprakRehberi.business.zservices.FarmingService.HasatService;
import com.project.ToprakRehberi.entities.farming.Hasat;
import com.project.ToprakRehberi.repository.farming.HasatRepository;
import com.project.ToprakRehberi.utilities.exceptions.LandException;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class HasatManager implements HasatService {


    private HasatRepository hasatRepository;
    private ModelMapperService modelMapperService;
    private OtherRules otherRules;


    @Override
    public List<HasatGetEkimId> getHasatListByUserID(int userId) {
        List<Hasat> hasatList = hasatRepository.findHasatByUserID(userId);
        List<HasatGetEkimId> hasatListByUser = hasatList.stream().map(hasat -> this.modelMapperService.forResponse().map(hasat, HasatGetEkimId.class)).toList();
        return hasatListByUser;
    }


    @Override
    public void CreateHasat(HasatCreateRequest hasatCreateRequest) {
        otherRules.duplicateHasat(hasatCreateRequest.getEkim_Id());
        otherRules.checkEkimExists(hasatCreateRequest.getEkim_Id());
        otherRules.checkHasatSonuc(hasatCreateRequest);
        otherRules.checkLandSizeForHasat(hasatCreateRequest.getEkim_Id());
        Hasat hasat = modelMapperService.forRequest().map(hasatCreateRequest, Hasat.class);
        hasatRepository.save(hasat);
    }

    @Override
    public List<HasatGetEkimId> getHasatByLandID(int landID) {
        List<Hasat> hasatList = hasatRepository.findHasatByLandID(landID);
        if (hasatList.isEmpty()) {
            throw new LandException("Bu tarlada herhangi bir ekim işlemi bulunmamaktadır.");
        } else {
            List<HasatGetEkimId> hasatGetEkimId = hasatList.stream().map(hasat -> this.modelMapperService.forResponse().map(hasat, HasatGetEkimId.class)).toList();
            return hasatGetEkimId;
        }
    }


    @Override
    public HasatGetEkimId GetHasatByEkimID(int ekimID) {
        Hasat hasat = hasatRepository.findByEkimId(ekimID);
        System.out.println(hasat.getHasatSonuc());
        System.out.println(hasat.getHasatMiktari());
        HasatGetEkimId hasatGetEkimId = this.modelMapperService.forResponse().map(hasat, HasatGetEkimId.class);
        return hasatGetEkimId;

    }

    @Override
    public HasatGetEkimId GetHasatByID(int hasatID) {
        Optional<Hasat> hasat = hasatRepository.findById(hasatID);
        if (hasat.isPresent()) {
            HasatGetEkimId hasatGetEkimId = this.modelMapperService.forResponse().map(hasat.get(), HasatGetEkimId.class);
            return hasatGetEkimId;
        } else {
            return null;
        }
    }
}
