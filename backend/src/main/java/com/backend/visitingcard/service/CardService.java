package com.backend.visitingcard.service;

import com.backend.visitingcard.model.Card;
import com.backend.visitingcard.repository.CardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CardService {

    @Autowired
    private CardRepository cardRepository;

    // Получение всех карточек
    public List<Card> getAllCards() {
        return cardRepository.findAll();
    }

    // Создание карточки
    public Card createCard(Card card) {
        return cardRepository.save(card);
    }

    // Получение карточки по ID
    public Card getCardById(Long id) {
        return cardRepository.findById(id).orElse(null);
    }

    // Обновление карточки
    // Обновление карточки
    public Card updateCard(Long id, Card updatedCard) {
        // Найти существующую карточку по ID
        return cardRepository.findById(id).map(card -> {
            // Обновляем доступные поля
            card.setName(updatedCard.getName());
            card.setCompanyName(updatedCard.getCompanyName());
            card.setCompanyAddress(updatedCard.getCompanyAddress());
            card.setPosition(updatedCard.getPosition());
            card.setDescription(updatedCard.getDescription());
            card.setAvatarUrl(updatedCard.getAvatarUrl());

            // Обновляем социальные ссылки (если переданы новые)
            if (updatedCard.getContacts() != null) {
                card.setContacts(updatedCard.getContacts());
            }

            // Сохраняем обновленную карточку
            return cardRepository.save(card);
        }).orElseThrow(() -> new IllegalArgumentException("Card with ID " + id + " not found"));
    }

    // Удаление карточки
    public boolean deleteCard(Long id) {
        if (cardRepository.existsById(id)) {
            cardRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
