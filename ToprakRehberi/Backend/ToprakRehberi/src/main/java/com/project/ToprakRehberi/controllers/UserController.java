package com.project.ToprakRehberi.controllers;

import com.project.ToprakRehberi.business.requests.user.UserChangePasswordRequest;
import com.project.ToprakRehberi.business.requests.user.UserLoginRequest;
import com.project.ToprakRehberi.business.requests.user.UserRegisterRequest;
import com.project.ToprakRehberi.business.requests.user.UserUpdateRequest;
import com.project.ToprakRehberi.business.responses.user.LoginResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetAllResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetByID;
import com.project.ToprakRehberi.business.zservices.UserService;
import com.project.ToprakRehberi.repository.UserRepository;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@RestController
@RequestMapping("/api/user")
@AllArgsConstructor
public class UserController {
    private UserService userService;

    @GetMapping("/{id}")
    public UserGetByID getUserbyID(@PathVariable int id) {
        return userService.getUserById(id);
    }

    @PostMapping("/register")
    @ResponseStatus(code = HttpStatus.CREATED)
    public void registerUser( @RequestBody() UserRegisterRequest registerUserRequest) {
        this.userService.registerUser(registerUserRequest);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse>  loginUser(@RequestBody UserLoginRequest userLoginRequest) {
        return this.userService.loginUser(userLoginRequest);
    }


    @DeleteMapping("/{userId}")
    public void deleteUser(@PathVariable int userId) {
        this.userService.deleteUser(userId);
        System.out.println("Bu kullanıcı : " + userId + " PAsif Duruma Alındı.");
    }

    @PatchMapping("/update")
    public ResponseEntity<String> updateUser(@Valid @RequestBody UserUpdateRequest userUpdateRequest) {
        this.userService.updateUser(userUpdateRequest);
        return ResponseEntity.ok("User is updated");
    }

        @PatchMapping("/changePassword")
    public ResponseEntity<String> changePassword(@Valid @RequestBody UserChangePasswordRequest userChangePasswordRequest) {
            this.userService.changePassword(userChangePasswordRequest, userChangePasswordRequest.getNewPassword());
        return ResponseEntity.ok("User is updated");
    }

    @PostMapping("/{id}/uploadImage")
    public ResponseEntity<String> uploadImage(@PathVariable int id, @RequestParam("image") MultipartFile file) {
        try {
            userService.saveUserProfileImage(id, file);
            return new ResponseEntity<>("Profile image uploaded successfully", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to upload profile image", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{userId}/profileImage")
    public ResponseEntity<byte[]> getProfileImage(@PathVariable int userId) throws IOException {
        // Kullanıcının profil resmi yolunu veritabanından çek
        String imagePath = userService.getUserProfil(userId);

        if (imagePath == null || imagePath.isEmpty()) {
            // Eğer resim yoksa, varsayılan bir resim dönebilirsiniz
            imagePath = "uploads/default_User.png"; // varsayılan resim yolu
        }

        // Resmi dosya sisteminden al
        Path path = Paths.get(imagePath);
        byte[] imageBytes = Files.readAllBytes(path);

        // Resmi HTTP cevabında geri döndür
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG); // Resim tipini buradan belirleyebilirsiniz (JPEG, PNG, vb.)

        return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
    }

}
