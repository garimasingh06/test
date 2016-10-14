# Importing Hyperion data and forming RGB image
library(sp)
library(raster)
library(rgdal)
library(caret)
library(lattice)
library(ggplot2)
library(maptools)
library(rgeos)
feb<- brick(x="E:/jnu_project/satellite_data/New_Delhi/Hyperion/final_data/final_hy_data")
names(feb)<-paste("feb",1:126,sep=".")
plotRGB(feb, r=32,g=22,b=12, scale=500, stretch="lin")

#loading the training samples from shapefile
trainData<-shapefile("E:/jnu_project/satellite_data/New_Delhi/Hyperion/classify/features.shp")

# read shapefile
roi_loc<-readOGR("E:/jnu_project/satellite_data/New_Delhi/Hyperion/classify","features")
class(roi_loc)
featureUTM<-spTransform(roi_loc,CRS(proj4string(feb)))
crs(roi_loc)
extent(roi_loc)
roi_loc
roi_loc@data
summary(roi_loc)

#plot NIR and RED band in February
library(ggplot2)



#plot shapefile
plotRGB(feb, r=32,g=22,b=12, scale=500, stretch="lin")
plot(featureUTM, col="red",add=TRUE, lwd=3,main="roi_loc Plot")



#extract the surface reflectance
calib <-extract(feb, featureUTM, df=TRUE)

#Random Forest Classification
library(randomForest)
#calibrate model
model<- randomForest(lc<-"feb.12+feb.22+feb.32", data = calib)