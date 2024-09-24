package com.project.ToprakRehberi.business.requests.other;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@Data
@NoArgsConstructor
public class CommentCreateRequest {
    private int user_ID;
    private int mahalle_ID;
    private int product_ID;
    private int hasat_ID;
    private String body;
}
