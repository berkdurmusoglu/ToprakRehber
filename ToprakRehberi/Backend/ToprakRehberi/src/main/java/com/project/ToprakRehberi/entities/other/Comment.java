package com.project.ToprakRehberi.entities.other;

import com.project.ToprakRehberi.entities.User;
import com.project.ToprakRehberi.entities.farming.Hasat;
import com.project.ToprakRehberi.entities.farming.Rehber;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "comments")
@AllArgsConstructor
@Data
@NoArgsConstructor
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotBlank
    @Size
    private String body;

    @ManyToOne
    @JoinColumn(name = "user",nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "rehber",nullable = false)
    private Rehber rehber;

    @ManyToOne
    @JoinColumn(name = "hasat",nullable = false)
    private Hasat hasat;

    @Column(name = "createdDate", nullable = false, updatable = false)
    private LocalDateTime createdDate;

}
