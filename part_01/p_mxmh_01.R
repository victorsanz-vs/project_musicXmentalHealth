# ultima_mod: 27/05/2024
# nombre: Victor Sanz Arevalo
# centro: Campus Digital FP
# dataset: mxmh_survey_results.csv
# n_script: 01

# Lista de paquetes requeridos:
paquetes <- c("visdat", "tidyverse", "ggplot2", 
    "janitor", "lubridate", "here")

# Verificar si los paquetes estan instalados. Si no, instalarlos:
paquetes <- paquetes[!paquetes %in% installed.packages()[,"Package"]]
if(length(paquetes)) install.packages(paquetes)

# Cargar los paquetes:
lapply(paquetes, require, character.only = TRUE)

# print(paste("Directorio de trabajo actual:", getwd()))

# Leer el archivo de datos:
music_mxmh <- read_csv(here("D:/githubDrop/project_musicXmentalHealth", "mxmh_survey_results.csv"))
str(music_mxmh)

# Variables:
names(music_mxmh)

print(paste("Numero de valores duplicados del dataset:", 
    sum(duplicated(music_mxmh))))

print("Valores faltantes:")
vis_miss(music_mxmh)

# Comprobar si todos los participantes tienen permiso para el estudio:
unique(music_mxmh$Permissions)

# Eliminar 'BPM' y 'Permissions' debido a la ausencia de datos:
music_mxmh <- music_mxmh %>% select(-BPM, -Permissions)

# Reemplazar espacios por guiones bajos:
names(music_mxmh) <- str_replace_all(names(music_mxmh), c(" " = "_")) 

# Renombrar las columnas 'Frequency_[]' para un acceso mas sencillo:
colnames(music_mxmh)[colnames(music_mxmh) %in% 
	c("Frequency_[Classical]", "Frequency_[Country]", "Frequency_[EDM]", "Frequency_[Folk]", 
	"Frequency_[Gospel]", "Frequency_[Hip_hop]", "Frequency_[Jazz]", "Frequency_[K_pop]",
	"Frequency_[Latin]", "Frequency_[Lofi]", "Frequency_[Metal]", "Frequency_[Pop]", 
	"Frequency_[R&B]", "Frequency_[Rap]", "Frequency_[Rock]", "Frequency_[Video_game_music]")] = 
	c("Clasica", "Country", "Electronica", "Folk", "Gospel", "Hip_hop", "Jazz", "K_pop", "Latina", "Lo-fi",
	"Metal", "Pop", "R&B", "Rap", "Rock", "Musica_videojuegos")