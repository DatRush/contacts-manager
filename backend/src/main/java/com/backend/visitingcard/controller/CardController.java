package com.backend.visitingcard.controller;

import com.backend.visitingcard.model.Card;
import com.backend.visitingcard.model.User;
import com.backend.visitingcard.repository.UserRepository;
import com.backend.visitingcard.service.CardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cards")
public class CardController {

    @Autowired
    private CardService cardService;

    @Autowired
    private UserRepository userRepository;

    // Создание карточки
    @PostMapping
    public ResponseEntity<?> createCard(@RequestBody Card card, @RequestParam Long userId) {
        // Проверяем существование пользователя
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Пользователь не найден.");
        }

        // Привязываем карточку к пользователю
        card.setUser(user);

        // Сохраняем карточку
        Card newCard = cardService.createCard(card);
        return new ResponseEntity<>(newCard, HttpStatus.CREATED);
    }

    // Получение всех карточек
    @GetMapping
    public ResponseEntity<List<Card>> getAllCards() {
        List<Card> cards = cardService.getAllCards();
        return new ResponseEntity<>(cards, HttpStatus.OK);
    }

    // Получение карточки по ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getCardById(@PathVariable Long id) {
        Card card = cardService.getCardById(id);
        if (card == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Карточка не найдена.");
        }
        return new ResponseEntity<>(card, HttpStatus.OK);
    }

    // Обновление карточки
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCard(@PathVariable Long id, @RequestBody Card updatedCard) {
        Card card = cardService.updateCard(id, updatedCard);
        if (card == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Карточка не найдена.");
        }
        return new ResponseEntity<>(card, HttpStatus.OK);
    }

    // Удаление карточки
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCard(@PathVariable Long id) {
        boolean deleted = cardService.deleteCard(id);
        if (!deleted) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Карточка не найдена.");
        }
        return ResponseEntity.ok("Карточка успешно удалена.");
    }
}
