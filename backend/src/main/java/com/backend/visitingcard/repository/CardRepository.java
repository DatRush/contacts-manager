package com.backend.visitingcard.repository;

import com.backend.visitingcard.model.Card;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CardRepository extends JpaRepository<Card, Long> {
}
