args <- commandArgs(TRUE)
selection_no <- args[1]
###
#selection_no <- 100
#base_dir <- paste0("C:/Users/tomos/OneDrive/PhD/Paleo-dung/Rscripts/")
###
firmicute_sp <- readRDS("firmicutes.rds")
firmicute_sp_df <- firmicute_sp$Firmicutes
firmicute_sp_df$phylum <- "Firmicutes"
colnames(firmicute_sp_df) <- c("NCBI_taxanomic_ID", "species_name", "rank", "phylum")

bacteroidetes_sp <- readRDS("bacteroidetes.rds")
bacteroidetes_sp_df <- bacteroidetes_sp$bacteroidetes
bacteroidetes_sp_df$phylum <- "Bacteroidetes"
colnames(bacteroidetes_sp_df) <- c("NCBI_taxanomic_ID", "species_name", "rank", "phylum")

firmicutes_bacteroidetes_sp_df <- rbind(firmicute_sp_df, bacteroidetes_sp_df)
no_bacteria <- length(firmicutes_bacteroidetes_sp_df[,1])
x <- runif(selection_no, min = 1, max = no_bacteria)
x <- floor(x)
selected_bacteria <- cbind(firmicutes_bacteroidetes_sp_df[x,1], firmicutes_bacteroidetes_sp_df[x,4])
cat(selected_bacteria[,1])
###
#fileContent <- file(paste0(base_dir, "firmicutes_bacteroidetes_list.txt"))
###
fileContent <- file("firmicutes_bacteroidetes_list.txt")
writeLines(selected_bacteria[,1], fileContent)
close(fileContent)
