package com.backend.visitingcard;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication  // Включает автоконфигурацию, сканирование компонентов и конфигурацию Spring.
public class VisitingCardApplication {

	public static void main(String[] args) {
		// Запуск приложения Spring Boot.
		SpringApplication.run(VisitingCardApplication.class, args);
	}
}