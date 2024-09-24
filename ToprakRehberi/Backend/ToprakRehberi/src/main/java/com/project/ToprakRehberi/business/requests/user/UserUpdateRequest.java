package com.project.ToprakRehberi.business.requests.user;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserUpdateRequest {
    private int id;
    @Size(min = 3, max = 50)
    private String name;
    @Size(min = 7, max = 12)
    private String telNo;
    @Size(min = 5, max = 30)
    private String mail;
    private String password;
    private String state = "Active";
}
