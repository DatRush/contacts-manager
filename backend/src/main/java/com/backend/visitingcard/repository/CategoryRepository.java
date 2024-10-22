package com.backend.visitingcard.repository;

import com.backend.visitingcard.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}

