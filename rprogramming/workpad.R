#workpad

#rankhistory +++++#########

outcomesDF <- readDataFile(colsList)
colsList <- makeColumnsList()
outcomesDF <- readDataFile(colsList)
rankVector <- order( outcomesDF[outcomesDF$State == "TX", 11], outcomesDF[outcomesDF$State == "TX", 2])
rankVector <- rev(rankVector)
newdataframe <- na.omit(newdataframe[rankVector,])
newdataframe <-data.frame(name = outcomesDF[outcomesDF$State == "TX", 2], HEARTFAIL = outcomesDF[outcomesDF$State =="TX", 17])
newdataframe <- na.omit(newdataframe[rankVector,])
nrow(newdataframe)
head(newdataframe)
tail(newdataframe)
rankVector <- order(newdataframe$name, newdataframe$HEARTFAIL)
newdataframe[rankVector,]
head(rbind(outcomesDF[outcomesDF$State == "TX", 2], outcomesDF[outcomesDF$State=="TX", 17])[rankVector], 12)
rankVector <- order( outcomesDF[outcomesDF$State == "TX", 17], outcomesDF[outcomesDF$State == "TX", 2], decreasing = TRUE)
newdataframe[rankVector,]
## newdataframe <- na.omit(newdataframe[rankVector,])
newdataframe <- na.omit(newdataframe[rankVector,])
newdataframe
nrows(newdataframe)
nrow(newdataframe)
newdataframe$rank <- nrow(newdataframe):1
newdataframe
newrankvector <- order(newdataframe$rank, newdataframe$HEARTFAIL , newdataframe$name)
newdataframe[newrankvector,]
## Results!
savehistory("~/Projects/Rstudio/rprogramming/Assignment3/14SepSessionAssignment3.2")

head(newdataframe[newrankvector,])
head(newdataframe[newrankvector,],12)
head(newdataframe[newrankvector,],1)
tail(newdataframe[newrankvector,], 1)






#rankhistory++++++++++++############
datavect <-NULL ; newdata <- NULL ; for (i in id) {newdata <- ((read.csv(paste0(directory,"/",lpad(i,3),".csv")))[pollutant])[,pollutant] ; datavect <-c(datavect, newdata) } ; mean(datavect, na.rm = T)

####

comp <- function(directory, id = 1:332)
 {  
  for(i in id)
    {  
    filename <- paste0(directory,"/",files[i])
    comp_file <- read.csv(filename)
    sulf_na <- is.na(comp_file["sulfate"])
    sulf_val <- (comp_file["sulfate"])[!sulf_na]
    nite_na <- is.na(comp_file["nitrate"])
    nite_val <- (comp_file["sulfate"])[!nite_na]
    if(length(sulf_val)<=length(nite_val)) outstring<-c(i, length(sulf_val)) else outstring<- c(i, length(nite_val))
    print(outstring)
    }
  }

try<-function()
  {
  numcorr <- NULL
  sensors <- NULL
  df <- NULL
  for(i in id)
    {
    df <- na.omit(read.csv(paste0(directory,"/",fileslist[i]))) 
    if((dim(df)[1])>=150)
      {
      numcorr<-c(numcorr, cor(df[,"sulfate"],df[,"nitrate"]))
      sensors <- c(sensors, dim(df)[1])
      }
    else 
      {
      print("doh")
      }
  } 
  print(head(numcorr)) 
  print(head(sensors))
}

is_state <- function(statevar = character())
  {
  if (checkState(statevar)) 
    {
    return(paste0(statevar, " is a state in the list"))
    } 
  else 
    {
    return(paste0(statevar, " is not a state in the list"))
    }
  }

checkState <- function(stringVar = character()) 
  {
  if ( length(which(unique(outcome$State) == stringVar )) >= 1 ) 
    { 
    TRUE 
    } 
  else 
    {
    FALSE
    }
  }