package com.project.ToprakRehberi.business.requests.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class UserLoginRequest {
    @NotNull
    @NotBlank
    @Size(min = 5, max = 30)
    private String mail;
    @NotNull
    @NotBlank
    @Size(min = 5, max = 20)
    private String password;
}
