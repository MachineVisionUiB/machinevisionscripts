## A Dataset Documenting Representations of Machine Vision Technologies 
## in Artworks, Games and Narratives
##
# Scripts for handling the data in R. Scripts written by Jill Walker Rettberg.
# March 18, 2022.
# 

# The dataset can be found at: --------------------------------------------

# Rettberg, Jill Walker; Kronman, Linda; Solberg, Ragnhild; Gunderson, Marianne; 
# Bjørklund, Stein Magne; Stokkedal, Linn Heidi; Jacob, Kurdin; Markham, Annette, 
# 2022, "A Dataset Documenting Representations of Machine Vision Technologies 
# in Artworks, Games and Narratives", 
# https://doi.org/10.18710/2G0XKN, DataverseNO.

# Set working directory and load tidyverse---------------------------------------------------

# These scripts assume that the data files are in the a subdirectory
# of your working directory called data. 
# 
#getwd()
#setwd()

# These scripts use the Tidyverse package. If you haven't already installed that, 
# remove the # from the following line and run it. 
# 
#install.packages("tidyverse")
library(tidyverse)

# Import creativeworks ----------------------------------------------------


# Importing each file with factors etc

CreativeWorks <- read_csv("data/creativeworks.csv",
                          locale = locale(encoding = "UTF-8"),
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


# Import characters.csv ---------------------------------------------------

Characters <- read_csv("data/characters.csv",
                       locale = locale(encoding = "UTF-8"),
        col_types = cols(
                CharacterID = col_integer(),
                Character = col_character(),
                Species = col_factor(levels = c(
                        "Animal", "Cyborg", "Fictional", 
                        "Human", "Machine", "Unknown")),
                Gender = col_factor(levels = c(
                        "Female","Male","Non-binary or Other", "Trans Woman",
                        "Unknown")),
                RaceOrEthnicity = col_factor(levels = c(
                        "Asian", "Black", "Person of Colour", "White", 
                        "Immigrant", "Indigenous", "Complex", "Unknown")),
                Age = col_factor(levels = c(
                        "Child", "Young Adult", "Adult", "Elderly", 
                        "Unknown"),
                        ordered = TRUE),
                Sexuality = col_factor(levels = c(
                        "Homosexual", "Heterosexual", "Bi-sexual", "Other",
                        "Unknown")),
                IsGroup = col_logical(),
                IsCustomizable = col_logical()
        )
)


# Simplify character traits -----------------------------------------------

# Change some of the variables to simplify for analysis. This example merges 
# black, person of colour, indigenous, immigrant and complex into one category:
# PoC, and merges machines and cyborgs into a value called Robot. Since our
# categories for race and ethnicity do not follow the specific demographic 
# categories of a country, and there are very few cases of some of the values 
# like indigenous), for some analyses combining categories will be better. 
# The code can easily be adapted to combine or rename categories differently.
# 
# Format here is:
# mutate(New_column_name = recode(Old_column_name, "New value" = "Old value"))
# 
# Could remove customizable characters with this line:
#         filter(IsCustomizable == FALSE) %>% 
# 
# Convert "Unknown" values to NA. 
# 
# Select relevant columns.

Characters <- Orig_Characters %>% 
        na_if("Unknown") %>% 
        select(Character, Species, Gender, Sexuality, 
               RaceOrEthnicity, Age) %>% 
        mutate(RaceOrEthnicity = recode(RaceOrEthnicity,  
                                        "Asian" = "Asian", 
                                        "Black" = "PoC", 
                                        "White" = "White", 
                                        "Person of Colour" = "PoC",
                                        "Indigenous" = "PoC",
                                        "Immigrant" = "PoC",
                                        "Complex"  = "PoC")) %>% 
        mutate(Species = recode(Species,
                                "Human" = "Human",
                                "Machine" = "Robot",
                                "Cyborg" = "Robot",
                                "Fictional" = "Fictional",
                                "Animal" = "Animal"))


# Load situations.csv -----------------------------------------------------

Situations <- read_csv("data/situations.csv",
                       locale = locale(encoding = "UTF-8"),
                       col_types = cols(
                                SituationID = col_integer(),
                                Situation = col_character(), 
                                Genre = col_character(),
                                Character = col_character(),
                                Entity = col_character(),
                                Technology = col_character(),
                                Verb = col_character()
                                )
                       )


# Merge characters.csv with situations.csv to see character actions -------

# Make a new dataframe called Verbs that shows all characters with their traits 
# (species, age etc), what situations they are in and what actions they take
# when interacting with machine vision.

Verbs <- merge(Situations, Characters, by = "Character", all = TRUE)


# Contingency tables  -----------------------------------------------------

# The following scripts transform Verbs into contingency tables where each row 
# contains one verb and the number of times it is used in each of the genres (art, 
# games, narratives) and who or what uses it. A new column has also been added 
# which is TRUE if the verb is active (ends in -ing) and FALSE if it is passive
# (ends in -ed).
#
Tech_verbs_contingency <- Verbs %>% 
        filter(!is.na(Technology)) %>% 
        select(Verb, Genre, Technology) %>% 
        pivot_longer(cols= -Verb,
                     names_to = "variable", 
                     values_to = "value") %>% 
        group_by(Verb, value) %>%
        summarise(n=n()) %>% 
        pivot_wider(names_from = "value", values_from = "n") %>% 
        mutate_all(~replace(., is.na(.), 0)) %>%  # convert NA to 0 since it's count 
        mutate(target = str_detect(Verb, "ing"), .after = Verb) %>% # new col target
        relocate(Verb, target, Art, Game, Narrative) #put these cols first


Entity_verbs_contingency <- Verbs %>% 
        filter(!is.na(Entity)) %>% 
        select(Verb, Genre, Entity) %>% 
        pivot_longer(cols= -Verb,
                     names_to = "variable", 
                     values_to = "value") %>% 
        group_by(Verb, value) %>%
        summarise(n=n()) %>% 
        pivot_wider(names_from = "value", values_from = "n") %>% 
        mutate_all(~replace(., is.na(.), 0)) %>%  # convert NA to 0 since it's count 
        mutate(target = str_detect(Verb, "ing"), .after = Verb) %>%  # new col target
        relocate(Verb, target, Art, Game, Narrative)

Character_verbs_contingency <- Verbs %>% 
        filter(!is.na(Character)) %>% 
        select(Verb, Gender, Species, RaceOrEthnicity, Age, Sexuality) %>%
        pivot_longer(cols= -Verb,
                     names_to = "variable", 
                     values_to = "value") %>% 
        group_by(Verb, value) %>%
        summarise(n=n()) %>% 
        pivot_wider(names_from = "value", values_from = "n") %>% 
        mutate_all(~replace(., is.na(.), 0)) %>%  # convert NA to 0 since it's count 
        mutate(target = str_detect(Verb, "ing"), .after = Verb) %>%  # new col target 
        relocate()

write_csv(Tech_verbs_contingency, "data/tech_verbs_contingency.csv")
write_csv(Character_verbs_contingency, "data/character_verbs_contingency.csv")
write_csv(Entity_verbs_contingency, "data/entity_verbs_contingency.csv")

# Make continency table from situations showing verb use-----------------------------------

# Make contingency table SitCounts with count of times each verb is used by 
# a Character, a Technology or an Entity. Then add a column VerbType stating 
# whether Verb is active or passive. 

SitCounts <- Situations %>% 
        mutate(Tech = !is.na(Technology),
               Char = !is.na(Character),
               Ent = !is.na(Entity)) %>% 
        select(Verb, Tech, Char, Ent) %>%
        pivot_longer(-Verb, names_to = "var", values_to = "value") %>% 
        count(Verb, var, wt = value) %>% 
        pivot_wider(Verb, names_from = var, values_from = n) %>% 
        mutate(VerbType = case_when(
                str_detect(Verb, "ing$") ~ "Active",
                str_detect(Verb, "ed$") ~ "Passive"))

# Transform worksinfo.csv to a wide format table --------------------------

# If you find it easier to work with a wide table, with a row for each work
# and columns for WorkID, Work_WikidataID, WorkTitle, Genre, Year, Creator, 
# Country, URL and IsSciFI, you can use this code to generate it.
# Because many works have multiple creators, multiple countries and 
# even mulitple URLs, the code creates a new column for each creator.

worksinfo <- read_csv("data/worksinfo.csv") %>% 
        arrange(WorkID, Variable) %>% 
        group_by(WorkID, Variable) %>% 
        mutate(dupe = n()>1,
               dup_id = row_number(),
               Variable = as.character(Variable),
               Variable = case_when(
                       dup_id == 1 & Variable == "Creator" ~ "Creator1",
                       dup_id == 2 & Variable == "Creator" ~ "Creator2",
                       dup_id == 3 & Variable == "Creator" ~ "Creator3",
                       dup_id == 4 & Variable == "Creator" ~ "Creator4",
                       dup_id == 5 & Variable == "Creator" ~ "Creator5",
                       dup_id == 6 & Variable == "Creator" ~ "Creator6",
                       dup_id == 7 & Variable == "Creator" ~ "Creator7",
                       dup_id == 8 & Variable == "Creator" ~ "Creator8",
                       dup_id == 1 & Variable == "Country" ~ "Country1",
                       dup_id == 2 & Variable == "Country" ~ "Country2",
                       dup_id == 3 & Variable == "Country" ~ "Country3",
                       dup_id == 4 & Variable == "Country" ~ "Country4",
                       dup_id == 5 & Variable == "Country" ~ "Country5",
                       dup_id == 1 & Variable == "URL" ~ "URL1",
                       dup_id == 2 & Variable == "URL" ~ "URL2",
                       dup_id == 3 & Variable == "URL" ~ "URL3",
                       TRUE ~ Variable)) %>% 
        select(-c(dupe, dup_id)) %>% 
        pivot_wider(names_from = Variable, 
                    values_from = Value) %>% 
        select(WorkID, Work_WikidataID, WorkTitle, Genre, Year, Creator1, 
               Country1, URL1, URL2, URL3, Country2, Country3, Country4, 
               Country5, Creator2, Creator3, Creator4, Creator5, Creator6, 
               Creator7, Creator8, IsSciFi) %>% 
        ungroup()
