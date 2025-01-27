package com.backend.visitingcard.repository;

import com.backend.visitingcard.model.Contact;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContactRepository extends JpaRepository<Contact, Long> {
}

