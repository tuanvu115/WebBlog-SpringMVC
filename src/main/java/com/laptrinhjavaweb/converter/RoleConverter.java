package com.laptrinhjavaweb.converter;

import com.laptrinhjavaweb.dto.RoleDTO;
import com.laptrinhjavaweb.entity.RoleEntity;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Component;

@Component
public class RoleConverter {


    public RoleDTO toDTO(RoleEntity entity) {
        RoleDTO dto = new RoleDTO();
        BeanUtils.copyProperties(entity,dto);
        return dto;
    }

    public RoleEntity toEntity(RoleDTO dto) {
        RoleEntity entity = new RoleEntity();
        BeanUtils.copyProperties(dto,entity);
        return entity;
    }

    public RoleEntity toEntity(RoleDTO dto,RoleEntity result) {
        BeanUtils.copyProperties(dto,result);
        return result;
    }
}
