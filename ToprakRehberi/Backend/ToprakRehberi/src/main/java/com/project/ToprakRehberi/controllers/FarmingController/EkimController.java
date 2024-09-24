package com.project.ToprakRehberi.controllers.FarmingController;

import com.project.ToprakRehberi.business.requests.other.EkimCreateRequest;
import com.project.ToprakRehberi.business.responses.address.IlGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.EkimWithLand;
import com.project.ToprakRehberi.business.zservices.FarmingService.EkimService;
import lombok.AllArgsConstructor;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/farming/ekim")
@AllArgsConstructor
public class EkimController {

    private EkimService ekimService;


    @PostMapping("/create")
    public HttpStatus createEkim(@RequestBody EkimCreateRequest ekimCreateRequest) {
        ekimService.CreateEkim(ekimCreateRequest);
        return HttpStatus.CREATED;
    }

    @GetMapping("/{id}")
    public EkimWithLand GetEkimWithID(@PathVariable int id) {
        return ekimService.GetEkimWithID(id);
    }

    @GetMapping("/lands/{landID}")
    public List<EkimWithLand> GetEkimLands(@PathVariable int landID) {
        return ekimService.GetEkimByLand(landID);
    }

    @GetMapping("/users/{userid}")
    public List<EkimWithLand> getEkimlerByUserId(@PathVariable int userid) {
        return ekimService.getEkimlerByUserId(userid);
    }

    @GetMapping("/page/{userId}")
    public List<EkimWithLand> getEkimlerByUser(
            @PathVariable int userId,
            @RequestParam(defaultValue = "0") int page,  // Varsayılan olarak ilk sayfa
            @RequestParam(defaultValue = "10") int size   // Varsayılan olarak 6 kayıt
    ) {
        return ekimService.getEkimlerByUser(userId, page, size);
    }

    @GetMapping("/filter/land")
    public ResponseEntity<List<EkimWithLand>> filterLand(@RequestParam("filter") String filter,@RequestParam("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.filterByLandDescription(filter,userID);
        return ResponseEntity.ok(ekimler);
    }

    @GetMapping("/filter/product")
    public ResponseEntity<List<EkimWithLand>> filterProduct(@RequestParam("filter") String filter,@RequestParam("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.filterByPName(filter,userID);
        return ResponseEntity.ok(ekimler);
    }

    @GetMapping("/{userID}/sort/m2/desc")
    public ResponseEntity<List<EkimWithLand>> sortM2Desc(@PathVariable("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.sortByM2Desc(userID);
        return ResponseEntity.ok(ekimler);
    }

    @GetMapping("/{userID}/sort/m2/asc")
    public ResponseEntity<List<EkimWithLand>> sortM2Asc(@PathVariable("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.sortByM2Asc(userID);
        return ResponseEntity.ok(ekimler);
    }

    @GetMapping("/{userID}/sort/date/desc")
    public ResponseEntity<List<EkimWithLand>> sortDateDesc(@PathVariable("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.sortByDateDesc(userID);
        return ResponseEntity.ok(ekimler);
    }

    @GetMapping("/{userID}/sort/date/asc")
    public ResponseEntity<List<EkimWithLand>> sortDateAsc(@PathVariable("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.sortByDateAsc(userID);
        return ResponseEntity.ok(ekimler);
    }

    @GetMapping("/filter/product/sort/asc")
    public ResponseEntity<List<EkimWithLand>> filterProductSortAsc(@RequestParam("filter") String filter,@RequestParam("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.filterProductSortAsc(userID,filter);
        return ResponseEntity.ok(ekimler);
    }
    @GetMapping("/filter/product/sort/desc")
    public ResponseEntity<List<EkimWithLand>> filterProductSortDesc(@RequestParam("filter") String filter,@RequestParam("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.filterProductSortDesc(userID,filter);
        return ResponseEntity.ok(ekimler);
    }
    @GetMapping("/filter/land/sort/asc")
    public ResponseEntity<List<EkimWithLand>> filterLandSortAsc(@RequestParam("filter") String filter,@RequestParam("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.filterLandSortAsc(userID,filter);
        return ResponseEntity.ok(ekimler);
    }
    @GetMapping("/filter/land/sort/desc")
    public ResponseEntity<List<EkimWithLand>> filterLandSortDesc(@RequestParam("filter") String filter,@RequestParam("userID") int userID) {
        List<EkimWithLand> ekimler = ekimService.filterLandSortDesc(userID,filter);
        return ResponseEntity.ok(ekimler);
    }



}
