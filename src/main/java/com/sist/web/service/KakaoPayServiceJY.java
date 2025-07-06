package com.sist.web.service;

import com.sist.web.model.KakaoPayApproveRequest;
import com.sist.web.model.KakaoPayApproveResponse;
import com.sist.web.model.KakaoPayReadyRequest;
import com.sist.web.model.KakaoPayReadyResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.*;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

@Service
public class KakaoPayServiceJY {

    private static final Logger logger = LoggerFactory.getLogger(KakaoPayServiceJY.class);

    // 테스트용 Admin Key (DEV)
    private final String adminKey = "f92aca0ec641dbf4ccebf7ccd6d8d07f"; // ✅ 올바른 REST API 키

    private static final String READY_URL = "https://kapi.kakao.com/v1/payment/ready";
    private static final String APPROVE_URL = "https://kapi.kakao.com/v1/payment/approve";

    /**
     * 카카오페이 결제 준비 요청
     */
    public KakaoPayReadyResponse ready(KakaoPayReadyRequest request) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK " + adminKey);
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

            // request.toMap()은 MultiValueMap<String,String> 타입으로 변환된 파라미터여야 합니다.
            MultiValueMap<String, String> params = request.toMap();

            HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

            ResponseEntity<KakaoPayReadyResponse> response = restTemplate.postForEntity(READY_URL, entity, KakaoPayReadyResponse.class);

            logger.debug("KakaoPay Ready Response: {}", response.getBody());

            return response.getBody();
        } catch (Exception e) {
            logger.debug("Authorization header: KakaoAK " + adminKey);
            logger.debug("Request params: " + request.toMap());

            logger.error("카카오페이 ready 실패", e);
            return null;
        }
    }

    /**
     * 카카오페이 결제 승인 요청
     */
    public KakaoPayApproveResponse approve(KakaoPayApproveRequest request) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK " + adminKey);
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

            MultiValueMap<String, String> params = request.toMap();

            HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

            ResponseEntity<KakaoPayApproveResponse> response = restTemplate.postForEntity(APPROVE_URL, entity, KakaoPayApproveResponse.class);

            logger.debug("KakaoPay Approve Response: {}", response.getBody());

            return response.getBody();
        } catch (Exception e) {
            logger.error("카카오페이 approve 실패", e);
            return null;
        }
    }
}
