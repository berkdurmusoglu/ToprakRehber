package com.project.ToprakRehberi.entities.other;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "hasatSonuclari")
@AllArgsConstructor
@Data
@NoArgsConstructor
public class HasatSonuclari {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "hasatSonuc")
    private String hasatSonuc;

    @Column(name = "image")
    private String image;

}
