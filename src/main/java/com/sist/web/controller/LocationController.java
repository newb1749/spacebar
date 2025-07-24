package com.sist.web.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.sist.web.model.NearbyRoomModel;
import com.sist.web.service.LocationService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
public class LocationController {
	
	@Autowired
	private LocationService locationService;
	
	@GetMapping("/location/nearby")
	@ResponseBody
	public List<NearbyRoomModel> getNearbyRooms(
			@RequestParam double latitude, 
			@RequestParam double longitude,
			@RequestParam(required = false) Integer categorySeq,
			@RequestParam(required = false) String orderBy,
			@RequestParam(defaultValue = "50") int limit)
	{
		HashMap<String, Object> param = new HashMap<>();
        param.put("latitude", latitude);
        param.put("longitude", longitude);
        param.put("categorySeq", categorySeq);
        param.put("orderBy", orderBy);
        param.put("limit", limit);
		
		return locationService.getNearbyRooms(param);
	}
	
	@GetMapping("/location/nearbyMap")
	public String nearbyMap()
	{
		return "/location/nearbyMap";
	}
}
