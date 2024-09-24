package com.project.ToprakRehberi.business.rules;

import com.project.ToprakRehberi.business.requests.other.EkimCreateRequest;
import com.project.ToprakRehberi.business.requests.other.HasatCreateRequest;
import com.project.ToprakRehberi.business.requests.other.RehberCreateRequest;
import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.enums.HasatSonuc;
import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.entities.farming.Rehber;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.repository.LandRepository;
import com.project.ToprakRehberi.repository.farming.EkimRepository;
import com.project.ToprakRehberi.repository.farming.HasatRepository;
import com.project.ToprakRehberi.repository.farming.RehberRepository;
import com.project.ToprakRehberi.utilities.exceptions.DuplicateException;
import com.project.ToprakRehberi.utilities.exceptions.JpaObjectException;
import com.project.ToprakRehberi.utilities.exceptions.LandException;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Month;
import java.util.HashMap;
import java.util.Map;

@Service
@AllArgsConstructor
public class OtherRules {
    private final LandRepository landRepository;
    private final LandRules landRules;
    private EkimRepository ekimRepository;
    private HasatRepository hasatRepository;
    private RehberRepository rehberRepository;
    private ModelMapperService modelMapperService;



    public void checkEkimExists(int id) {
        System.out.println("Checking ekim with id " + id);
        if (ekimRepository.existsById(id)) {
            System.out.println("Hasat ediliyor.");
            Ekim ekim = ekimRepository.getReferenceById(id);
            ekim.setStatus(EkimStatus.TAMAMLANDI);
            ekimRepository.save(ekim);
        } else {
            System.out.println("Böyle bir ekim bulunmamaktadır : " + id);
            throw new JpaObjectException("Bu id ye sahip bir ekim bulunamadı.");
        }
    }

    public void duplicateHasat(int ekimId) {
        System.out.println("Hasat kontrol ediliyor.");
        if (hasatRepository.existsByEkimId(ekimId)) {
            System.out.println("Daha önce hasat edildi.");
            throw new DuplicateException("Daha önce hasat edildi.");
        } else {
            System.out.println("Hasat edildi.");
        }
    }

    public void checkLandSizeforEkim(int landId, int ekimRequestM2, int landEkimM2) {

        System.out.println("Checking land size  ");
        if (landEkimM2 >= ekimRequestM2) {
            Land land = landRepository.getReferenceById(landId);
            System.out.println(land.getEkimM2());
            land.setEkimM2(landRepository.getReferenceById(landId).getEkimM2() - ekimRequestM2);
            landRepository.save(land);
            if (landRules.checkLandisAvailable(landId)) {
                System.out.println("Arazinizde kalan m2 : " + land.getEkimM2());
            }
        } else throw new LandException("Arazinizde uygun yer bulunamamaktadır.");
    }

    public void checkLandSizeForHasat(int ekimId) {

        System.out.println("Checking land size  ");
        Ekim ekim = ekimRepository.getReferenceById(ekimId);
        Land land = landRepository.getReferenceById(ekim.getLand().getId());
        System.out.println(land.getEkimM2());
        land.setEkimM2(land.getEkimM2()+ekim.getM2());
        landRepository.save(land);

    }

    public Boolean checkProductisExist(EkimCreateRequest ekimCreateRequest) {
        boolean isExist;
        System.out.println("Checking product ");
        Ekim ekim = ekimRepository.findByLandIdAndProductIdAndEkimTarihiAndStatus(ekimCreateRequest.getLand_Id(), ekimCreateRequest.getProduct_Id(), ekimCreateRequest.getEkimTarihi(), EkimStatus.AKTIF);
        if (ekim != null) {
            ekim.setM2(ekim.getM2() + ekimCreateRequest.getM2());
            ekimRepository.save(ekim);
            isExist = true;
        } else {
            System.out.println("Yeni ekim oluşturuldu.");
            isExist = false;
        }
        return isExist;
    }

    public void checkHasatSonuc(HasatCreateRequest hasatCreateRequest) {
        Ekim ekim = ekimRepository.getReferenceById(hasatCreateRequest.getEkim_Id());
        int productId = ekim.getProduct().getId();
        Land land = ekim.getLand();
        int mahalleId = land.getMahalle().getId();
        Rehber rehber = rehberRepository.findByMahalleIdAndProductIdAndMevsim(mahalleId, productId, mevsimiHesapla(ekim.getEkimTarihi()));
        if (rehber != null) {
            System.out.println("Bu mahalle ve üürn için rehber bulunuyo");
            double newSonucValue = calculateNewSonuc(rehber.getSonuc(),hasatCreateRequest);
            rehber.setSonuc(newSonucValue);
            System.out.println(newSonucValue);
            rehberRepository.save(rehber);
        } else {
            System.out.println("Yeni REhber oluturuluyo");
            newRehber(productId, mahalleId, hasatCreateRequest.getHasatSonuc(),ekim.getEkimTarihi());
        }

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

    private Rehber newRehber(int productId, int mahalleId, HasatSonuc sonuc, LocalDate hasatTarihi) {
        Map<HasatSonuc, Double> initialSonucValues = new HashMap<>();

        initialSonucValues.put(HasatSonuc.IYI, 65.0);
        initialSonucValues.put(HasatSonuc.ORTA, 50.0);
        initialSonucValues.put(HasatSonuc.KOTU, 35.0);
        System.out.println(initialSonucValues);
        Rehber rehber = new Rehber();
        RehberCreateRequest rehberCreateRequest = new RehberCreateRequest();
        rehberCreateRequest.setMahalleId(mahalleId);
        rehberCreateRequest.setProductId(productId);
        rehberCreateRequest.setSonuc(initialSonucValues.getOrDefault(sonuc, 0.0));
        Rehber r1 = this.modelMapperService.forRequest().map(rehberCreateRequest, Rehber.class);
        r1.setMevsim(mevsimiHesapla(hasatTarihi));
        rehberRepository.save(r1);
        return rehber;
    }

    private double calculateNewSonuc(double currentSonuc,  HasatCreateRequest hasatCreateRequest) {
        int ekimId = hasatCreateRequest.getEkim_Id();
        Ekim ekim = ekimRepository.getReferenceById(ekimId);
        switch (hasatCreateRequest.getHasatSonuc()) {
            case HasatSonuc.IYI:
                currentSonuc += 0.2 * (1+((double) ekim.getM2() /5000)) * (1+((double) hasatCreateRequest.getHasatMiktari() /ekim.getM2()));
                currentSonuc =checkNewSonuc(currentSonuc);
                break;
            case HasatSonuc.ORTA:
                currentSonuc =((50-currentSonuc)/100) * (0.01+((double) ekim.getM2() /10000)) * (0.01+((double) hasatCreateRequest.getHasatMiktari() /ekim.getM2()));
                currentSonuc =checkNewSonuc(currentSonuc);
                break;
            case HasatSonuc.KOTU:
                currentSonuc += -0.2 * (1+((double) ekim.getM2() /5000)) * (1+((double) hasatCreateRequest.getHasatMiktari() /ekim.getM2()));
                currentSonuc =checkNewSonuc(currentSonuc);
                break;
        }
        System.out.println(hasatCreateRequest.getHasatSonuc());
        return currentSonuc;
    }

    private double checkNewSonuc(double newSonuc) {
        if (newSonuc < 5.0) {
            return 5.0;
        } else if (newSonuc > 95.0) {
            return 95.0;
        } else return newSonuc;
    }
}





