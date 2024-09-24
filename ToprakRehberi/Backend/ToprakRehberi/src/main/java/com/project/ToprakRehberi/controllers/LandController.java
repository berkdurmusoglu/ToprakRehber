package com.project.ToprakRehberi.controllers;

import com.project.ToprakRehberi.business.requests.land.LandAddRequest;
import com.project.ToprakRehberi.business.requests.land.LandUpdateRequest;
import com.project.ToprakRehberi.business.responses.land.LandGetAllResponse;
import com.project.ToprakRehberi.business.responses.land.LandGetByID;
import com.project.ToprakRehberi.business.responses.land.LandGetByUserID;
import com.project.ToprakRehberi.business.zservices.LandService;
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
@RequestMapping("/api/land")
@AllArgsConstructor
public class LandController {
    private LandService landService;


    @GetMapping("/usersP/{userId}")
    public List<LandGetByUserID> getLandsByUser(
            @PathVariable int userId,
            @RequestParam(defaultValue = "0") int page,  // Varsayılan olarak ilk sayfa
            @RequestParam(defaultValue = "6") int size   // Varsayılan olarak 6 kayıt
    ) {
        return landService.getLandByUserIDWithPagination(userId, page, size);
    }
    @GetMapping("/users/{id}")
    public List<LandGetByUserID> getUserLands(@PathVariable int id) {
        return landService.getLandByUserID(id);
    }
    @GetMapping("/{id}")
    public LandGetByID getLandbyID(@PathVariable int id) {
        return landService.getLandByID(id);
    }

    @PostMapping
    public HttpStatus addLand(@RequestBody  LandAddRequest landAddRequest) {
        landService.addLand(landAddRequest);
        return HttpStatus.CREATED;
    }

    @DeleteMapping("/{landId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUser(@PathVariable int landId) {
        this.landService.deleteLand(landId);
    }


    @PatchMapping()
    public ResponseEntity<String> updateLand(@Valid @RequestBody LandUpdateRequest landUpdateRequest) {
        this.landService.updateLand(landUpdateRequest);
        return ResponseEntity.ok("Land is updated");
    }


    @PostMapping("/{id}/uploadImage")
    public ResponseEntity<String> uploadImage(@PathVariable int id, @RequestParam("image") MultipartFile file) {
        try {
            landService.saveLandImage(id, file);
            return new ResponseEntity<>("Land image uploaded successfully", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to upload land image", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{landId}/landImage")
    public ResponseEntity<byte[]> getLandImage(@PathVariable int landId) throws IOException {
        // Kullanıcının profil resmi yolunu veritabanından çek
        String imagePath = landService.getLandImage(landId);

        if (imagePath == null || imagePath.isEmpty()) {
            // Eğer resim yoksa, varsayılan bir resim dönebilirsiniz
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
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
