package model;

import java.io.Serializable;

public class Timetable implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int deptId;
    private String deptName;
    private int semester;
    private String dayOfWeek;
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private String timeSlot;
    private String roomNo;

    public Timetable() {}

    public Timetable(int id, int deptId, int semester, String dayOfWeek, int subjectId, String timeSlot, String roomNo) {
        this.id = id;
        this.deptId = deptId;
        this.semester = semester;
        this.dayOfWeek = dayOfWeek;
        this.subjectId = subjectId;
        this.timeSlot = timeSlot;
        this.roomNo = roomNo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }
}
