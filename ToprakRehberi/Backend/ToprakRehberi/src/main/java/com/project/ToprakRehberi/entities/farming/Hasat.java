package com.project.ToprakRehberi.entities.farming;

import com.project.ToprakRehberi.business.responses.farming.RehberGetResponse;
import com.project.ToprakRehberi.entities.enums.HasatSonuc;
import com.project.ToprakRehberi.entities.other.Comment;
import com.project.ToprakRehberi.entities.other.Product;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "hasat")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Hasat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "ekim_id")
    private Ekim ekim;

    @Column(name = "hasatMiktari")
    private Double hasatMiktari;

    @Column(name = "hasatTarihi")
    private LocalDate hasatTarihi;

    @Enumerated(EnumType.STRING)
    @Column(name = "hasatSonuc")
    private HasatSonuc hasatSonuc;

    @OneToMany(mappedBy = "hasat")
    List<Comment> comments;

}
