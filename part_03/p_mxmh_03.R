# fecha: 27-05-2024
# nombre: Victor Sanz Arevalo
# centro: Campus Digital FP
# dataset: mxmh_survey_results.csv

# Cargar los paquetes necesarios:
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

if (!require("entropy")) install.packages("entropy")
library(entropy)

# Mostrar documentacion de cada paquete:
# help(package = "tidyverse")
# help(package = "entropy")

music_mxmh <- read.csv(file.choose(), header = TRUE, sep = ",")

summary(music_mxmh)

categorical_vars <- music_mxmh %>% select_if(is.factor)
entropy_values <- sapply(categorical_vars, function(col) entropy.empirical(table(col)))

print(entropy_values)
