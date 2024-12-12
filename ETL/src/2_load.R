library(tidyverse)
library(stringi)
library(glue)
setwd("ETL")

df <- read_csv("output/votaciones_raw.csv") 

df <- df |> 
    select(-asiento, -asentimiento) |> 
    mutate( 
        sesion = as.integer(sesion), 
        numeroVotacion = as.integer(numeroVotacion),
        fecha = dmy(fecha),
        grupo = case_when(
            grupo == "GS" ~ "Grupo Parlamentario socialista", 
            grupo == "GP" ~ "Grupo Parlamentario Popular", 
            grupo == "GCUP-EC-GC" ~ "Grupo Parlamentario de Unidas Podemos", 
            grupo == "GPlu" ~ "Grupo Parlamentario Plural", 
            grupo == "GMx" ~ "Grupo Parlamentario Mixto", 
            grupo == "GCs" ~ "Grupo Parlamentario Ciudadanos", 
            grupo == "GEH Bildu" ~ "Grupo Parlamentario Euskal Herria Bildu", 
            grupo == "GR" ~ "Grupo Parlamentario Republicano",
            grupo == "GV (EAJ-PNV)" ~ "Grupo Parlamentario Vasco", 
            grupo == "GVOX" ~ "Grupo Parlamentario VOX", 
            grupo == "GCUP-EC-EM" ~ "Grupo Parlamentario de Unidas Podemos", 
            grupo == "GP-EC-EM" ~ "Grupo Parlamentario de Unidas Podemos", 
            grupo == "GSUMAR" ~ "Grupo Parlamentario Sumar", 
            grupo == "GJxCAT" ~ "Grupo Parlamentario Junts per Catalunya", 
            grupo == "GER" ~ "Grupo Parlamentario Republicano", 
            grupo == "GC-D" ~ "Grupo Parlamentario Catalán de Convergència", 
            grupo == "GC-CiU" ~ "Grupo Parlamentario Catalán de Convergència", 
            grupo == "GIP" ~ "Grupo Parlamentario Izquierda Plural", 
            grupo == "GUPyD" ~ "Grupo Parlamentario Unión Progreso y Democracia"), 
        legislatura = case_when(
            fecha >= as.Date("2011-12-13") & fecha <= as.Date("2016-01-12") ~ "Legislatura X",
            fecha >= as.Date("2016-01-13") & fecha <= as.Date("2016-07-18") ~ "Legislatura XI",
            fecha >= as.Date("2016-07-19") & fecha <= as.Date("2019-05-20") ~ "Legislatura XII",
            fecha >= as.Date("2019-05-21") & fecha <= as.Date("2019-12-02") ~ "Legislatura XIII",
            fecha >= as.Date("2019-12-03") & fecha <= as.Date("2023-08-16") ~ "Legislatura XIV",
            fecha >= as.Date("2023-08-17") ~ "Legislatura XV")

    ) |> 
    separate(diputado, into = c("apellidos", "nombre"), sep = ", ") |> 
    mutate(diputado = glue("{nombre}, {apellidos}"))


# Que ha votado 