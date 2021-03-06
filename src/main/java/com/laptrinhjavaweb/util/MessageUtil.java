package com.laptrinhjavaweb.util;

import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class MessageUtil {

    public Map<String,String> getMessage(String message){
        Map<String,String> result = new HashMap<>();
        if(message.equals("update_success")){
            result.put("message","Update success");
            result.put("alert","success");
        }
        else if(message.equals("insert_success")){
            result.put("message","Insert success");
            result.put("alert","success");
        }
        else if(message.equals("error_system")){
            result.put("message","Error System");
            result.put("alert","danger");
        }
        else if(message.equals("delete_success")){
            result.put("message","Delete Success");
            result.put("alert","success");
        }
        else if(message.equals("register-success")){
            result.put("message","Đăng ký thành công");
            result.put("alert","success");
        }
        else if(message.equals("register-error")){
            result.put("message","Tên tài khoản đã tồn tại");
            result.put("alert","danger");
        }
        
        else if(message.equals("change_password_success")){
            result.put("message","Đổi mật khẩu thành công");
            result.put("alert","success");
        }
        else if(message.equals("wrong_password")){
            result.put("message","Sai mật khẩu hiện tại");
            result.put("alert","danger");
        }
        else if(message.equals("2password_not_equal")){
            result.put("message","Xác nhận mật khẩu không khớp nhau");
            result.put("alert","danger");
        }
        
        
        
        
        

        return result;
    }
}
