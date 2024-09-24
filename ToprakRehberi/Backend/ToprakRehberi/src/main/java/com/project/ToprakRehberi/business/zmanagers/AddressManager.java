package com.project.ToprakRehberi.business.zmanagers;

import com.project.ToprakRehberi.business.responses.address.*;
import com.project.ToprakRehberi.business.zservices.AddressService;
import com.project.ToprakRehberi.entities.adres.Il;
import com.project.ToprakRehberi.entities.adres.Ilce;
import com.project.ToprakRehberi.entities.adres.Mahalle;
import com.project.ToprakRehberi.repository.address.IlRepository;
import com.project.ToprakRehberi.repository.address.IlceRepository;
import com.project.ToprakRehberi.repository.address.MahalleRepository;
import com.project.ToprakRehberi.utilities.exceptions.LandException;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import io.micrometer.common.util.StringUtils;
import jakarta.persistence.criteria.Predicate;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class AddressManager implements AddressService {
    private IlceRepository ilceRepository;
    private MahalleRepository mahalleRepository;
    private IlRepository ilRepository;
    private ModelMapperService modelMapperService;

    @Override
    public List<MahalleGetAllResponse> GetAllMahalle() {
        List<Mahalle> mahalleler = mahalleRepository.findAll();
        List<MahalleGetAllResponse> mahalleResponses = mahalleler.stream().map(mahalle -> this.modelMapperService.forResponse().map(mahalle, MahalleGetAllResponse.class)).toList();
        return mahalleResponses;
    }

    @Override
    public List<IlGetAllResponse> GetAllIl() {
        List<Il> iller = ilRepository.findAll();
        List<IlGetAllResponse> ilResponses = iller.stream().map(il -> this.modelMapperService.forResponse().map(il, IlGetAllResponse.class)).toList();
        return ilResponses;
    }

    @Override
    public List<IlceGetAllResponse> GetAllIlce() {
        List<Ilce> ilceler = ilceRepository.findAll();
        List<IlceGetAllResponse> ilceResponses = ilceler.stream().map(ilce -> this.modelMapperService.forResponse().map(ilce, IlceGetAllResponse.class)).toList();
        return ilceResponses;
    }

    @Override
    public List<IlceGetByiLID> GetAllIlceByiLID(int id) {
        List<Ilce> ilceler = ilceRepository.findByIlId(id);
        if (ilceler.isEmpty()) {
            throw new LandException("Bu şehirin ilçesi bulunmamaktadır.");
        } else {
            System.out.println("İl: " + ilceler.size());
            List<IlceGetByiLID> ilcelerByIl = ilceler.stream().map(ilce -> this.modelMapperService.forResponse().map(ilce, IlceGetByiLID.class)).toList();
            return ilcelerByIl;
        }
    }

    @Override
    public List<MahalleGetByIlceId> GetAllMahalleByIlceId(int id) {
        List<Mahalle> mahalleler = mahalleRepository.findByIlceId(id);
        if (mahalleler.isEmpty()) {
            throw new LandException("Bu ilçenin mahallesi bulunmamaktadır.");
        } else {

            List<MahalleGetByIlceId> mahallelerByIlce = mahalleler.stream().map(mahalle -> this.modelMapperService.forResponse().map(mahalle, MahalleGetByIlceId.class)).toList();
            return mahallelerByIlce;
        }
    }

    @Override
    public MahalleGetByID GetMahalleById(int id) {
        Mahalle mahalle = mahalleRepository.getReferenceById(id);
        MahalleGetByID mahalleGetByID = this.modelMapperService.forResponse().map(mahalle, MahalleGetByID.class);
        return mahalleGetByID;
    }

    @Override
    public IlGetAllResponse getIlbyIlceId(int id) {
        Optional<Ilce> ilce = ilceRepository.findById(id);
        Il il = ilce.get().getIl();
        IlGetAllResponse ilGetAllResponse = this.modelMapperService.forResponse().map(il, IlGetAllResponse.class);
        return ilGetAllResponse;
    }

    @Override
    public IlceGetString getIlceByMahalleId(int id) {
        Optional<Mahalle> mahalle = mahalleRepository.findById(id);
        Ilce ilce = mahalle.get().getIlce();
        IlceGetString ilceGetAllResponse = this.modelMapperService.forResponse().map(ilce, IlceGetString.class);
        return ilceGetAllResponse;
    }

    @Override
    public List<IlGetAllResponse> searchIlByName(String query) {
        List<Il> iller = ilRepository.findByIlNameContainingIgnoreCase(query);
        List<IlGetAllResponse> ilResponse = iller.stream()
                .map(il -> this.modelMapperService.forResponse().map(il, IlGetAllResponse.class))
                .toList();
        return ilResponse;
    }

    @Override
    public List<IlceGetAllResponse> searchIlceByName(String searchQuery, int ilId) {
        List<Ilce> ilceler = ilceRepository.findByIlceNameContainingIgnoreCaseAndIlId(searchQuery, ilId);
        List<IlceGetAllResponse> ilceResponse = ilceler.stream()
                .map(ilce -> this.modelMapperService.forResponse().map(ilce, IlceGetAllResponse.class))
                .toList();
        return ilceResponse;
    }

    @Override
    public List<MahalleGetAllResponse> searchMahalleByName(String searchQuery, int ilceId) {
        List<Mahalle> mahalleler = mahalleRepository.findByMahalleNameContainingIgnoreCaseAndIlceId(searchQuery, ilceId);
        List<MahalleGetAllResponse> mahalleResponses = mahalleler.stream()
                .map(mahalle -> this.modelMapperService.forResponse().map(mahalle, MahalleGetAllResponse.class))
                .toList();
        return mahalleResponses;
    }


}
