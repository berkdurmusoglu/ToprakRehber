package com.project.ToprakRehberi.business.zmanagers.FarmingManager;

import com.project.ToprakRehberi.business.requests.other.EkimCreateRequest;
import com.project.ToprakRehberi.business.responses.address.IlGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimWithLand;
import com.project.ToprakRehberi.business.rules.OtherRules;
import com.project.ToprakRehberi.business.zservices.FarmingService.EkimService;
import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.adres.Il;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.repository.LandRepository;
import com.project.ToprakRehberi.repository.farming.EkimRepository;
import com.project.ToprakRehberi.utilities.exceptions.JpaObjectException;
import com.project.ToprakRehberi.utilities.exceptions.LandException;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Month;
import java.util.List;

@Service
@AllArgsConstructor
public class EkimManager implements EkimService {

    private EkimRepository ekimRepository;
    private ModelMapperService modelMapperService;
    private LandRepository landRepository;
    private OtherRules otherRules;


    @Override
    public List<EkimWithLand> GetEkimByLand(int landId) {
        List<Ekim> ekimler = ekimRepository.findByLandIdAndStatusOrderByIdDesc(landId, EkimStatus.AKTIF);
        if (ekimler.isEmpty()) {
            throw new LandException("Bu tarlada herhangi bir ekim işlemi bulunmamaktadır.");
        } else {
            List<EkimWithLand> ekimWithLands = ekimler.stream().map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class)).toList();
            return ekimWithLands;
        }
    }

    @Override
    public EkimWithLand GetEkimWithID(int id) {
        Ekim ekim = ekimRepository.getReferenceById(id);
        EkimWithLand ekimWithLand = this.modelMapperService.forResponse().map(ekim, EkimWithLand.class);
        return ekimWithLand;
    }

    @Override
    public void CreateEkim(EkimCreateRequest ekimCreateRequest) {
        Land land = landRepository.getReferenceById(ekimCreateRequest.getLand_Id());
        otherRules.checkLandSizeforEkim(ekimCreateRequest.getLand_Id(), ekimCreateRequest.getM2(), land.getEkimM2());
        boolean productisExist = otherRules.checkProductisExist(ekimCreateRequest);
        Mevsim mevsim = mevsimiHesapla(ekimCreateRequest.getEkimTarihi());
        System.out.println(ekimCreateRequest.getEkimTarihi() + " - " + mevsim);
        if (productisExist) {
            System.out.println("Ekim işlemi daha önce oluşturduğunuz ekimin üzerine eklendi.");
            System.out.println(ekimCreateRequest.getEkimTarihi());
        } else {
            Ekim ekim = modelMapperService.forRequest().map(ekimCreateRequest, Ekim.class);
            ekim.setMevsim(mevsim);
            ekimRepository.save(ekim);
        }

    }

    @Override
    public List<EkimWithLand> filterByLandDescription(String filter,int userID) {
            List<Ekim> ekimler = ekimRepository.filterLand(filter,userID);
            List<EkimWithLand> ekimRes = ekimler.stream()
                    .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                    .toList();
            return ekimRes;
    }

    @Override
    public List<EkimWithLand> filterByPName(String filter,int userID) {
        List<Ekim> ekimler = ekimRepository.filterProductName(filter,userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;

    }

    @Override
    public List<EkimWithLand> sortByM2Desc(int userID) {
        List<Ekim> ekimler = ekimRepository.sortM2Desc(userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> sortByM2Asc(int userID) {
        List<Ekim> ekimler = ekimRepository.sortM2Asc(userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> sortByDateDesc(int userID) {
        List<Ekim> ekimler = ekimRepository.sortDateDesc(userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> sortByDateAsc(int userID) {
        List<Ekim> ekimler = ekimRepository.sortDateAsc(userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> filterLandSortDesc(int userID, String filter) {
        List<Ekim> ekimler = ekimRepository.filterLandDesc(filter,userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> filterLandSortAsc(int userID, String filter) {
        List<Ekim> ekimler = ekimRepository.filterLandAsc(filter,userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> filterProductSortDesc(int userID, String filter) {
        List<Ekim> ekimler = ekimRepository.filterProductSortDesc(filter,userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    @Override
    public List<EkimWithLand> filterProductSortAsc(int userID, String filter) {
        List<Ekim> ekimler = ekimRepository.filterProductSortAsc(filter,userID);
        List<EkimWithLand> ekimRes = ekimler.stream()
                .map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class))
                .toList();
        return ekimRes;
    }

    public List<EkimWithLand> getEkimlerByUserId(int userId) {
        List<Ekim> ekimler = ekimRepository.findAllByUserId(userId);
        List<EkimWithLand> ekimWithUser = ekimler.stream().map(ekim -> this.modelMapperService.forResponse().map(ekim, EkimWithLand.class)).toList();
        return ekimWithUser;
    }

    @Override
    public List<EkimWithLand> getEkimlerByUser(int userId, int page, int size) {
        System.out.println("Checking ekimler by user with id: " + userId);

        Pageable pageable = PageRequest.of(page, size);

        Page<Ekim> ekimPage = ekimRepository.findAllByUserId(userId, EkimStatus.AKTIF, pageable);
        System.out.println("Ekimler: " + ekimPage.getTotalElements());
        List<EkimWithLand> ekimListByUser = ekimPage.getContent().stream().map(ekim -> this.modelMapperService.forResponse()
                .map(ekim, EkimWithLand.class)).toList();
        return ekimListByUser;

    }






    public Mevsim mevsimiHesapla(LocalDate ekimTarihi) {
        Month ay = ekimTarihi.getMonth();

        return switch (ay) {
            case MARCH, APRIL, MAY -> Mevsim.İLKBAHAR;
            case JUNE, JULY, AUGUST -> Mevsim.YAZ;
            case SEPTEMBER, OCTOBER, NOVEMBER -> Mevsim.SONBAHAR;
            case DECEMBER, JANUARY, FEBRUARY -> Mevsim.KIŞ;
        };
    }

}
