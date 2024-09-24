package com.project.ToprakRehberi.business.requests.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserRegisterRequest {
    @NotNull
    @NotBlank
    @Size(min = 3, max = 50)
    private String name;
    @NotNull
    @NotBlank
    @Size(min = 8, max = 15)
    private String telNo;
    @NotNull
    @NotBlank
    @Email
    @Size(min = 5, max = 30)
    private String mail;
    @NotNull
    @NotBlank
    @Size(min = 6, max = 20)
    private String password;
    private String state = "Active";
}
