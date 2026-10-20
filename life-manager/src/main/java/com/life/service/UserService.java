package com.life.service;

import com.life.bean.User;
import com.life.dao.UserDao;
import com.life.util.PasswordUtil;

import java.util.List;

/**
 * 用户业务层：登录校验、注册规则、状态修改。
 * 所有"能不能做"的判断都放在这里，DAO 只负责执行 SQL。
 */
public class UserService {

    private final UserDao userDao = new UserDao();

    /**
     * 登录：账号存在 -> 密码正确 -> 账号未被禁用。
     * 失败抛 ServiceException，message 直接显示给用户。
     */
    public User login(String username, String password) {
        if (username.isEmpty() || password.isEmpty()) {
            throw new ServiceException("请输入账号和密码");
        }
        User user = userDao.findByUsername(username);
        if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
            throw new ServiceException("账号或密码错误");
        }
        if (user.getStatus() != 1) {
            throw new ServiceException("该账号已被禁用，请联系管理员");
        }
        // 密码哈希不带到 Session 里，登录成功后清空
        user.setPassword(null);
        return user;
    }

    /** 注册：校验格式 -> 校验账号唯一 -> 密码加密 -> 入库 */
    public void register(String username, String password, String confirm, String nickname) {
        if (!username.matches("[A-Za-z0-9_]{3,20}")) {
            throw new ServiceException("账号需为 3-20 位字母、数字或下划线");
        }
        if (password.length() < 6 || password.length() > 20) {
            throw new ServiceException("密码长度需为 6-20 位");
        }
        if (!password.equals(confirm)) {
            throw new ServiceException("两次输入的密码不一致");
        }
        if (userDao.existsByUsername(username)) {
            throw new ServiceException("该账号已被注册，请换一个");
        }
        String finalNickname = nickname.isEmpty() ? username : nickname;
        if (finalNickname.length() > 30) {
            throw new ServiceException("昵称不能超过 30 个字符");
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtil.hash(password));
        user.setNickname(finalNickname);
        userDao.insert(user);
    }

//    后台与个人中心
    public List<User> listAll() {
        return userDao.findAll();
    }

    /** 管理员启用/禁用账号：不能操作自己，状态值只能是 0 或 1 */
    public void changeStatus(int operatorId, int targetId, int status) {
        if (operatorId == targetId) {
            throw new ServiceException("不能修改自己的账号状态");
        }
        if (status != 0 && status != 1) {
            throw new ServiceException("状态值不合法");
        }
        userDao.updateStatus(targetId, status);
    }

    /** 修改昵称/邮箱：校验后写库，返回最新的用户对象（用于刷新 Session） */
    public User updateProfile(int userId, String nickname, String email) {
        if (nickname == null || nickname.isBlank()) {
            throw new ServiceException("昵称不能为空");
        }
        if (nickname.length() > 30) {
            throw new ServiceException("昵称不能超过 30 个字符");
        }
        if (email != null && !email.isEmpty()) {
            if (email.length() > 80) {
                throw new ServiceException("邮箱不能超过 80 个字符");
            }
            if (!email.matches("[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+")) {
                throw new ServiceException("邮箱格式不正确");
            }
        }
        userDao.updateProfile(userId, nickname.trim(), email == null ? "" : email.trim());
        User user = userDao.findById(userId);
        if (user == null) {
            throw new ServiceException("用户不存在，请重新登录");
        }
        user.setPassword(null);
        return user;
    }

    /** 修改密码：先校验原密码，再校验新密码长度与两次一致 */
    public void changePassword(int userId, String oldPassword, String newPassword, String confirm) {
        User user = userDao.findById(userId);
        if (user == null) {
            throw new ServiceException("用户不存在，请重新登录");
        }
        if (!PasswordUtil.matches(oldPassword, user.getPassword())) {
            throw new ServiceException("原密码不正确");
        }
        if (newPassword == null || newPassword.length() < 6 || newPassword.length() > 20) {
            throw new ServiceException("新密码长度需为 6-20 位");
        }
        if (!newPassword.equals(confirm)) {
            throw new ServiceException("两次输入的新密码不一致");
        }
        if (newPassword.equals(oldPassword)) {
            throw new ServiceException("新密码不能与原密码相同");
        }
        userDao.updatePassword(userId, PasswordUtil.hash(newPassword));
    }
}