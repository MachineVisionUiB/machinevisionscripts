# R scripts to generate figures for the paper "Representations of Machine Vision 
# Technologies in Artworks, Games and Narratives: A Dataset", submitted to the 
# journal Data in Brief in March 2022. 
# 
# The code was written by Jill Walker Rettberg.
# 
# 

# setup------------------------------------------------

library(tidyverse)
library(ggthemes)

# Import creativeworks ----------------------------------------------------

CreativeWorks <- read_csv("data/creativeworks.csv",
                          col_types = cols(
                                  WorkID = col_integer(),
                                  WorkTitle = col_character(),
                                  Sentiment = col_factor(levels = c(
                                          "Exciting", "Flawed", "Helpful", "Neutral", "Wondrous",
                                          "Hostile","Oppressive", "Alien", "Creepy", "Subversive", 
                                          "Dangerous",  "Intrusive", "Empowering", "Protective", 
                                          "Intimate", "Misleading", "Fun", "Overwhelming", 
                                          "Prosocial", "Disgusting")),
                                  Topic = col_factor(levels = c(
                                          "Nudity", "Social Media", "Romantic relationship", "Climate Change", 
                                          "Dystopian", "Horror", "Robots/androids", "Surveillance", "Automation", 
                                          "City", "Labour", "War", "Identity", "AI", "Animals", "Consciousness", 
                                          "Nature", "Companionship", "Competition", "Playful", "Family", 
                                          "Free will", "Physical violence", "Crime", "Hacking", "Conflict", 
                                          "Empathy", "Utopian", "Race", "Sex", "Cyborgs", "Inequality", 
                                          "Economy", "Grief", "Autonomous vehicles", "Gender")),
                                  TechRef= col_factor(levels = c(
                                          "Holograms", "Augmented reality", "Ocular implant", 
                                          "Emotion recognition", "Surveillance cameras", "AI", 
                                          "Virtual reality", "Motion tracking", "Body scans", 
                                          "Drones", "MicroscopeOrTelescope", "Biometrics", 
                                          "Image generation", "Facial recognition", 
                                          "Object recognition",  "3D scans", "Machine learning", 
                                          "Filtering", "Deepfake", "Camera",  "Cameraphone", 
                                          "Interactive panoramas", "Non-Visible Spectrum", "UGV",
                                          "Webcams", "Satellite images")),
                                  TechUsed= col_factor(levels = c(
                                          "Holograms", "Augmented reality", "Ocular implant", 
                                          "Emotion recognition", "Surveillance cameras", "AI", 
                                          "Virtual reality", "Motion tracking", "Body scans", 
                                          "Drones", "MicroscopeOrTelescope", "Biometrics", 
                                          "Image generation", "Facial recognition", 
                                          "Object recognition",  "3D scans", "Machine learning", 
                                          "Filtering", "Deepfake", "Camera",  "Cameraphone", 
                                          "Interactive panoramas", "Non-Visible Spectrum", "UGV",
                                          "Webcams", "Satellite images"))))


# FIGURE 1: Line graph showing genres by year -------------------------------------

CreativeWorks %>% 
        select(WorkID, Genre, Year) %>% 
        distinct() %>% 
        filter(Year >2000) %>% 
        ggplot(aes(x=Year, fill=Genre, colour = Genre)) +
        geom_line(stat="count") +
        scale_colour_tableau() +
        labs(fill="", 
             #title ="Year of publication or first release for creative works in the machine vision dataset",
             y = "", 
             x = "") +
        theme_minimal()

# FIGURE 2: Plot geographic distribution --------------------------------------------

# See https://cran.r-project.org/web/packages/countrycode/countrycode.pdf
# for description of this package's groupings of countries.
# setting destination = "region" means
# sorting countries into 7 regions as defined by the World Bank
# development Indicators.
# 
library(countrycode)

CreativeWorks$Continent <- countrycode(
        sourcevar = CreativeWorks$Country, 
        origin = "country.name",
        destination = "region")

CreativeWorks$Continent = factor(CreativeWorks$Continent, 
                                 levels = c("North America", "Europe & Central Asia", 
                                            "East Asia & Pacific", "Latin America & Caribbean", 
                                            "Sub-Saharan Africa","Middle East & North Africa", 
                                             "South Asia"))

