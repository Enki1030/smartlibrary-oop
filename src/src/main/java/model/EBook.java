/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ighfir
 */
public class EBook extends LibraryResource {
    private double fileSize;
    private String fileFormat;
    private String downloadUrl;

    public EBook(String id, String title, String author, int year, boolean isAvailable, double fileSize, String fileFormat, String downloadUrl) {
        super(id, title, author, year, isAvailable);
        this.fileSize = fileSize;
        this.fileFormat = fileFormat;
        this.downloadUrl = downloadUrl;
    }

    public double getFileSize() {
        return fileSize;
    }

    public String getFileFormat() {
        return fileFormat;
    }

    public String getDownloadUrl() {
        return downloadUrl;
    }

    @Override
    public String getDetailInfo() {
        return "Digital (" + fileFormat + " - " + fileSize + "MB) | Link: <a href='" + downloadUrl + "'>Unduh</a>";
    }
}