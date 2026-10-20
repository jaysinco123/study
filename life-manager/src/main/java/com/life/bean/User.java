package com.life.bean;

/**
 * 用户实体类（JavaBean）：字段与 t_user 表一一对应。
 */
public class User {

    private int id;
    private String username;
    private String password;
    private String nickname;
    private String email;
    private int role;    // 0 普通用户，1 管理员
    private int status;  // 1 正常，0 禁用

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    /** JSP 中可直接写 ${sessionScope.user.admin} 判断是否为管理员 */
    public boolean isAdmin() {
        return role == 1;
    }
}