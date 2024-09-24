package com.project.ToprakRehberi.business.rules;

import com.project.ToprakRehberi.business.responses.user.LoginResponse;
import com.project.ToprakRehberi.entities.User;
import com.project.ToprakRehberi.repository.UserRepository;
import com.project.ToprakRehberi.utilities.exceptions.AuthException;
import com.project.ToprakRehberi.utilities.mappers.ModelMapperService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class AuthRules {
        private UserRepository userRepository;

    public ResponseEntity<LoginResponse> checkIfUserExists(String mail, String password) {

        if (this.userRepository.existsByMailAndPassword(mail, password)) {
            ResponseEntity.ok("Giriş Başarılı");
            User user = this.userRepository.findByMailAndPassword(mail, password);
            user.setState("Active");
            userRepository.save(user);
            System.out.println(+user.getId());
            LoginResponse loginResponse = new LoginResponse(user.getId());
            return new ResponseEntity<>(loginResponse, HttpStatus.OK);
        } else throw new AuthException("Hatalı mail veya şifre ");
    }

    public void checkIfUserMailAndTelNoExists(String mail,String telNo) {
        if (this.userRepository.existsByMail(mail)) {
            throw new AuthException("Mail already exist ");
        }

        if (this.userRepository.existsByTelNo(telNo)) {
            throw new AuthException("Telefon no already exist ");
        }
        ResponseEntity.ok("User is valid for Register");
    }

    public void checkIsCorrect(String name,String telNo,String password){
        if(name.length()<3 || name.length()>15){
            throw new AuthException("İsminizi Kontrol Ediniz.");
        }else if(telNo.length()!=11){
            throw new AuthException("Telefon Numaranızı Kontrol Ediniz.");
        }else if(password.length()<6){
            throw new AuthException("Min 6 uzunlukta şifre oluşturunuz.");
        }else System.out.println("KAyıta Uygun");
    }

}
