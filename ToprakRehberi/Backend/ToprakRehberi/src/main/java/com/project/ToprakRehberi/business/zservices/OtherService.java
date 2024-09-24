package com.project.ToprakRehberi.business.zservices;

import com.project.ToprakRehberi.business.requests.other.CommentCreateRequest;
import com.project.ToprakRehberi.business.responses.other.*;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.other.Comment;

import java.util.List;

public interface OtherService {
    List<ProductGetAllResponse> GetAllProduct();

    List<ProductGetAllResponse> searchByProductName(String searchQuery);

    List<ProductGetAllResponse> searchByProductIlkbahar(String searchQuery);

    List<ProductGetAllResponse> searchByProductSonbahar(String searchQuery);

    List<ProductGetAllResponse> GetAllProductIlkbahar();

    List<ProductGetAllResponse> GetAllProductSonbahar();

    List<EkimStatus> getEkimStatus();

    List<Mevsim> getMevsimList();

    List<Comment> getAllComments();

    void createComment(CommentCreateRequest commentCreateRequest);
    List<CommentGetResponse> getAllCommentsByUserID(int userID);

    List<CommentGetResponse> getAllCommentsByRehberID(int rehberID);

    List<CommentGetResponse> getAllCommentsByHasatID(int hasatID);

    List<CommentGetResponse> getAllComment(int userID);
}
