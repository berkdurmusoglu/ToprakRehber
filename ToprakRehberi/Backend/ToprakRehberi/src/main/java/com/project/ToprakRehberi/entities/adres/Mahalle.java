package com.project.ToprakRehberi.entities.adres;

import com.project.ToprakRehberi.entities.Land;
import com.project.ToprakRehberi.entities.farming.Rehber;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Table(name = "mahalle")
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Mahalle {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private int id;
    @Column(name = "mahalleName")
    private String mahalleName;

    @ManyToOne
    @JoinColumn(name = "ilce_Id")
    private Ilce ilce;

    @OneToMany(mappedBy = "mahalle")
    List<Land> lands;

    @OneToMany(mappedBy = "mahalle", cascade = CascadeType.ALL)
    private List<Rehber> rehberList;
}