package com.sist.web.model;

import java.io.Serializable;

public class Facility implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2859160476686319389L;
	
	private int facSeq = 0;
	private String facName = "";
	private String facIconExt = "";
	
	public Facility()
	{
		facSeq = 0;
		facName = "";
		facIconExt = "";
	}

	public int getFacSeq() {
		return facSeq;
	}

	public void setFacSeq(int facSeq) {
		this.facSeq = facSeq;
	}

	public String getFacName() {
		return facName;
	}

	public void setFacName(String facName) {
		this.facName = facName;
	}

	public String getFacIconExt() {
		return facIconExt;
	}

	public void setFacIconExt(String facIconExt) {
		this.facIconExt = facIconExt;
	}
	
	
}
