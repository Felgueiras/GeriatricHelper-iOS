//
//  DatesHandler.swift
//  GeriatricHelper
//
//  Created by felgueiras on 21/05/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import Foundation

class DatesHandler{

/**
     package com.felgueiras.apps.geriatric_helper.HelpersHandlers;
     
     import android.annotation.SuppressLint;
     import android.text.format.DateUtils;
     import android.util.Log;
     
     import java.text.ParseException;
     import java.text.SimpleDateFormat;
     import java.util.Calendar;
     import java.util.Date;
     import java.util.GregorianCalendar;
     import java.util.Locale;
     
     /**
     * Created by felgueiras on 15/01/2017.
     */
     
     public class DatesHandler {
     
     /**
     * Convert a Date in String format to Date
     *
     * @param dateString Date in String format
     * @return Date object for that String
     */
     public static Date stringToDate(String dateString) {
     SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy", Locale.UK);
     Date date = null;
     try {
     date = format.parse(dateString);
     //system.out.println(date);
     } catch (ParseException e) {
     e.printStackTrace();
     
     }
     return date;
     }
     
     /**
     * Convert a Date to a String
     *
     * @param date Date object
     * @return String representation of that Date
     */
     public static String dateToStringDayMonthYear(Date date) {
     SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.UK);
     String datetime;
     datetime = format.format(date);
     return datetime;
     }
     
     **/
    
     /**
     * Convert Date to String (without hour).
     *
     * @param eventDate
     * @return
     */
    static func  dateToStringWithoutHour(eventDate:Date) -> String{
     
        return timeAgoSinceDate(date: eventDate)
     }
    
    static func timeAgoSinceDate(date:Date, numericDates:Bool = false) -> String {
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    /**
     
     /**
     * Display Date as day-month-year, without hour.
     *
     * @param date
     * @param currentDateAsToday
     * @return
     */
     public static String dateToStringWithHour(Date date, boolean currentDateAsToday) {
     /**
     * Day.
     */
     SimpleDateFormat dayFormat = new SimpleDateFormat("dd/MM/yyyy", Locale.UK);
     String day = dayFormat.format(date);
     
     
     // get current date - if they match day is 'Hoje'
     Calendar calendar = GregorianCalendar.getInstance(); // creates a new calendar instance
     calendar.setTime(date);   // assigns calendar to given date
     
     
     Calendar cal = Calendar.getInstance();
     Date currentDate = cal.getTime();
     
     
     CharSequence relativeTimeSpanString = DateUtils.getRelativeTimeSpanString(date.getTime(),
     currentDate.getTime(), DateUtils.DAY_IN_MILLIS);
     
     String ret = "";
     
     ret += relativeTimeSpanString.toString();
     
     /**
     * Hour.
     */
     SimpleDateFormat hourFormat = new SimpleDateFormat("HH:mm", Locale.UK);
     String hour = hourFormat.format(date);
     
     ret += " - " + hour;
     return ret;
     }
     
     public static String hour(Date date) {
     SimpleDateFormat format = new SimpleDateFormat("HH:mm", Locale.UK);
     String datetime;
     datetime = format.format(date);
     
     return datetime;
     }
     
     public static Date createCustomDate(int year, int month, int day, int hour, int minute) {
     Calendar cal = Calendar.getInstance();
     cal.set(Calendar.YEAR, year);
     cal.set(Calendar.MONTH, month);
     cal.set(Calendar.DAY_OF_MONTH, day);
     cal.set(Calendar.HOUR_OF_DAY, hour);
     cal.set(Calendar.MINUTE, minute);
     cal.set(Calendar.SECOND, 0);
     cal.set(Calendar.MILLISECOND, 0);
     
     return cal.getTime();
     }
     
     /**
     * Get date (not including hour and minutes).
     *
     * @param date
     * @return
     */
     public static Date getDateWithoutHour(long date) {
     // create a copy of the date with hour and minute set to 0
     
     Calendar calendar = Calendar.getInstance();
     calendar.setTimeInMillis(date);
     return DatesHandler.createCustomDate(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH),
     0, 0);
     }
     }

 **/

}
