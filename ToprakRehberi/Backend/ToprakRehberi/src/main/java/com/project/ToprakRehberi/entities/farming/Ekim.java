package com.project.ToprakRehberi.entities.farming;

import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.enums.EkimStatus;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.other.Product;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "ekim")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Ekim {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "ekimTarihi")
    private LocalDate ekimTarihi;

    @Column(name = "m2")
    private int m2;

    @Enumerated(EnumType.STRING) // Enum değerlerini string olarak saklamak için
    @Column(name = "status")
    private EkimStatus status;

    @ManyToOne
    @JoinColumn(name = "land_Id")
    private Land land;

    @Enumerated(EnumType.STRING)
    @Column(name = "mevsim")
    private Mevsim mevsim;

    @ManyToOne
    @JoinColumn(name = "product_Id")
    private Product product;

    @OneToOne(mappedBy = "ekim", cascade = CascadeType.ALL)
    private Hasat hasat;
}
