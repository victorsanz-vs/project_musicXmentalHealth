# ultima_mod: 27/05/2024
# nombre: Victor Sanz Arevalo
# centro: Campus Digital FP
# dataset: mxmh_survey_results.csv
# n_script: 04

# Cargar los paquetes necesarios:
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("caTools")) install.packages("caTools")
if (!require("recommenderlab")) install.packages("recommenderlab")
if (!require("here")) install.packages("here")

library(tidyverse)
library(caTools)
library(recommenderlab)
library(here)

# Cargar los datos:
music_mxmh <- read.csv(here("D:/githubDrop/project_musicXmentalHealth", 
	"mxmh_survey_results.csv"))

# Convertir las variables categoricas a factores:
music_mxmh <- music_mxmh %>%
	mutate(across(where(is.character), as.factor))

#################################################################################

# Lista con los nombres de las columnas:
column_names <- c("Age", "Primary.streaming.service", "Fav.genre")

# Bucle for para imprimir si hay NAs en cada columna:
for (column in column_names) {
	print(paste("?NAs", column, ":", anyNA(music_mxmh[[column]])))
}

# Reemplazar los valores nulos en la columna 'Age' con la media:
music_mxmh$Age <- replace_na(music_mxmh$Age, round(mean(music_mxmh$Age, na.rm = TRUE)))

#################################################################################

# Convertir factores a numericos (si es necesario 
# para algunos modelos):
music_mxmh <- music_mxmh %>%
	mutate(across(where(is.factor), as.numeric))

# Normalizar variables numericas (opcional, dependiendo
# del algoritmo):
normalize <- function(x) {
	return((x - min(x)) / (max(x) - min(x)))
}

music_mxmh <- music_mxmh %>%
	mutate(across(where(is.numeric), normalize))

#################################################################################

# Dividir los datos en conjuntos de entrenamiento y prueba:
set.seed(123)
split <- sample.split(music_mxmh$Primary.streaming.service, SplitRatio = 0.8)
train_data <- subset(music_mxmh, split == TRUE)
test_data <- subset(music_mxmh, split == FALSE)

#################################################################################

# Renombrar las columnas para que sean mas legibles:
names(train_data)[names(train_data) == "Age"] <- "user"
names(train_data)[names(train_data) == "Primary.streaming.service"] <- "product"
names(train_data)[names(train_data) == "Fav.genre"] <- "rating"

# Convertir el dataset a una matriz de usuarios-productos (participante-genero 
# favorito):
rating_matrix <- as(train_data %>% 
    select(user, product, rating), 
    "realRatingMatrix")

# rlang::last_trace()

# Crear un modelo de filtrado colaborativo basado en usuarios (participantes):
recommender_model <- Recommender(rating_matrix, method = "UBCF")

# Visualizar el modelo:
print(recommender_model)

#################################################################################

# Evaluacion del modelo. Crear un conjunto de datos de validacion:
validation_data <- evaluationScheme(reating_matrix, method = "split", 
	train = 0.8, k = 1)

# Entrenar el modelo y hacer predicciones:
predicted_ratings <- predict(recommender_model, validation_data)

# Calcular el error cuadratico medio:


