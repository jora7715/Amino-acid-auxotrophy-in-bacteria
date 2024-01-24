library(tidyverse)

path.bacteria <- "/data/mhoffert/genomes/GTDB_r207/protein_faa_reps/bacteria/"

path.archaea <- "/data/mhoffert/genomes/GTDB_r207/protein_faa_reps/archaea/"

files.bacteria <- list.files(path.bacteria, pattern = ".faa") %>%
  as.data.frame() %>%
  rename(path = 1) %>%
  mutate(file = "file:",
         name = path) %>%
  select(file, path, name) %>%
  mutate(across(name, ~str_remove(., "_[^_]+$"))) %>%
  mutate(across(name, ~str_c(":", ., sep = ""))) %>%
  mutate(across(path, ~str_c(path.bacteria, ., sep = ""))) %>%
  unite(col = combined, sep = "")

files.archaea <- list.files(path.archaea, pattern = ".faa") %>%
  as.data.frame() %>%
  rename(path = 1) %>%
  mutate(file = "file:",
         name = path) %>%
  select(file, path, name) %>%
  mutate(across(name, ~str_remove(., "_[^_]+$"))) %>%
  mutate(across(name, ~str_c(":", ., sep = ""))) %>%
  mutate(across(path, ~str_c(path.archaea, ., sep = ""))) %>%
  unite(col = combined, sep = "")

path_out <- getwd()

#test <- files.bacteria %>%
#  slice(1:100)

#data.table::fwrite(test, file = paste0(path_out, "/", "file.test.txt"), col.names = FALSE)

data.table::fwrite(files.bacteria, file = paste0(path_out, "/", "file.bacteria.txt"), col.names = FALSE)
data.table::fwrite(files.archaea, file = paste0(path_out, "/", "file.archaea.txt"), col.names = FALSE)
