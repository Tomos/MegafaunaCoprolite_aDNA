args <- commandArgs(TRUE)
selection_no <- args[1]
#selection_no <- 100
firmicute_sp <- readRDS("firmicutes.rds")
firmicute_sp_df <- firmicute_sp$Firmicutes
colnames(firmicute_sp_df) <- c("NCBI_taxanomic_ID", "species_name", "rank")
no_firmicutes <- length(firmicute_sp_df[,1])
x <- runif(selection_no, min = 1, max = no_firmicutes)
x <- floor(x)
selected_firmicutes <- firmicute_sp_df[x,1]
#cat(selected_firmicutes)
fileContent <- file("firmicute_list.txt")
writeLines(selected_firmicutes, fileContent)
close(fileContent)
