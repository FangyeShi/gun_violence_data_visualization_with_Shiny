library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(leaflet)
library(plotly)
library(DT)



#Data: https://github.com/jamesqo/gun-violence-data
#Source: http://www.gunviolencearchive.org/
origindata <- read_csv("./gun_violence_data.csv")

#Select a part of origindata as mydata to work with: See README for filter criteria.
#To create mydata.RData, the helper functions below are used.
tempdf <- readRDS("./mydata.RData")
mydata <- origindata %>% filter(incident_id %in% tempdf$incident_id) %>% select(-5,-9,-10,-11,-16,-19,-20,-23,-24,-27,-28,-29)

#Rename some columns
mydata <- rename(mydata,city=city_or_county,id=incident_id)

#Change state and city_or_county columns to be factors
mydata$state <- as.factor(mydata$state)
mydata$city <- as.factor(mydata$city)

#Add year, quarter,month, day columns
mydata$year <- year(mydata$date)
mydata$quarter <- quarter(mydata$date)
mydata$month <- month(mydata$date,label = T)
mydata$year <- as.factor(mydata$year)
mydata$quarter <- as.factor(mydata$quarter)

#Add n_victims = n_killed+n_injured
mydata$n_victims <- mydata$n_killed + mydata$n_injured

#Now mydata is the data we will work with and we save it to the file mydata.rds
saveRDS(mydata,"./mydata.rds")












parsebase=function(s){ #s is a string of format %d::%s
                       #return %s part only
  
  s <- gsub('::',':',s,fixed=T)     # Some entry has only one ":" instead of two
                                    # change them uniformly to ":"
  pos <- regexpr(":",s,fixed=T)[1]
  return(substr(s,pos+1,nchar(s)))
  
}

parsedict = function(s){ #s is a string representing a dictionary of format
                         #0::value||1::value||...
                         #return a vector of just values
  if(is.na(s)){
    return(s)
  }
  
  s<-gsub('||','|',s,fixed=T)    # Some entry has only one "|" instead of two
                                 # change them uniformly to "|"
    
  dictvec <- strsplit(s,split='|',fixed=T)[[1]]
  temp <- sapply(dictvec,parsebase)
  names(temp) <- NULL
  return(temp)
}

parselist = function(s){ #s is a string representing a list of format
                         #list[0]||list[1]||...
                         #return a vector
  if(is.na(s)){
    return(s)
  }
  
  s <- gsub('||','|',s,fixed=T)     # Some entry has only one "|" instead of two
                                    # change them uniformly to "|"
  
  
  return(strsplit(s,split='|',fixed=T)[[1]])

}


mylength = function(vec){
  if(length(vec)==1 & is.na(vec)[1]){
    return(0)
  }else{
    return(length(vec))
  }
}



mydebug1 = function(vec){
  b1 <- any(vec=="Injured, Unharmed, Arrested")
  b2 <- any(vec=="Killed, Unharmed, Arrested")
  b3 <- any(vec=="Killed, Unharmed") | any(vec=="Killed, Arrested")
  b4 <- any(vec=="Killed, Injured") | any(vec=="Injured, Unharmed")
  return(b1|b2|b3|b4)
  
}
mydebug2 = function(vec){
  return(any(vec=="Male, female"))
}