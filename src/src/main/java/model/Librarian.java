/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ighfir
 */
public class Librarian extends Account {
    private String employeeId;

    public Librarian(String username, String passwordUser, String employeeId) {
        super(username, passwordUser, "LIBRARIAN");
        this.employeeId = employeeId;
    }

    @Override
    public String getDashboardUrl() {
        return "librarian_dashboard.jsp";
    }
}