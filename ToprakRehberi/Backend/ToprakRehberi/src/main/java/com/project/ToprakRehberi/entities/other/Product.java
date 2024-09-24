package com.project.ToprakRehberi.entities.other;

import com.project.ToprakRehberi.entities.farming.Ekim;
import com.project.ToprakRehberi.entities.farming.Rehber;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "product")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Product {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private int id;
    @Column(name = "productName")
    private String productName;
    @Column(name = "image")
    private String image;
    @Column(name= "hasatMevsimi")
    private String hasatMevsimi;
    @Column(name = "ekimMevsimi")
    private String ekimMevsimi;

    @Column(name = "ekimDay")
    private int ekimDay;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
    private List<Ekim> ekimListesi;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
    private List<Rehber> rehberList;
}