/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ighfir
 */
public class Student extends Account {
    private String studentId;
    private int borrowLimit;

    public Student(String username, String passwordUser, String studentId, int borrowLimit) {
        super(username, passwordUser, "STUDENT");
        this.studentId = studentId;
        this.borrowLimit = borrowLimit;
    }

    @Override
    public String getDashboardUrl() {
        return "student_dashboard.jsp";
    }

    public int getBorrowLimit() {
        return borrowLimit;
    }
}