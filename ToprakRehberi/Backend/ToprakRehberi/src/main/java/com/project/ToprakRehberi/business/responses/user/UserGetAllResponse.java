package com.project.ToprakRehberi.business.responses.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserGetAllResponse {
    private int id;
    private String name;
    private String mail;
    private String telNo;
    private String profileImage;
}
