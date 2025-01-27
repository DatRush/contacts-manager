package com.backend.visitingcard.controller;

import com.backend.visitingcard.service.QRCodeService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/qrcode")
public class QRCodeController {
    private final QRCodeService qrCodeService;

    public QRCodeController(QRCodeService qrCodeService) {
        this.qrCodeService = qrCodeService;
    }

    @GetMapping("/{userId}")
    public ResponseEntity<byte[]> getQRCode(@PathVariable String userId) {
        try {
            String profileUrl = "https://myapp.com/profile/" + userId;
            byte[] qrCodeImage = qrCodeService.generateQRCode(profileUrl, 300, 300);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_PNG);
            return ResponseEntity.ok().headers(headers).body(qrCodeImage);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}