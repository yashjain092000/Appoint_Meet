# Appoint_Meet

An automated appointments booking and management flutter mobile application with Firebase integrated.
## About Appoint_Meet
Appoint_Meet is a mobile application developed using Google Flutter framework and coded in dart language. This mobile application automates the process of booking and handling appointments, from both appointer’s and appointee’s perspective and provides hassle-free experience for both the users. It uses Google’s Firebase and Cloud Firestore for storing, retrieving and performing data related operations. Also uploading the prescription of all the appointees will digitize and make the task of maintaining each appointees’ file manageable and easily accessible for the appointer’s assistant. This mobile application is initially being developed keeping the doctor-patient scenario in mind but further can be made generic for all other appointment-based scenarios.

## Overview and Motivation	
During lockdown period I was taking to my friend, who told me about the grim medical condition of his Grand Ma, that he could find no doctor to diagnose her due to Covid-19 pandemic. As we were pondering upon the situation, I came across a solution of providing an automated appointment management system that can book, delete and manage appointments for both appointer and appointee without any physical contact which will not only save the time but also avoid the chances of physical contact. 

## Objective	
To automate the process of booking, deleting and handling appointments, and digitalize the file system that is maintained by appointer or his/her assistant from both appointer’s and appointee’s perspective and provide hassle-free experience to all  the users.  

## Contents
* **Welcome Screen**
This is the welcome screen that opens up whenever the user is not logged in the application. It contains application title, logo and about the app.

* **Login Screen**
This is the login screen applicable for any type of user whether appointer or appointee. It redirects the user to their respective dashboard on successful logging in otherwise displays a red error snack bar containing the error message occurred during authentication.

* **Signup Screen**
This is the signup screen that contains various fields corresponding to the user type whether appointer or appointee. Below it contains a separate raised button for appointer signup and a signup button that on pressed checks whether all credentials entered by the user are valid if yes then redirects the user to its respective dashboard else marks the wrong field red displaying the message associated.

* **Appointee Dashboard**
This is the appointee dashboard that contains a side hidden drawer containing 4 screens as mentioned below. At the top it has a notification bell and at top right it contains a logout button.
After the app bar it has an appointee search bar below which is present a carousel of moving images. Below the carousel is the total appointments count followed by a list tile containing different appointments of different appointers containing specific info related to time, appointment number, prescription uploaded or not.

* **Appointment Booking Screen**
This screen contains all info of the selected appointer including address, contact info, specialization, timings,etc. where appointee can choose appointment date and book his/her appointment.

* **My Appointments Screen**
This screen contains info of all the appointments booked by user.

* **Update Profile Screen**
This screen contains all the fields including profile image that can be updated or changed by the user.

* **Notifications Screen**
This screen contains a list of notifications of any appointment that has been deleted by the appointer.

* **Feedback/Rating Screen**
This screen contains a star rating slider followed by a text field for feedback.

* **Appointer Dashboard**
The appointer dashboard contains a side hidden drawer at the top right corner and at the top right a log out button. Below it is a text indicator that tells the user whether the ‘holiday mode’ is on or off followed by an image carousel. Below it is the total appointment count for today followed by a list of today’s appointments containing other additional info like time, appointment number, patient name and an option to upload the prescription.

* **Past Appointments Screen**
This screen contains info of all the appointments of the user.

## Screenshots
![](/shots/1.jpg)
<img src="/shots/1.jpg" height="500" width="200">



