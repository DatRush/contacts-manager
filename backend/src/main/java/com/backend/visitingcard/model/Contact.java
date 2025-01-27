package com.backend.visitingcard.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Contact {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name; // Название социальной сети

    @Column
    private String description; // Описание социальной сети

    @Column(nullable = false)
    private String url; // Ссылка на социальную сеть

    @ManyToOne
    @JoinColumn(name = "card_id", nullable = false)
    private Card card; // Владелец этой социальной ссылки
}