rm(list=ls())
setwd("C:/Users/Lindsey/Desktop/CPLN675_Land_Use_Modeling_Desktop/Midterm/RScripts")

install.packages("rmarkdown")
install.packages("knitr")
install.packages("caret")
install.packages("pscl")
install.packages("plotROC")
install.packages("pROC")
install.packages("kableExtra")

```{r setup, include=FALSE,message = FALSE,cache=TRUE}
knitr::opts_chunk$set(echo = TRUE)
options(scipen=999)
library(knitr)
```

```{r libraries, warning = FALSE, message = FALSE}
library(caret)
library(pscl)
library(plotROC)
library(pROC)
library(sf)
library(tidyverse)
library(knitr)
library(kableExtra)
library(tigris)
library(viridis)
library(ggplot2)
```

```{r mapTheme, echo=TRUE}
mapTheme <- theme(plot.title =element_text(size=12),
                  plot.subtitle = element_text(size=8),
                  plot.caption = element_text(size = 6),
                  axis.line=element_blank(),
                  axis.text.x=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks=element_blank(),
                  axis.title.x=element_blank(),
                  axis.title.y=element_blank(),
                  panel.background=element_blank(),
                  panel.border=element_blank(),
                  panel.grid.major=element_line(colour = 'transparent'),
                  panel.grid.minor=element_blank(),
                  legend.direction = "vertical", 
                  legend.position = "right",
                  plot.margin = margin(1, 1, 1, 1, 'cm'),
                  legend.key.height = unit(1, "cm"), legend.key.width = unit(0.2, "cm"))

plotTheme <- theme(
  plot.title =element_text(size=12),
  plot.subtitle = element_text(size=8),
  plot.caption = element_text(size = 6),
  axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
  axis.text.y = element_text(size = 10),
  axis.title.y = element_text(size = 10),
  # Set the entire chart region to blank
  panel.background=element_blank(),
  plot.background=element_blank(),
  #panel.border=element_rect(colour="#F0F0F0"),
  # Format the grid
  panel.grid.major=element_line(colour="#D0D0D0",size=.75),
  axis.ticks=element_blank())
```

###Loading our two cities' boundaries and putting them in web mercator projections (CRS 3395):

calgary_boundary <- st_read("C:/Users/Lindsey/Desktop/CPLN675_Land_Use_Modeling_Desktop/Midterm/Derived Files/CalgaryWebMercator.shp")

calgary_boundary <- calgary_boundary %>% 
  st_transform(crs = 3395)
  
boise_boundary <- st_read("C:/Users/Lindsey/Desktop/CPLN675_Land_Use_Modeling_Desktop/Midterm/Derived Files/BoiseBoundary.shp")

boise_boundary <- boise_boundary %>% 
  st_transform(crs = 3395)

###Creating fishnets for the two cities.
```{r create_fishnets_calgary, warning = FALSE, message = FALSE, results = "hide"}

calgary_fishnet <- st_make_grid(calgary_boundary,
                                cellsize = 500,
                                square = FALSE) %>% 
  .[calgary_boundary] %>% 
  st_sf() %>% 
  mutate(uniqueID = rownames(.))

ggplot()+
  geom_sf(data = calgary_fishnet,
          fill = "pink")+
  geom_sf(data = calgary_boundary, 
          color = "black", fill = "transparent") +
  mapTheme


boise_fishnet <- st_make_grid(boise_boundary,
                                cellsize = 500,
                                square = FALSE) %>% 
  .[boise_boundary] %>% 
  st_sf() %>% 
  mutate(uniqueID = rownames(.))

ggplot()+
  geom_sf(data = boise_fishnet,
          fill = "lightblue")+
  geom_sf(data = boise_boundary, 
          color = "black", fill = "transparent") +
  mapTheme

```
#st_write(calgary_fishnet, "C:/Users/Lindsey/Desktop/CPLN675_Land_Use_Modeling_Desktop/Midterm/Derived Files/calgary_fishnet.shp", geometry = TRUE)
#st_write(boise_fishnet, "C:/Users/Lindsey/Desktop/CPLN675_Land_Use_Modeling_Desktop/Midterm/Derived Files/boise_fishnet.shp", geometry = TRUE)


