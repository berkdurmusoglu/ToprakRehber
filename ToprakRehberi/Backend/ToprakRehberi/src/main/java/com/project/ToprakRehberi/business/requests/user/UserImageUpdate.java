package com.project.ToprakRehberi.business.requests.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserImageUpdate {
    int id;
    String profileImage;
}
