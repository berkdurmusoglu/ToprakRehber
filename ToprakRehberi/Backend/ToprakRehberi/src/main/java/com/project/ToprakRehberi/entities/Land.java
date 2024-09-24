package com.project.ToprakRehberi.entities;


import com.project.ToprakRehberi.entities.adres.Mahalle;
import com.project.ToprakRehberi.entities.enums.LandTypes;
import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.entities.other.Comment;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "land")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Land {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "id")
    private int id;
    @Column(name = "landTip", nullable = false)
    @Enumerated(EnumType.STRING)
    private LandTypes landTip;
    @Column(name = "m2", nullable = false)
    private int m2;
    @Column(name = "ekimM2")
    private int  ekimM2 = 0;
    @Column(name = "landDescription")
    private String landDescription;

    @Column(name = "landImage")
    private String landImage;

    @ManyToOne
    @JoinColumn(name = "user_Id", updatable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "mahalle_Id",updatable = false)
    private Mahalle mahalle;

    @OneToMany(mappedBy = "land", cascade = CascadeType.ALL)
    private List<Ekim> ekimListesi;



}
