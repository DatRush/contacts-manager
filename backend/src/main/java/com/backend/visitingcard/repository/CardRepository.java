package com.backend.visitingcard.repository;

import com.backend.visitingcard.model.Card;
import com.backend.visitingcard.model.User;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface CardRepository extends JpaRepository<Card, Long> {
    Optional<Card> findByUser(User user); // Поиск по объекту User
}