# Grouping regions with few cases, then plotting.
# 
CreativeWorks %>% 
select(WorkID, Genre, Continent) %>% 
        distinct() %>% 
        select(Genre, Continent) %>% 
        mutate(Continent = recode(Continent,
                                  "Middle East & North Africa" = "Middle East & Africa",
                                  "Sub-Saharan Africa"  = "Middle East & Africa",
                                  "East Asia & Pacific" = "East & South Asia & Pacific",
                                  "South Asia" = "East & South Asia & Pacific")) %>% 
        ggplot(aes(x=fct_infreq(Continent), fill = Genre)) +
        geom_bar() +
        geom_text(stat = "count", 
                  aes(label =..count..), 
                  position = position_stack(vjust = 0.5),
                  size=3,
                  colour="white") +
        scale_fill_tableau() +
        labs( 
                #title ="Geographic distribution of creative works in the machine vision dataset",
                #subtitle = "Note that some works are affiliated with several countries.",
                y = "Number of works", 
                x = "") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle=45, vjust=1, hjust = 1)) +
        facet_wrap(~Genre, scales = "free_x")


# Stacked barchart of geographic distribution by continent ----------------

CreativeWorks %>% 
        select(WorkID, Genre, Continent) %>% 
        distinct() %>% 
        select(Genre, Continent) %>% 
        mutate(Continent = recode(Continent,
               "Middle East & North Africa" = "Middle East & Africa",
               "Sub-Saharan Africa"  = "Middle East & Africa",
               "East Asia & Pacific" = "East & South Asia & Pacific",
               "South Asia" = "East & South Asia & Pacific")) %>% 
        pivot_longer(-Continent) %>% 
        ggplot(aes(x=Continent, fill=value)) +
        geom_bar() +
        geom_text(stat = "count", 
                  aes(label =..count..), 
                  position = position_stack(vjust = 0.5),
                  size=4,
                  colour="white") +
        scale_fill_tableau() +
        labs(fill="", 
             title ="Geographic distribution of creative works in the machine vision dataset",
             subtitle = "Note that some works are affiliated with several countries.",
             y = "", 
             x = "") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle=45, vjust=1, hjust = 1)) 


# Distribution by country in Europe ---------------------------------------

# Set levels for Country so we can sort them by frequency
# using fct_infreq() in ggplot().
levels(CreativeWorks$Country) = factor(unique(CreativeWorks$Country))
                                
# Plot barchart for Europe and Central Asia
CreativeWorks %>% 
        select(WorkID, Genre, Continent, Country) %>% 
        distinct() %>% 
        filter(Continent == "Europe & Central Asia") %>% 
        select(Genre, Country) %>% 
        pivot_longer(-Country) %>% 
        ggplot(aes(x=fct_infreq(Country), fill=value)) +
        geom_bar() +
        geom_text(stat = "count", 
                  aes(label =..count..), 
                  position = position_stack(vjust = 0.5),
                  size=3,
                  colour="white") +
        scale_fill_tableau() +
        labs(fill="", 
             title ="European and Central Asian works in the Machine Vision dataset",
             subtitle = "Note that some works are affiliated with several countries.",
             y = "", 
             x = "") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle=45, vjust=1, hjust = 1)) 


# UK vs everything else ---------------------------------------------------

CreativeWorks$Region <- countrycode(
        sourcevar = CreativeWorks$Country, 
        origin = "country.name",
        destination = "un.regionsub.name")

CreativeWorks %>% 
        select(WorkID, Genre, Continent, Region, Country) %>% 
        distinct() %>% 
        filter(Continent == "Europe & Central Asia" & Country != "Kazakhstan") %>% 
        mutate(Region1 = recode(Country,
                               "United Kingdom" = "UK & Ireland",
                               "Ireland" = "UK & Ireland",
                               "Russia" = "Russia",
                               .default = Region)) %>% 
        select(Genre, Region1) %>% 
        pivot_longer(-Region1) %>% 
        ggplot(aes(x=fct_infreq(Region1), fill=value)) +
        geom_bar() +
        geom_text(stat = "count", 
                  aes(label =..count..), 
                  position = position_stack(vjust = 0.5),
                  size=3,
                  colour="white") +
        scale_fill_tableau() +
        labs(fill="", 
             title ="European and Central Asian works in the Machine Vision dataset",
             subtitle = "Note that some works are affiliated with several countries.",
             y = "", 
             x = "") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle=45, vjust=1, hjust = 1)) 


view(
        CreativeWorks %>% 
                select(WorkID, Genre, Continent, Region, Country) %>% 
                distinct() %>% 
                filter(Continent == "Europe & Central Asia"))

# Distribution by year ----------------------------------------------------

CreativeWorks %>% 
        select(WorkID, Genre, Year) %>% 
        distinct() %>% 
        filter(Year >2000) %>% 
        ggplot(aes(x=Year, fill=Genre)) +
        geom_bar(aes(x = Year, fill = Genre)) +
        geom_text(stat = "count", 
                  aes(label =..count..), 
                  position = position_stack(vjust = 0.5),
                  size=3,
                  colour="white") +
        scale_fill_tableau() +
        labs(fill="", 
             title ="Year of publication or first release for creative works in the machine vision dataset",
             y = "", 
             x = "") 



