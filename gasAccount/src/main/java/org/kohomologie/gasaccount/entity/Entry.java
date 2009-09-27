/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.kohomologie.gasaccount.entity;

import java.sql.Date;

/**
 *
 * @author antechrome
 * A class representing an entry in a gas expenditure accounting journal.
 */
public class Entry {
    private Date fixDate;
    private double numberOfGallons;
    private double priceOfAGallon;
    private String fuelBrand;
    private int mileage;

    public static final String fixDateColumnName = "FIX_DATE";
    public static final String numberOfGallonsColumnName = "NUM_GALLONS";
    public static final String priceOfAGallonColumnName = "PRICE_GALLON";
    public static final String fuelBrandColumnName = "FUEL_BRAND";
    public static final String mileageColumnName = "MILEAGE";


    /**
     * @return the numberOfGallons
     */
    public double getNumberOfGallons() {
        return numberOfGallons;
    }

    /**
     * @param numberOfGallons the numberOfGallons to set
     */
    public Entry numberOfGallons(double numberOfGallons) {
        this.setNumberOfGallons(numberOfGallons);
        return this;
    }

    /**
     * @return the priceOfAGallon
     */
    public double getPriceOfAGallon() {
        return priceOfAGallon;
    }

    /**
     * @param priceOfAGallon the priceOfAGallon to set
     */
    public Entry priceOfAGallon(double priceOfAGallon) {
        this.setPriceOfAGallon(priceOfAGallon);
        return this;
    }

    /**
     * @return the fuelBrand
     */
    public String getFuelBrand() {
        return fuelBrand;
    }

    /**
     * @param fuelBrand the fuelBrand to set
     */
    public Entry fuelBrand(String fuelBrand) {
        this.setFuelBrand(fuelBrand);
        return this;
    }

    /**
     * @return the mileage
     */
    public int getMileage() {
        return mileage;
    }

    /**
     * @param mileage the mileage to set
     */
    public Entry mileage(int mileage) {
        this.setMileage(mileage);
        return this;
    }

    public double getTotalPrice()
    {
        return numberOfGallons*priceOfAGallon;
    }

    /**
     * @return the fixDate
     */
    public Date getFixDate() {
        return fixDate;
    }

    public Entry fixDate(Date fixDate) {
        this.fixDate = fixDate;
        return this;
    }

    /**
     * @param fixDate the fixDate to set
     */
    public void setFixDate(Date fixDate) {
        this.fixDate = fixDate;
    }

    /**
     * @param numberOfGallons the numberOfGallons to set
     */
    public void setNumberOfGallons(double numberOfGallons) {
        this.numberOfGallons = numberOfGallons;
    }

    /**
     * @param priceOfAGallon the priceOfAGallon to set
     */
    public void setPriceOfAGallon(double priceOfAGallon) {
        this.priceOfAGallon = priceOfAGallon;
    }

    /**
     * @param fuelBrand the fuelBrand to set
     */
    public void setFuelBrand(String fuelBrand) {
        this.fuelBrand = fuelBrand;
    }

    /**
     * @param mileage the mileage to set
     */
    public void setMileage(int mileage) {
        this.mileage = mileage;
    }

    @Override
    public String toString()
    {
        return "fixDate="+fixDate+
                ";fuelBrand="+fuelBrand+
                ";mileage="+mileage+
                ";number of gallons"+numberOfGallons+
                ";price of a gallon"+priceOfAGallon+";"
                ;
    }
}
