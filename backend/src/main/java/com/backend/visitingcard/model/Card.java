package com.backend.visitingcard.model;

import jakarta.persistence.*;
import jdk.jfr.DataAmount;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
public class Card {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
    private String company;
    private String position;
    private String email;
    private String phone;
    private String website;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private LocalDateTime createdAt = LocalDateTime.now();
}
