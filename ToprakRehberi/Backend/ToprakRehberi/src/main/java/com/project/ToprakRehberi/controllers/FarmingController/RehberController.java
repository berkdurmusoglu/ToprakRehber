package com.project.ToprakRehberi.controllers.FarmingController;

import com.project.ToprakRehberi.business.responses.farming.RehberGetResponse;
import com.project.ToprakRehberi.business.zservices.FarmingService.RehberService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("/farming/rehber")
@AllArgsConstructor
public class RehberController {

    private RehberService rehberService;

    @GetMapping("/mahalle/{mahalleId}")
    public List<RehberGetResponse> RehberGetByMahalle(@PathVariable int mahalleId) {
        return rehberService.getRehberByMahalle(mahalleId);
    }

    @GetMapping("/product/{productId}")
    public List<RehberGetResponse> RehberGetByProduct(@PathVariable int productId) {
        return rehberService.getRehberByProduct(productId);
    }

    @GetMapping("/ilce/{ilceId}")
    public List<RehberGetResponse> RehberGetByIlce(@PathVariable int ilceId) {
        return rehberService.getRehberByIlce(ilceId);
    }

}
