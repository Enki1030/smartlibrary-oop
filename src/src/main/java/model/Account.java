/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ighfir
 */
public abstract class Account {
    private String username;
    private String passwordUser;
    protected String role;

    public Account(String username, String passwordUser, String role) {
        this.username = username;
        this.passwordUser = passwordUser;
        this.role = role;
    }

    // Abstract method 
    public abstract String getDashboardUrl(); 

    // Getter dan Setter (Encapsulation)
    public String getUsername() { return username; }
    public String getRole() { return role; }
}