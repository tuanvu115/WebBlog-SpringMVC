package com.laptrinhjavaweb.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.laptrinhjavaweb.converter.UserConverter;
import com.laptrinhjavaweb.dto.UserDTO;
import com.laptrinhjavaweb.entity.CommentEntity;
import com.laptrinhjavaweb.entity.UserEntity;
import com.laptrinhjavaweb.repository.UserRepository;
import com.laptrinhjavaweb.service.ICommentService;
import com.laptrinhjavaweb.service.INewService;
import com.laptrinhjavaweb.service.IUserService;
import com.laptrinhjavaweb.util.SecurityUtils;

@Service(value = "userService")
public class UserService implements IUserService {

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private INewService newService;

    @Autowired
    private ICommentService commentService;

    @Autowired
    private UserConverter converter;

    @Override
    public UserDTO save(UserDTO dto) {
        UserEntity entity = new UserEntity();
        if(dto.getId() != null){
            UserEntity oldUser = userRepository.findOne(dto.getId());
            entity = converter.toEntity(dto,oldUser);
            entity.setPassword(bCryptPasswordEncoder.encode(dto.getPassword()));
        }else{
            entity = converter.toEntity(dto);
            entity.setPassword(bCryptPasswordEncoder.encode(dto.getPassword()));
        }
        return converter.toDTO(userRepository.save(entity));
    }


    @Override
    public void delete(Long[] ids) {
        for(Long id:ids){
            UserEntity userEntity = userRepository.findOne(id);
            for(CommentEntity item: userEntity.getComments()){
                commentService.delete(new Long[]{item.getId()});
            }
            newService.findByCreatedBy(userEntity.getUserName()).forEach(item ->{
                newService.delete(new Long[]{item.getId()});
            });
            userRepository.delete(id);
        }
    }


    @Override
    public List<UserDTO> findAll(Pageable pageable) {
        List<UserEntity> entities = userRepository.findAll(pageable).getContent();
        List<UserDTO> results = new ArrayList<>();
        for(UserEntity item:entities){
            results.add(converter.toDTO(item));
        }
        return results;
    }

    @Override
    public Integer totalItem() {
        return (int)userRepository.count();
    }

    @Override
    public UserDTO findById(Long id) {
        return converter.toDTO(userRepository.findOne(id));
    }

    @Override
    public UserDTO findbyUserName(String userName) {
        UserEntity entity = userRepository.findOneByUserName(userName);
        if(entity == null) return null;
        else return converter.toDTO(entity);
    }


	@Override
	public List<UserDTO> searchUser(String searchKey, String searchName, Pageable pageable) {
		List<UserEntity> entities = new ArrayList<UserEntity>();
        List<UserDTO> results = new ArrayList<>();
        
        if(searchKey.equalsIgnoreCase("userName"))
        	entities = userRepository.searchUser(searchName,null,pageable).getContent();
        if(searchKey.equalsIgnoreCase("fullName"))
        	entities = userRepository.searchUser(null,searchName,pageable).getContent();
       
        
        for(UserEntity item:entities){
            results.add(converter.toDTO(item));
        }
        return results;
	}


	@Override
	public Boolean changePassword(String newPassword) {
		UserEntity userEntity = userRepository.findOne(SecurityUtils.getPrincipal().getId());
		userEntity.setPassword(bCryptPasswordEncoder.encode(newPassword));
		if(userRepository.save(userEntity) != null)
			return true;
		return false;
	}


}







