package com.sist.web.model;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

public class KakaoPayApproveRequest 
{
    private String cid = "TC0ONETIME"; // 테스트용 CID
    private String tid;
    private String partner_order_id;
    private String partner_user_id;
    private String pg_token;

    public KakaoPayApproveRequest() {}

    public KakaoPayApproveRequest(String tid, String orderId, String userId, String pg_token) {
        this.tid = tid;
        this.partner_order_id = orderId;
        this.partner_user_id = userId;
        this.pg_token = pg_token;
    }

    public MultiValueMap<String, String> toMap() {
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("cid", cid);
        params.add("tid", tid);
        params.add("partner_order_id", partner_order_id);
        params.add("partner_user_id", partner_user_id);
        params.add("pg_token", pg_token);
        return params;
    }

    // Getters / Setters 생략 가능
}
