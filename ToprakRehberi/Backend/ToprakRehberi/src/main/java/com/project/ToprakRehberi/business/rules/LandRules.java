package com.project.ToprakRehberi.business.rules;

import com.project.ToprakRehberi.business.responses.land.LandGetByUserID;
import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.repository.LandRepository;
import com.project.ToprakRehberi.repository.address.MahalleRepository;
import com.project.ToprakRehberi.utilities.exceptions.LandException;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class LandRules {
    private LandRepository landRepository;
    private ModelMapperService modelMapperService;

    public List<LandGetByUserID> checkLand(int id) {
        System.out.println("Checking landsby user with id " + id);
        List<Land> lands = landRepository.findByUserIdOrderByIdDesc(id);
        if (lands.isEmpty()) {
            throw new LandException("Bu kullanıcı için herhangi bir arazi bulunmamaktadır.");
        } else {
            System.out.println("Lands: " + lands.size());
            List<LandGetByUserID> landListByUser = lands.stream().map(land -> this.modelMapperService.forResponse().map(land, LandGetByUserID.class)).toList();
            return landListByUser;
        }
    }

    public List<LandGetByUserID> checkLandsbyUserforGet(int id, int page, int size) {
        System.out.println("Checking lands by user with id " + id);

        // Sayfalama için Pageable nesnesi oluşturuluyor
        Pageable pageable = PageRequest.of(page, size);

        // Page kullanarak sorgu yapılır
        Page<Land> landsPage = landRepository.findByUserIdOrderByIdDesc(id, pageable);

        if (landsPage.isEmpty()) {
            throw new LandException("Bu kullanıcı için herhangi bir arazi bulunmamaktadır.");
        } else {
            System.out.println("Lands: " + landsPage.getTotalElements());

            // Sayfadaki verileri almak için .getContent() kullanılır
            List<LandGetByUserID> landListByUser = landsPage.getContent().stream()
                    .map(land -> this.modelMapperService.forResponse().map(land, LandGetByUserID.class))
                    .toList();

            return landListByUser;
        }
    }

    public boolean checkLandisAvailable(int id) {
        System.out.println("Checking lands available...");
        if (landRepository.getReferenceById(id).getEkimM2() >= 0) {
            return true;
        } else throw new LandException("Arazinizde uygun yer bulunamamıştır. Lütfen kontrol ediniz");
    }

}



