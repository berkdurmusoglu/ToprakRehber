package com.project.ToprakRehberi.business.zservices;

import com.project.ToprakRehberi.business.requests.user.UserChangePasswordRequest;
import com.project.ToprakRehberi.business.requests.user.UserLoginRequest;
import com.project.ToprakRehberi.business.requests.user.UserRegisterRequest;
import com.project.ToprakRehberi.business.requests.user.UserUpdateRequest;
import com.project.ToprakRehberi.business.responses.user.LoginResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetAllResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetByID;
import com.project.ToprakRehberi.entities.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface UserService {

    void registerUser(UserRegisterRequest userRegisterRequest);

    ResponseEntity<LoginResponse> loginUser(UserLoginRequest userLoginRequest);

    void deleteUser(int id);

    List<UserGetAllResponse> getAllUser();

    UserGetByID getUserById(int id);

    User updateUser(UserUpdateRequest userUpdateRequest);
    User changePassword(UserChangePasswordRequest userChangePasswordRequest,String newPassword);

    void saveUserProfileImage(int userId, MultipartFile file) throws IOException;

    String getUserProfil(int userId);
}