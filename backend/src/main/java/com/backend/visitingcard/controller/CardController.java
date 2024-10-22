package com.backend.visitingcard.controller;

import com.backend.visitingcard.model.Card;
import com.backend.visitingcard.model.User;
import com.backend.visitingcard.repository.UserRepository;
import com.backend.visitingcard.service.CardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cards")
public class CardController {

    @Autowired
    private CardService cardService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping
    public ResponseEntity<?> createCard(@RequestBody Card card, @RequestParam Long userId) {
        // Проверка, что пользователь существует.
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Пользователь не найден.");
        }

        // Привязка карточки к пользователю.
        card.setUser(user);

        // Сохранение карточки.
        Card newCard = cardService.createCard(card);
        return new ResponseEntity<>(newCard, HttpStatus.CREATED);
    }
}
