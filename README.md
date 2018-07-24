# gun_violence_data_visualization_with_Shiny

This repository contains my Shiny app's source code.
My Shiny app is available at [here](https://fangyeshi.shinyapps.io/gun_violence_data_visualization_with_Shiny/)

Data: https://github.com/jamesqo/gun-violence-data
Source: http://www.gunviolencearchive.org/

Note: Las Vegas incident is not included

Only part of the original dataset is used.
We describe the selection criteria below:

## Selected Column Name

### **incident_id:** *Unique integer values served as indices*
### **date:**	*From 2013-01-05 to 2018-03-31*			
### **state:** *51 levels*						
### **city:**	*11731 levels*
### **n_killed:**	*Integers, min=0,median=0,mean=0.2696,max=17*
### **n_injured:** *Integers, min=0,median=0,mean=0.4405,max=17*
### **n_victims:=n_killed+n_injured**
### **incident_url:** *Always have address www.gunviolencearchive.org/incident/incident_id*
### **n_guns_involved:** *Integers, min=1,median=1,mean=1.41,max=400,NA's=76827*
### **gun_stolen:** *Dict with values chosen from {NA,"Unknown","Not-stolen","Stolen"}, stored as a string*
### **gun_type:**	*Dict with values chosen from {NA,"Unknown",...(26 other types)}, stored as a string*
#### ***Note: Only choose rows where n_guns_involved=length(gun_stolen)=length(guntype) or all 3 are NA's.***
### **incident_characteristics:** *List with values chosen from {NA,"NAV",...(108 other types)}, stored as a string*
### **latitude**											              
### **longitude**
#### ***Note: Only choose rows where latitude!=NA and longitude!=NA. This is purly for the purpose of plotting points on map.And some of the latitude/longitude data looks wrong*** 
### **participant_age_group:** *Dict with values chosen from {NA,"Adult 18+","Teen 12-17","Child 0-11"}, stored as a string*
### **participant_gender:** *Dict with values chosen from {NA,"Male","Female"}, stored as a string*
#### ***Note: Remove rows where participant_gender maybe "male,female" which could be a mistake in original data.***
### **participant_status:** *Dict with values chosen from {NA,"Arrested","Killed","Injured","Unharmed","Unharmed,        Arrested","Injured, Arrested"}, stored as a string*    
#### ***Note: Remove rows where participant_status does not make sense, e.g. "Unharmed, Injured" etc.***
### **participant_type:** *Dict with values chosen from {NA,"Victim","Subject-Suspect"}, stored as a string*
#### ***Note: Only choose rows where participant_age_group,participant_gender,                                             participant_status,and participant_type all have equal length.***
### **year:=lubridate::year(date)**                             
### **quarter=lubridate::quarter(date)**
### **month=lubridate::month(date)**                           


