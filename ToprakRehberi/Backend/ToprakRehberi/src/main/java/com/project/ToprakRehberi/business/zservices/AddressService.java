package com.project.ToprakRehberi.business.zservices;

import com.project.ToprakRehberi.business.responses.address.*;
import com.project.ToprakRehberi.entities.adres.Il;
import com.project.ToprakRehberi.entities.adres.Ilce;
import org.springframework.data.jpa.domain.Specification;

import java.util.List;

public interface AddressService {
    List<MahalleGetAllResponse> GetAllMahalle();

    List<IlGetAllResponse> GetAllIl();

    List<IlceGetAllResponse> GetAllIlce();

    List<IlceGetByiLID> GetAllIlceByiLID(int id);

    List<MahalleGetByIlceId> GetAllMahalleByIlceId(int id);

    MahalleGetByID GetMahalleById(int id);

    List<MahalleGetAllResponse> searchMahalleByName(String searchQuery,int ilceId);

    List<IlGetAllResponse> searchIlByName(String searchQuery);

    List<IlceGetAllResponse> searchIlceByName(String searchQuery,int ilId);

    IlGetAllResponse getIlbyIlceId(int id);

    IlceGetString getIlceByMahalleId(int id);
}
