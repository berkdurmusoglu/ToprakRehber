package com.project.ToprakRehberi.entities.other;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "landTypes")
@AllArgsConstructor
@Data
@NoArgsConstructor
public class LandType {
    @Id
    @Column(name = "landTypeName")
    private String landTypeName;

}
