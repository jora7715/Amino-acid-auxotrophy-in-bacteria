library(tidyverse)

domain <- "archaea" # change domain here

# Import all aa.sum.rules files
files <- data.table::fread(paste0("output/", domain, "_all_aa.sum.rules.txt"), sep = "\t") %>%
  rename(orgId = 1,	
         gdb = 2,	
         gid = 3,
         pathway = 4,
         rule = 5,
         nHi = 6,
         nMed = 7,
         nLo = 8,
         score = 9,
         expandedPath = 10,
         path = 11,
         path2 = 12) %>%
  select(-orgId, -gdb)

# Import all orgs with genome identifiers
orgs <- data.table::fread(paste0("output/", domain, "_all_orgs.txt"), sep = "\t") %>%
  rename(orgId = 1,
         gdb = 2,
         gid = 3,
         genomeName = 4,
         nProteins = 5) %>%
  select(-orgId, -gdb)

# Merge files
df <- orgs %>%
  left_join(files, by = "gid")

# Filter rule = all
df.auxo <- df %>%
  filter(rule == "all")

# write output
path_out <- getwd()

data.table::fwrite(df, sep = ",", row.names = FALSE, col.names = TRUE, quote = FALSE,
                   paste0(path_out, "/", format(Sys.time(), "%Y-%m-%d_"), domain, "_auxotrophies_total.txt"))
data.table::fwrite(df.auxo, sep = ",", row.names = FALSE, col.names = TRUE, quote = FALSE,
                   paste0(path_out, "/", format(Sys.time(), "%Y-%m-%d_"), domain, "_auxotrophies_subset_all.txt"))

