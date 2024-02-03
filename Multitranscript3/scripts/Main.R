library(shiny)
library(pheatmap)
library(readxl)
library(shinyjs)
library(ggplot2)
library(igraph)
library(dplyr)
library(reshape2)
library(bipartite)
library(ggsankey)

# Load data from an Excel file "All_data.xlsx" into the "virus" data frame
virus <- as.data.frame(read_excel("data/All_data.xlsx"))

# Set row names of the "virus" data frame to the values in the "...1" column
row.names(virus) <- virus$...1

# Remove the first column, which is now set as row names
virus <- virus[-1]

# Replace NA values with 0 in the "virus" data frame
virus[is.na(virus)] = 0

# Load data from an Excel file "data_annotation.xlsx" into the "data_annotation" data frame
data_annotation <- read_excel("data/data_annotation.xlsx")

# Create the "sample_group" data frame using data from "data_annotation"
sample_group <- as.data.frame(cbind(
  Study = data_annotation$Study,
  CellType = data_annotation$CellType,
  VirusGenome = data_annotation$VirusGenome,
  VirusType = data_annotation$VirusType
))


# Set row names of the "sample_group" data frame to match column names of the "virus" data frame
row.names(sample_group) <- colnames(virus)

# Load data from an Excel file "Pathways.xlsx" into the "Pathways" data frame
Pathways <- as.data.frame(read_excel("data/Pathways.xlsx"))