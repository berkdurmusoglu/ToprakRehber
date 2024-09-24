package com.project.ToprakRehberi.business.requests.user;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserChangePasswordRequest {
    private int id;
    private String mail;
    private String telNo;
    private String password;
    private String newPassword;

    private String state = "Active";
}
