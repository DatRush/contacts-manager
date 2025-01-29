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

    public Card createCard(Card card) {
        return cardRepository.save(card);
    }

    public List<Card> getAllCards() {
        return cardRepository.findAll();
    }

    public Card getCardById(Long id) {
        return cardRepository.findById(id).orElse(null);
    }

    public Card updateCard(Long id, Card updatedCard) {
        return cardRepository.findById(id)
                .map(card -> {
                    card.setName(updatedCard.getName());
                    card.setDescription(updatedCard.getDescription());
                    card.setCompany_name(updatedCard.getCompany_name());
                    card.setCompany_address(updatedCard.getCompany_address());
                    card.setPosition(updatedCard.getPosition());
                    card.setAvatar_url(updatedCard.getAvatar_url());
                    return cardRepository.save(card);
                })
                .orElse(null);
    }

    public boolean deleteCard(Long id) {
        if (cardRepository.existsById(id)) {
            cardRepository.deleteById(id);
            return true;
        }
        return false;
    }
}

