package com.sist.web.model;

import java.io.Serializable;

public class KakaoInfo implements Serializable
{
	private static final long serialVersionUID = -5759825008358696764L;
	
	private String nickName;
	
	public KakaoInfo()
	{
		nickName = "";
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	
}
