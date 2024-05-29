# ultima_mod: 27/05/2024
# nombre: Victor Sanz Arevalo
# centro: Campus Digital FP
# dataset: mxmh_survey_results.csv
# n_script: 04

dim(music_mxmh)

# Pasos:
#	1. Carga y limpieza de datos.
#	2. Transformacion de datos (codificar vars. categoricas 
#		y normalizar vars. numericas).
#	3. Division de datos (entrenamiento y prueba).
#	4. Modelo de recomendacion (algoritmos de filtrado 
#		colaborativo o basado en contenido).
#	5. Evaluacion del modelo.
#	6. Generacion de recomendaciones.

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

# Vista previa de los datos:
str(music_mxmh)

# Convertir las variables categoricas a factores:
music_mxmh <- music_mxmh %>%
	mutate(across(where(is.character), as.factor))

# Verificar los cambios:
str(music_mxmh)

#################################################################################

# Lista con los nombres de las columnas:
column_names <- c("Age", "Primary.streaming.service", "Fav.genre")

# Bucle for para imprimir si hay NA en cada columna:
for (column in column_names) {
	print(paste("?NAs", column, ":", anyNA(music_mxmh[[column]])))
}

# head(music_mxmh$Age, n = 10)

#################################################################################

# Contar el numero total de valores nulos en la columna Age:
num_nulos_age <- sum(is.na(music_mxmh$Age))

# Imprimir el numero total de valores nulos:
print(num_nulos_age)

# Calcular la media de la columna Age, excluyendo los valores nulos:
mean_age <- mean(music_mxmh$Age, na.rm = TRUE)

# Reemplazar los valores nulos en la columna Age con la media:
music_mxmh$Age <- replace_na(music_mxmh$Age, mean_age)

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

# Dividir los datos en conjuntos de entrenamiento y prueba
set.seed(123)
split <- sample.split(music_mxmh$Primary.streaming.service, SplitRatio = 0.8)
train_data <- subset(music_mxmh, split == TRUE)
test_data <- subset(music_mxmh, split == FALSE)

#################################################################################

# Renombrar las columnas para que sean más legibles
names(train_data)[names(train_data) == "Age"] <- "user"
names(train_data)[names(train_data) == "Primary.streaming.service"] <- "product"
names(train_data)[names(train_data) == "Fav.genre"] <- "rating"

# Convertir el dataset a una matriz de usuarios-productos
rating_matrix <- as(train_data %>% 
    select(user, product, rating), 
    "realRatingMatrix")

# rlang::last_trace()

# Crear un modelo de filtrado colaborativo basado en usuarios:
recommender_model <- Recommender(rating_matrix, method = "UBCF")

# Visualizar el modelo:
print(recommender_model)

#################################################################################
