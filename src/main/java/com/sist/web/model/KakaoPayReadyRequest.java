package com.sist.web.model;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

public class KakaoPayReadyRequest {
    private String cid = "TC0ONETIME"; // 테스트 CID
    private String partner_order_id;
    private String partner_user_id;
    private String item_name;
    private String item_code;
    private int quantity = 1;
    private int total_amount;
    private int tax_free_amount = 0;

    private String approval_url = "http://localhost:8080/payment/success";
    private String cancel_url = "http://localhost:8080/payment/cancel";
    private String fail_url = "http://localhost:8080/payment/fail";

    public KakaoPayReadyRequest() {}

    public KakaoPayReadyRequest(String userId, String orderId, int amount) {
        this.partner_user_id = userId;
        this.partner_order_id = orderId;
        this.total_amount = amount;
        this.item_name = "마일리지 충전";
        this.quantity = 1;
    }

    public MultiValueMap<String, String> toMap() {
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("cid", cid);
        params.add("partner_order_id", partner_order_id);
        params.add("partner_user_id", partner_user_id);
        params.add("item_name", item_name);
        if (item_code != null) params.add("item_code", item_code);
        params.add("quantity", String.valueOf(quantity));
        params.add("total_amount", String.valueOf(total_amount));
        params.add("tax_free_amount", String.valueOf(tax_free_amount));
        params.add("approval_url", approval_url);
        params.add("cancel_url", cancel_url);
        params.add("fail_url", fail_url);
        return params;
    }

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	public String getPartner_order_id() {
		return partner_order_id;
	}

	public void setPartner_order_id(String partner_order_id) {
		this.partner_order_id = partner_order_id;
	}

	public String getPartner_user_id() {
		return partner_user_id;
	}

	public void setPartner_user_id(String partner_user_id) {
		this.partner_user_id = partner_user_id;
	}

	public String getItem_name() {
		return item_name;
	}

	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}

	public String getItem_code() {
		return item_code;
	}

	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getTotal_amount() {
		return total_amount;
	}

	public void setTotal_amount(int total_amount) {
		this.total_amount = total_amount;
	}

	public int getTax_free_amount() {
		return tax_free_amount;
	}

	public void setTax_free_amount(int tax_free_amount) {
		this.tax_free_amount = tax_free_amount;
	}

	public String getApproval_url() {
		return approval_url;
	}

	public void setApproval_url(String approval_url) {
		this.approval_url = approval_url;
	}

	public String getCancel_url() {
		return cancel_url;
	}

	public void setCancel_url(String cancel_url) {
		this.cancel_url = cancel_url;
	}

	public String getFail_url() {
		return fail_url;
	}

	public void setFail_url(String fail_url) {
		this.fail_url = fail_url;
	}

}
