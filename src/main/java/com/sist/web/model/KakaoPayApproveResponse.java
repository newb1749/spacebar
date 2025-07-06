package com.sist.web.model;

public class KakaoPayApproveResponse {
    private String aid;
    private String tid;
    private String cid;
    private String sid;
    private String partner_order_id;
    private String partner_user_id;
    private String payment_method_type;
    private KakaoPayAmount amount;
    private KakaoPayCardInfo card_info;

    private String item_name;
    private String item_code;
    private int quantity;

    private String created_at;
    private String approved_at;

    // 에러 정보 (필요한 경우)
    private String error_code;
    private String error_message;
    private KakaoPayApproveErrorExtras extras;

    // Getters / Setters
    public KakaoPayAmount getAmount() {
        return amount;
    }

    public void setAmount(KakaoPayAmount amount) {
        this.amount = amount;
    }

    public String getError_code() {
        return error_code;
    }

    public void setError_code(String error_code) {
        this.error_code = error_code;
    }

    public String getError_message() {
        return error_message;
    }

    public void setError_message(String error_message) {
        this.error_message = error_message;
    }

    public KakaoPayApproveErrorExtras getExtras() {
        return extras;
    }

    public void setExtras(KakaoPayApproveErrorExtras extras) {
        this.extras = extras;
    }

    // 나머지 필드들도 필요 시 getter/setter 추가
}
