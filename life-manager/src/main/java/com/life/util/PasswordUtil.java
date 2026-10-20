package com.life.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * 密码工具类：注册时加密，登录时校验。
 * BCrypt 每次加盐，同一个明文两次加密结果不同，但都能校验通过。
 */
public final class PasswordUtil {

    /** 工作因子 10，约 0.1 秒一次，兼顾安全与响应速度 */
    private static final int ROUNDS = 10;

    private PasswordUtil() {
    }

    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(ROUNDS));
    }

    public static boolean matches(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.isBlank()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // 数据库里存的不是合法 BCrypt 串时按"密码错误"处理，避免 500
            return false;
        }
    }
}
