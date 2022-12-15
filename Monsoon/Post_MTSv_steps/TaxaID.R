library(readr)
library(dplyr)
#library(tidyverse)
library(stringr)

args <- commandArgs(TRUE)
input1 <- args[1]
dir <- getwd()
#print(input1)
#print(dir)
where <- as.character(paste0(dir, "/", input1))
#print(where)

setwd(where)

#setwd("C:/Users/tomos/OneDrive/PhD/Paleo-dung/aDNA_results_backup/results/elephant/ele_a_50bp_5e_eff/results") # Remove this in final script
#getwd() # Remove in final script
sheets <- list.files(pattern = "analysis.csv$")
no_sheets <- length(sheets)
unique_sig_thresh <- 200
taxaID_list <- ""
taxaID_list2 <- ""

for(i in 1:no_sheets){
  #i <- 1
  sheet <- sheets[i]
  print(paste0("Sheet number: ",i, ": ", sheet))
  csv_total <- read.csv(sheet)
  csv_filtered <- csv_total %>% 
    filter(Level == 'species' | Level == 'genus') %>%
    arrange(desc(Significant), desc(Unique_Signature_Hits)) %>%
    filter(Signature_Hits > unique_sig_thresh) %>%
    filter(Scientific_Name != 'Homo' & Scientific_Name != 'Homo sapiens' & Scientific_Name != 'synthetic construct' & Scientific_Name != "uncultured bacterium")
  csv_filtered <- csv_filtered %>% arrange(desc(csv_filtered$Significant, csv_filtered$Unique_Signature_Hits))
  
  csv_filtered_sp <- csv_filtered %>%
    filter(Level == "species") # & Significant == "True")
  
  csv_filtered_g <- csv_filtered %>%
    filter(Level == "genus") # & Significant == "True")
  
  no_sp_rows <- length(csv_filtered_sp[,1])
  for(j in 1:no_sp_rows){
    taxa_ID <- csv_filtered_sp$TaxID[j]
    #print(paste0(j, ") TaxID is: ", taxa_ID))
    #taxaID_list <- paste0(taxaID_list, taxa_ID, ", ")
    taxaID_list <- append(taxaID_list, taxa_ID)
  }
  #print(taxaID_list)
  #no_g_rows <- length(csv_filtered_g[,1])
  #for(k in 1:no_g_rows){
    #taxa_ID <- csv_filtered_g$TaxID[k]
    #print(paste0(k, ") TaxID is: ", taxa_ID))
    #taxaID_list <- paste0(taxaID_list, taxa_ID, ", ")
    #taxaID_list <- append(taxaID_list, taxa_ID)
  #}
  
}

#taxaID_list <- as.array(taxaID_list)
no_taxa <- length(taxaID_list)
taxaID_list <- taxaID_list[2:no_taxa]
#print(length(taxaID_list))
taxaID_list <- unique(taxaID_list)
taxaID_list <- taxaID_list[!is.na(taxaID_list)]
no_taxa <- length(taxaID_list)
#print(length(taxaID_list))
#taxaID_list <- sort(taxaID_list, decreasing = FALSE)

for(m in 1:no_taxa){
  taxa_ID2 <- taxaID_list[m]
  taxaID_list2 <- paste0(taxaID_list2, taxa_ID2, ",")
}
taxaID_list2 <- substr(taxaID_list2, 0, nchar(taxaID_list2)-1)
taxaID_list2 <- paste0('[', taxaID_list2, ']')
print(taxaID_list2)

fileContent <- file("taxaID_list.txt")
writeLines(taxaID_list2, fileContent)
close(fileContent)

fileContent <- file("taxaID_list2.txt")
writeLines(taxaID_list,fileContent)
close(fileContent)
