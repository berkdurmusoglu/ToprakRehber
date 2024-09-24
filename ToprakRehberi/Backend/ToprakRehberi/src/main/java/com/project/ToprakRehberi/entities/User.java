package com.project.ToprakRehberi.entities;


import com.project.ToprakRehberi.entities.other.Comment;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "user")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;
    @Column(name = "name", nullable = false)
    private String name;
    @Column(name = "password", nullable = false, updatable = false)
    private String password;
    @Column(name = "mail", nullable = false)
    private String mail;
    @Column(name = "telNo", nullable = false)
    private String telNo;
    @Column(name = "state", nullable = false)
    private String state;

    @Column(name = "profileImage")
    private String profileImage;

    @OneToMany(mappedBy = "user")
    List<Land> lands;

    @OneToMany(mappedBy = "user")
    List<Comment> comments;


}
