package com.project.ToprakRehberi.entities.adres;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Table(name = "ilce")
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Ilce {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "ilceName")
    private String ilceName;

    @ManyToOne
    @JoinColumn(name = "il_Id")
    private Il il;

    @OneToMany(mappedBy = "ilce")
    List<Mahalle> mahalleler;


}