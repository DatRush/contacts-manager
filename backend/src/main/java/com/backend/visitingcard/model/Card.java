package com.backend.visitingcard.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
public class Card {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = true)
    private String name;

    @Column(nullable = true)
    private String description;

    @Column(nullable = true)
    private String company_name;

    @Column(nullable = true)
    private String company_address;

    @Column(nullable = true)
    private String position;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(updatable = false)
    private LocalDateTime created_at = LocalDateTime.now();

    @Column(nullable = false)
    private String avatar_url;

    public void setUserId(Long userId) {
        this.user = new User();
        this.user.setId(userId);
    }

}
