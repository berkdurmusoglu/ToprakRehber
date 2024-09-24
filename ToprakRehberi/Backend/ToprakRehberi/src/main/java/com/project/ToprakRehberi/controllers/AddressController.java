package com.project.ToprakRehberi.controllers;

import com.project.ToprakRehberi.business.responses.address.*;
import com.project.ToprakRehberi.business.zmanagers.AddressManager;
import com.project.ToprakRehberi.business.zservices.AddressService;
import com.project.ToprakRehberi.entities.adres.Il;
import com.project.ToprakRehberi.entities.adres.Ilce;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/adres")
@AllArgsConstructor
public class AddressController {
    private AddressService addressService;

    @GetMapping("/mahalleler")
    public List<MahalleGetAllResponse> getMahalleler() {
        return addressService.GetAllMahalle();
    }

    @GetMapping("/il")
    public List<IlGetAllResponse> getIller() {
        return addressService.GetAllIl();
    }

    @GetMapping("/ilceler")
    public List<IlceGetAllResponse> getIlceler() {
        return addressService.GetAllIlce();
    }

    @GetMapping("/ilce")
    public List<IlceGetByiLID> getIlceByID(@RequestParam(value = "il_id", required = false) int id) {
        return addressService.GetAllIlceByiLID(id);
    }

    @GetMapping("/mahalle")
    public List<MahalleGetByIlceId> getMahalleByID(@RequestParam(value = "ilce_id", required = false) int id) {
        return addressService.GetAllMahalleByIlceId(id);
    }

    @GetMapping("/mahalle/")
    public MahalleGetByID getMahalleName(@RequestParam(value = "id") int id) {
        return addressService.GetMahalleById(id);
    }

    @GetMapping("/il/search")
    public ResponseEntity<List<IlGetAllResponse>> searchIl(@RequestParam String query) {
        List<IlGetAllResponse> iller = addressService.searchIlByName(query);
        return ResponseEntity.ok(iller);
    }

    @GetMapping("/ilce/search")
    public ResponseEntity<List<IlceGetAllResponse>> searchIlce(@RequestParam String query,int ilId) {
        List<IlceGetAllResponse> ilceler = addressService.searchIlceByName(query,ilId);
        return ResponseEntity.ok(ilceler);

    }

    @GetMapping("/mahalle/search")
    public ResponseEntity<List<MahalleGetAllResponse>> searchMahalle(@RequestParam String query,int ilceId) {
        List<MahalleGetAllResponse> mahalleler = addressService.searchMahalleByName(query,ilceId);
        return ResponseEntity.ok(mahalleler);
    }

    @GetMapping("/il/ilce")
    public IlceGetString getIlceMahalleID(@RequestParam(value = "id") int id) {
        return addressService.getIlceByMahalleId(id);
    }
}
