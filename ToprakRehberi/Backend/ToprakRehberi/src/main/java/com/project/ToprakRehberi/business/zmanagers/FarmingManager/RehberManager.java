package com.project.ToprakRehberi.business.zmanagers.FarmingManager;


import com.project.ToprakRehberi.business.responses.farming.RehberGetResponse;
import com.project.ToprakRehberi.business.zservices.FarmingService.RehberService;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.farming.Rehber;
import com.project.ToprakRehberi.entities.other.Product;
import com.project.ToprakRehberi.repository.farming.RehberRepository;
import com.project.ToprakRehberi.repository.others.ProductRepository;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class RehberManager implements RehberService {

    private RehberRepository rehberRepository;
    private ModelMapperService modelMapperService;
    private ProductRepository productRepository;
    @Override
    public List<RehberGetResponse> getRehberByMahalle(int mahalleId) {
        List<Rehber> rehberler = rehberRepository.findByMahalleIdOrderBySonucDesc(mahalleId);
        List<RehberGetResponse> rehberByMahalle = rehberler.stream().map(rehber -> this.modelMapperService.forResponse().map(rehber, RehberGetResponse.class)).toList();
        return rehberByMahalle;
    }

    @Override
    public List<RehberGetResponse> getRehberByMahalleWithMevsim(int mahalleId, Mevsim mevsim) {
        List<Rehber> rehberler = rehberRepository.findByMahalleIdOrderBySonucDesc(mahalleId);
        List<RehberGetResponse> rehberByMahalle = rehberler.stream().map(rehber -> this.modelMapperService.forResponse().map(rehber, RehberGetResponse.class)).toList();
        return rehberByMahalle;
    }

    @Override
    public List<RehberGetResponse> getRehberByProduct(int productId) {
        Product product = productRepository.getReferenceById(productId);
        List<Rehber> rehberler = rehberRepository.findByProductOrderBySonucDesc(product);
        List<RehberGetResponse> rehberByMahalle = rehberler.stream().map(rehber -> this.modelMapperService.forResponse().map(rehber, RehberGetResponse.class)).toList();
        return rehberByMahalle;
    }
}
