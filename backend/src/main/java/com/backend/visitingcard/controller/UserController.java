package com.backend.visitingcard.controller;

import com.backend.visitingcard.model.Card;
import com.backend.visitingcard.model.User;
import com.backend.visitingcard.repository.CardRepository;
import com.backend.visitingcard.repository.UserRepository;
import com.backend.visitingcard.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    UserRepository userRepository;
    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    CardRepository cardRepository;

    // Получение всех пользователей
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        if (users.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    // Создание нового пользователя
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody Map<String, String> userData) {
        String username = userData.get("username");
        String email = userData.get("email");
        String password = userData.get("password");

        if (userRepository.existsByUsername(username) || userRepository.existsByEmail(email)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Пользователь уже существует.");
        }

        // Создаём пользователя
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);

        newUser.setPassword(passwordEncoder.encode(password));
        newUser = userRepository.save(newUser);

        // Создаём карточку сразу
        Card newCard = new Card();
        newCard.setUser(newUser); // Привязываем пользователя
        newCard.setName(""); // Оставляем пустые поля
        newCard.setDescription("");
        newCard.setCompany_name("");
        newCard.setCompany_address("");
        newCard.setPosition("");
        newCard.setAvatar_url("");

        newCard = cardRepository.save(newCard);

        // Возвращаем user_id и card_id в ответе
        Map<String, Object> response = new HashMap<>();
        response.put("user_id", newUser.getId());
        response.put("card_id", newCard.getId());

        return ResponseEntity.ok(response);
    }

    // Вход в профиль
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody Map<String, String> loginData) {
        String username = loginData.get("username");
        String password = loginData.get("password");
    
        Optional<User> user = userService.authenticateUser(username, password);
        if (user.isPresent()) {
            Long userId = user.get().getId();
    
            // Теперь передаём объект user, а не userId
            Optional<Card> card = cardRepository.findByUser(user.get());
    
            Map<String, Object> response = new HashMap<>();
            response.put("user_id", userId);
            response.put("card_id", card.map(Card::getId).orElse(null)); // Если карточка есть, вернуть её ID
    
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Неверные учетные данные.");
        }
    }
    
    
    
}
