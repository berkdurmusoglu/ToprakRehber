package com.project.ToprakRehberi.business.zmanagers;

import com.project.ToprakRehberi.business.requests.other.CommentCreateRequest;
import com.project.ToprakRehberi.business.responses.other.CommentGetResponse;
import com.project.ToprakRehberi.business.responses.other.ProductGetAllResponse;
import com.project.ToprakRehberi.business.zservices.OtherService;
import com.project.ToprakRehberi.entities.User;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.entities.farming.Hasat;
import com.project.ToprakRehberi.entities.farming.Rehber;
import com.project.ToprakRehberi.entities.other.*;
import com.project.ToprakRehberi.repository.UserRepository;
import com.project.ToprakRehberi.repository.farming.EkimRepository;
import com.project.ToprakRehberi.repository.farming.HasatRepository;
import com.project.ToprakRehberi.repository.farming.RehberRepository;
import com.project.ToprakRehberi.repository.others.CommentRepository;
import com.project.ToprakRehberi.repository.others.ProductRepository;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
@AllArgsConstructor
public class OtherManager implements OtherService {

private CommentRepository commentRepository;
    private final RehberRepository rehberRepository;
    private final UserRepository userRepository;
    private final HasatRepository hasatRepository;
    private ProductRepository productRepository;
    private ModelMapperService modelMapperService;



    @Override
    public List<ProductGetAllResponse> GetAllProduct() {
        List<Product> products = productRepository.findAll();
        List<ProductGetAllResponse> productResponses = products.stream().map(product -> this.modelMapperService.forResponse().map(product, ProductGetAllResponse.class)).toList();
        return productResponses;
    }

    @Override
    public List<ProductGetAllResponse> searchByProductName(String searchQuery) {
        List<Product> products = productRepository.findByProductNameContainingIgnoreCase(searchQuery);
        List<ProductGetAllResponse> productResponse = products.stream()
                .map(product -> this.modelMapperService.forResponse().map(product, ProductGetAllResponse.class))
                .toList();
        return productResponse;
    }

    @Override
    public List<ProductGetAllResponse> searchByProductIlkbahar(String searchQuery) {
        List<Product> products = productRepository.findByEkimMevsimiAndProductNameContainingIgnoreCase("İlkbahar", searchQuery);
        List<ProductGetAllResponse> productResponse = products.stream()
                .map(product -> this.modelMapperService.forResponse().map(product, ProductGetAllResponse.class))
                .toList();
        return productResponse;
    }

    @Override
    public List<ProductGetAllResponse> searchByProductSonbahar(String searchQuery) {
        List<Product> products = productRepository.findByEkimMevsimiAndProductNameContainingIgnoreCase("Sonbahar", searchQuery);
        List<ProductGetAllResponse> productResponse = products.stream()
                .map(product -> this.modelMapperService.forResponse().map(product, ProductGetAllResponse.class))
                .toList();
        return productResponse;
    }

    @Override
    public List<ProductGetAllResponse> GetAllProductIlkbahar() {
        List<Product> products = productRepository.findByEkimMevsimi("İlkbahar");
        List<ProductGetAllResponse> productIlkbaharList = products.stream().map(product -> this.modelMapperService.forResponse().map(product, ProductGetAllResponse.class)).toList();
        return productIlkbaharList;
    }

    @Override
    public List<ProductGetAllResponse> GetAllProductSonbahar() {
        List<Product> products = productRepository.findByEkimMevsimi("Sonbahar");
        List<ProductGetAllResponse> productSonbaharList = products.stream().map(product -> this.modelMapperService.forResponse().map(product, ProductGetAllResponse.class)).toList();
        return productSonbaharList;
    }

    @Override
    public List<Mevsim> getMevsimList() {
        return Arrays.asList(Mevsim.values());
    }

    @Override
    public List<Comment> getAllComments() {
        return commentRepository.findAll();
    }

    @Override
    public void createComment(CommentCreateRequest commentCreateRequest) {
        User user = userRepository.getReferenceById(commentCreateRequest.getUser_ID());
        Hasat hasat = hasatRepository.getReferenceById(commentCreateRequest.getHasat_ID());
        Rehber rehber = rehberRepository.findByMahalleIdAndProductIdAndMevsim(commentCreateRequest.getMahalle_ID(), commentCreateRequest.getProduct_ID(),hasat.getEkim().getMevsim());
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setRehber(rehber);
        comment.setBody(commentCreateRequest.getBody());
        comment.setHasat(hasat);
        comment.setCreatedDate(LocalDateTime.now());
        commentRepository.save(comment);
    }



    @Override
    public List<CommentGetResponse> getAllCommentsByUserID(int userID) {
        List<Comment> comments = commentRepository.getAllCommentsByUserID(userID);
        List<CommentGetResponse> userComments = comments.stream().map(comment -> this.modelMapperService.forResponse().map(comment, CommentGetResponse.class)).toList();
        return userComments;
    }

    @Override
    public List<CommentGetResponse> getAllCommentsByRehberID(int rehberID) {
        List<Comment> comments = commentRepository.getAllCommentsByRehberID(rehberID);
        List<CommentGetResponse> rehberComments = comments.stream().map(comment -> this.modelMapperService.forResponse().map(comment, CommentGetResponse.class)).toList();
        return rehberComments;
    }

    @Override
    public List<CommentGetResponse> getAllCommentsByHasatID(int hasatID) {
        List<Comment> comments = commentRepository.getAllCommentsByHasatID(hasatID);
        List<CommentGetResponse> rehberComments = comments.stream().map(comment -> this.modelMapperService.forResponse().map(comment, CommentGetResponse.class)).toList();
        return rehberComments;
    }

    @Override
    public List<CommentGetResponse> getAllComment(int userID) {
        List<Comment> comments = commentRepository.getAllComment(userID);
        List<CommentGetResponse> allComments = comments.stream().map(comment -> this.modelMapperService.forResponse().map(comment, CommentGetResponse.class)).toList();
        return allComments;
    }

    @Override
    public List<EkimStatus> getEkimStatus() {
        return Arrays.asList(EkimStatus.values());
    }


}
