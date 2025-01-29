package com.backend.visitingcard.controller;

import com.backend.visitingcard.model.Card;
import com.backend.visitingcard.model.User;
import com.backend.visitingcard.repository.UserRepository;
import com.backend.visitingcard.service.CardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cards")
public class CardController {

    private final UserRepository userRepository;
    private final CardService cardService;

    // Инжектируем userRepository и cardService
    public CardController(UserRepository userRepository, CardService cardService) {
        this.userRepository = userRepository;
        this.cardService = cardService;
    }

    // Создание карточки
    @PostMapping
    public ResponseEntity<?> createCard(@RequestBody Map<String, Object> cardData) {
        Long userId = ((Number) cardData.get("user_id")).longValue(); // Получаем user_id из запроса

        // Проверяем существование пользователя
        User user = userRepository.findById(userId).orElse(null); // <-- теперь вызываем правильно
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Пользователь не найден.");
        }

        // Создаем карточку и привязываем пользователя
        Card card = new Card();
        card.setUser(user); // <-- исправлено
        card.setName((String) cardData.getOrDefault("name", ""));
        card.setDescription((String) cardData.getOrDefault("description", ""));
        card.setCompany_name((String) cardData.getOrDefault("company_name", ""));
        card.setCompany_address((String) cardData.getOrDefault("company_address", ""));
        card.setPosition((String) cardData.getOrDefault("position", ""));
        card.setAvatar_url((String) cardData.getOrDefault("avatar_url", ""));
        card.setUserId(userId);
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
