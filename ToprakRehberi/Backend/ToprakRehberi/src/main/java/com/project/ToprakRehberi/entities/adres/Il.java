package com.project.ToprakRehberi.entities.adres;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Table(name = "il")
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Il {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "ilName")
    private String ilName;

    @OneToMany(mappedBy = "il")
    List<Ilce> ilceler;
}

