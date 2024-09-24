package com.project.ToprakRehberi.controllers.FarmingController;

import com.project.ToprakRehberi.business.requests.other.HasatCreateRequest;
import com.project.ToprakRehberi.business.responses.farming.HasatGetAllResponse;
import com.project.ToprakRehberi.business.responses.farming.HasatGetEkimId;
import com.project.ToprakRehberi.business.zservices.FarmingService.HasatService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/farming/hasat")
@AllArgsConstructor
public class HasatController {

    private HasatService hasatService;

    @PostMapping("/create")
    public HttpStatus createHasat(@RequestBody HasatCreateRequest hasatCreateRequest) {
        hasatService.CreateHasat(hasatCreateRequest);
        return HttpStatus.CREATED;
    }

    @GetMapping("/users/{userid}")
    public List<HasatGetEkimId> getHasatListByUserID(@PathVariable int userid) {
        return hasatService.getHasatListByUserID(userid);
    }

    @GetMapping("/lands/{landID}")
    public List<HasatGetEkimId> getHasatBylandID(@PathVariable int landID) {
        return hasatService.getHasatByLandID(landID);
    }

    @GetMapping("/ekim/{ekimID}")
    public HasatGetEkimId GetHasatByEkimID(@PathVariable int ekimID) {
        return hasatService.GetHasatByEkimID(ekimID);
    }

    @GetMapping("/details/{hasatID}")
    public HasatGetEkimId getHasatByID(@PathVariable int hasatID) {
        return hasatService.GetHasatByID(hasatID);
    }

}
