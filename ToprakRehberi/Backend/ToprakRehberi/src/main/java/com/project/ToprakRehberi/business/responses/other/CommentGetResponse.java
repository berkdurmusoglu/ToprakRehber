package com.project.ToprakRehberi.business.responses.other;

import com.project.ToprakRehberi.business.responses.farming.HasatGetEkimId;
import com.project.ToprakRehberi.business.responses.farming.RehberGetResponse;
import com.project.ToprakRehberi.business.responses.user.UserGetAllResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@AllArgsConstructor
@Data
@NoArgsConstructor
public class CommentGetResponse {

    private String body;
    private UserGetAllResponse user;
    private RehberGetResponse rehber;
    private HasatGetEkimId hasat;
    private LocalDateTime createdDate;
}
