package com.project.ToprakRehberi.controllers;

import com.project.ToprakRehberi.business.requests.other.CommentCreateRequest;
import com.project.ToprakRehberi.business.responses.other.*;
import com.project.ToprakRehberi.business.zservices.OtherService;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import com.project.ToprakRehberi.entities.enums.HasatSonuc;
import com.project.ToprakRehberi.entities.enums.LandTypes;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.other.Comment;
import com.project.ToprakRehberi.repository.farming.EkimRepository;
import com.project.ToprakRehberi.repository.others.ProductRepository;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/other")
@AllArgsConstructor
public class OtherController {

    private final ProductRepository productRepository;
    private OtherService otherService;
    public EkimRepository ekimRepository;


    @GetMapping("/products")
    public List<ProductGetAllResponse> getProducts() {
        return otherService.GetAllProduct();
    }

    @GetMapping("/products/search")
    public ResponseEntity<List<ProductGetAllResponse>> searchProduct(@RequestParam String query) {
        List<ProductGetAllResponse> products = otherService.searchByProductName(query);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/products/ilkbahar/search")
    public ResponseEntity<List<ProductGetAllResponse>> searchProductIlkbahar(@RequestParam String query) {
        List<ProductGetAllResponse> products = otherService.searchByProductIlkbahar(query);
        return ResponseEntity.ok(products);
    }
    @GetMapping("/products/sonbahar/search")
    public ResponseEntity<List<ProductGetAllResponse>> searchProductSonbahar(@RequestParam String query) {
        List<ProductGetAllResponse> products = otherService.searchByProductSonbahar(query);
        return ResponseEntity.ok(products);
    }


    @GetMapping("/products/ilkbahar")
    public List<ProductGetAllResponse> getProductsIlkbahar() {
        return otherService.GetAllProductIlkbahar();
    }

    @GetMapping("/products/sonbahar")
    public List<ProductGetAllResponse> getProductsSonbahar() {
        return otherService.GetAllProductSonbahar();
    }

    @GetMapping("/comments")
    public List<Comment> getAllComments() {
        return otherService.getAllComments();
    }

    @PostMapping("/comments")
    public void createComment(@RequestBody CommentCreateRequest commentCreateRequest) {
        otherService.createComment(commentCreateRequest);
    }

    @GetMapping("/comments/users/{userID}")
    public List<CommentGetResponse> getAllCommentsByUser(@PathVariable int userID) {
        return otherService.getAllCommentsByUserID(userID);
    }

    @GetMapping("/comments/rehber/{rehberID}")
    public List<CommentGetResponse> getAllCommentsByRehber(@PathVariable int rehberID) {
        return otherService.getAllCommentsByRehberID(rehberID);
    }

    @GetMapping("/comments/hasat/{hasatID}")
    public List<CommentGetResponse> getAllCommentsByHasat(@PathVariable int hasatID) {
        return otherService.getAllCommentsByHasatID(hasatID);
    }

    @GetMapping("/comments/all/{userID}")
    public List<CommentGetResponse> getAllComment(@PathVariable int userID) {
        return otherService.getAllComment(userID);
    }

    @GetMapping("/mevsim")
    public List<Mevsim> MevsimGetAll() {
        return otherService.getMevsimList();
    }

    @GetMapping("/ekimstatus")
    public List<EkimStatus> EkimStatusGetAll() {
        return otherService.getEkimStatus();
    }

    @GetMapping("/hasat-sonuc")
    public List<String> getAllHasatSonuc() {
        return Arrays.stream(HasatSonuc.values()).map(Enum::name).collect(Collectors.toList());
    }

    @GetMapping("/land-types")
    public List<String> getgetAllLandTypes() {
        return Arrays.stream(LandTypes.values()).map(Enum::name).collect(Collectors.toList());
    }
}
