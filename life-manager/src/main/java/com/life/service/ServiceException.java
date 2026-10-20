package com.life.service;

/**
 * 业务异常：Service 层发现"用户输入不合法"时抛出，
 * Servlet 捕获后把 message 显示在页面上，而不是返回 500。
 */
public class ServiceException extends RuntimeException {

    public ServiceException(String message) {
        super(message);
    }
}