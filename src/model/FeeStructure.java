package model;

import java.io.Serializable;

public class FeeStructure implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int deptId;
    private String deptName;
    private int semester;
    private double tuitionFee;
    private double examFee;
    private double otherFee;
    private double totalFee;

    public FeeStructure() {}

    public FeeStructure(int id, int deptId, int semester, double tuitionFee, double examFee, double otherFee, double totalFee) {
        this.id = id;
        this.deptId = deptId;
        this.semester = semester;
        this.tuitionFee = tuitionFee;
        this.examFee = examFee;
        this.otherFee = otherFee;
        this.totalFee = totalFee;
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

    public double getTuitionFee() {
        return tuitionFee;
    }

    public void setTuitionFee(double tuitionFee) {
        this.tuitionFee = tuitionFee;
    }

    public double getExamFee() {
        return examFee;
    }

    public void setExamFee(double examFee) {
        this.examFee = examFee;
    }

    public double getOtherFee() {
        return otherFee;
    }

    public void setOtherFee(double otherFee) {
        this.otherFee = otherFee;
    }

    public double getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(double totalFee) {
        this.totalFee = totalFee;
    }
}
