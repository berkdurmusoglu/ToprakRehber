package com.project.ToprakRehberi.entities.farming;

import com.project.ToprakRehberi.entities.adres.Mahalle;
import com.project.ToprakRehberi.entities.enums.Mevsim;
import com.project.ToprakRehberi.entities.other.Comment;
import com.project.ToprakRehberi.entities.other.Product;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "rehber")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Rehber {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "sonuc")
    private double sonuc;

    @ManyToOne
    @JoinColumn(name = "mahalle_Id")
    private Mahalle mahalle;

    @ManyToOne
    @JoinColumn(name = "product_Id")
    private Product product;

    @Enumerated(EnumType.STRING) // Mevsimi string olarak saklamak için
    @Column(name = "mevsim")
    private Mevsim mevsim;

    @OneToMany(mappedBy = "rehber")
    List<Comment> comments;
}
