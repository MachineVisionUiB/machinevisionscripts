# Scripts for analysing data from "A Dataset Documenting Representations of Machine Vision Technologies in Artworks, Games and Narratives"
by Jill Walker Rettberg

[![DOI](https://zenodo.org/badge/487622885.svg)](https://zenodo.org/badge/latestdoi/487622885)

This repository gathers scripts for analysing data collected in the database [Machine Vision in Art, Games and Narratives](https://machine-vision.no) as part of the [ERC-funded project Machine Vision in Everyday Life: Playful Interactions with Visual Technologies in Digital Art, Games, Narratives and Social Media](https://www.uib.no/en/machinevision/).

![Graphical abstract describing dataset](images/machine_vision_dataset_graphical_abstract_550x200_web.png)

As of 1 May 2022, the following files are included:
- machinevisionscripts.R
- machinevision_plots_by_year_country.R

See below for descriptions of each file.

## How to download the dataset
The data that the scripts work with can be downloaded from the DataverseNO repository:

Rettberg, Jill Walker; Kronman, Linda; Solberg, Ragnhild; Gunderson, Marianne; Bjørklund, Stein Magne; Stokkedal, Linn Heidi; de Seta, Gabriele; Jacob, Kurdin; Markham, Annette, 2022, "A Dataset Documenting Representations of Machine Vision Technologies in Artworks, Games and Narratives", [https://doi.org/10.18710/2G0XKN](https://doi.org/10.18710/2G0XKN), DataverseNO, V1

## What the dataset is about
The dataset captures cultural attitudes towards machine vision technologies as they are expressed in art, games and narratives. It includes records of 500 creative works (including 77 digital games, 191 digital artworks and 236 movies, novels and other narratives) that use or represent machine vision technologies like facial recognition, deepfakes, and augmented reality.

## Descriptions of each file

### Contents of machinevisionscripts.R
This is the basic set of scripts included with the dataset. It   includes code to do the following:
- Import creativeworks.csv
- Import characters.csv
- Simplify character traits by combining values
- Import situations.csv
- Merge characters.csv with situations.csv to see character traits combined with actions (verbs)
- Create contingency tables with a row for each action and the number of times it is used in each of the genres (art, games, narratives), and which kind of agent performs the action. Separate tables are created for technologies, characters and entities, and a column is created to indicate whether an action is passive (ends in -ed) or active (ends in -ing).
- Create a contingency table showing number of times an action is performed by a character, a technology or an entity with a column indicating whether the action is active or passive.
- Transform worksinfo.csv into a wide table with a row for each work and columns for WorkID, Work_WikidataID, WorkTitle, Genre, Year, Creator, Country, URL and IsSciFi. Because many works have multiple creators, multiple countries and even mulitple URLs, the code creates a new column for each creator

### Contents of machinevision_plots_by_year_country.R
- Import creativeworks.csv
- Plot a line graph showing works by year of publication and genre
- Plot the geographic distribution of works 
-- by continent
-- by European country
-- by the UK vs rest of Europe
- Distribution of all works by year of publication

## Funding acknowledgement
This project has received funding from the European Research Council (ERC) under the European Union’s Horizon 2020 research and innovation programme (grant agreement No 771800).
