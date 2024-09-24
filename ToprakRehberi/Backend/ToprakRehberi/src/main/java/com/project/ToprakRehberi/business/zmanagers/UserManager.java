package com.project.ToprakRehberi.business.zmanagers;


import com.project.ToprakRehberi.business.requests.user.UserChangePasswordRequest;
import com.project.ToprakRehberi.business.requests.user.UserLoginRequest;
import com.project.ToprakRehberi.business.requests.user.UserRegisterRequest;
import com.project.ToprakRehberi.business.requests.user.UserUpdateRequest;
import com.project.ToprakRehberi.business.responses.user.LoginResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetAllResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetByID;
import com.project.ToprakRehberi.business.rules.AuthRules;
import com.project.ToprakRehberi.business.zservices.UserService;
import com.project.ToprakRehberi.entities.User;
import com.project.ToprakRehberi.repository.UserRepository;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@Service
@AllArgsConstructor
public class UserManager implements UserService {
    private ModelMapperService modelMapperService;
    private UserRepository userRepository;
    private AuthRules authRules;



    @Override
    public void registerUser(@RequestBody UserRegisterRequest userRegisterRequest) {
        this.authRules.checkIsCorrect(userRegisterRequest.getName(), userRegisterRequest.getTelNo(), userRegisterRequest.getPassword());
        this.authRules.checkIfUserMailAndTelNoExists(userRegisterRequest.getMail(), userRegisterRequest.getTelNo());
        User user = this.modelMapperService.forRequest().map(userRegisterRequest, User.class);
        this.userRepository.save(user);
    }

    @Override
    public ResponseEntity<LoginResponse> loginUser(UserLoginRequest userLoginRequest) {
        return this.authRules.checkIfUserExists(userLoginRequest.getMail(), userLoginRequest.getPassword());
    }

    @Override
    public void deleteUser(int id) {
        User user = userRepository.findById(id);
        user.setState("Passive");
        this.userRepository.save(user);
    }

    @Override
    public List<UserGetAllResponse> getAllUser() {
        List<User> users = userRepository.findByState("active");
        List<UserGetAllResponse> allUserList = users.stream().map(user -> this.modelMapperService.forResponse().map(user, UserGetAllResponse.class)).toList();
        return allUserList;
    }

    @Override
    public UserGetByID getUserById(int id) {
        //List<User> activeUsers = userRepository.findByState("active");
        User user = userRepository.findById(id);
        return this.modelMapperService.forResponse().map(user, UserGetByID.class);
    }

    @Override
    public User updateUser(UserUpdateRequest userUpdateRequest) {
        User user = this.modelMapperService.forRequest().map(userUpdateRequest, User.class);
        this.userRepository.save(user);
        return user;
    }

    @Override
    public User changePassword(UserChangePasswordRequest userChangePasswordRequest,String newPassword) {
        User user = userRepository.findByMailAndTelNoAndPassword(
                userChangePasswordRequest.getMail(),
                userChangePasswordRequest.getTelNo(),
                userChangePasswordRequest.getPassword()
        );

        if (user != null) {
            user.setPassword(newPassword);
            userRepository.save(user);
        } else {
            // Kullanıcı bulunamadıysa uygun bir işlem yapın
            throw new RuntimeException("Kullanıcı bulunamadı veya mevcut şifre yanlış");
        }

        return user;
    }

    public void saveUserProfileImage(int userId, MultipartFile file) throws IOException {
        User optionalUser = userRepository.findById(userId);
        if (optionalUser!=null) {
            String imagePath = "uploads/" + file.getOriginalFilename();
            Path path = Paths.get(imagePath);
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
            optionalUser.setProfileImage(imagePath);  // If storing the image path
            userRepository.save(optionalUser);
        } else {
            throw new RuntimeException("User not found with ID: " + userId);
        }
    }

    public String getUserProfil(int userId) {
        User user = userRepository.findById(userId);
        if (user != null) {
            return user.getProfileImage();
        }
        return null;
    }
}
