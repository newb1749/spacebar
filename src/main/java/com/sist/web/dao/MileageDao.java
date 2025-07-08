package com.sist.web.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MileageDao 
{

    int getMileageByUserId(@Param("userId") String userId);

    int deductMileage(@Param("userId") String userId, @Param("amount") int amount);

    void addMileage(@Param("userId") String userId, @Param("amount") int amount);

    void insertMileageHistory(@Param("userId") String userId,
                               @Param("amount") int amount,
                               @Param("type") String type,
                               @Param("description") String description);
}
