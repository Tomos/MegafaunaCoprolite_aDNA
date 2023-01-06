#### Variables for use on Monsoon; need commenting out when using this script on local machine:
args <- commandArgs(TRUE)
dirs <- args[1]
no_reads <- args[2]

#### Temporary variables to run locally on machine; comment out to use on Monsoon:
#no_reads <- 1000000
#library(utils)
#setwd("C:/Users/top23/OneDrive/PhD/Paleo-dung/Rscripts")
#### 

list_file <- read.table("prelim_list.txt", header = FALSE, sep = "")

#### Generates a random proportions and counts:
#x <- runif(length(list_file[,1]), min = 0, max = 1)
#x <- as.data.frame(x)
#x <- sweep(x, 2, colSums(x), '/')
#no_reads <- as.numeric(no_reads)
#y <- ceiling(x * no_reads)

#### Generate exponentially decreasing distribution of proportions and counts: 
x <- seq(from = 1, to = (length(list_file[,1])), by = 1)
x <- dexp(x, rate = 0.015)
x <- as.data.frame(x)
x_sum <- sum(x)
scaling_factor <- 1/x_sum
x$x <- x$x * scaling_factor
no_reads <- as.numeric(no_reads)
y <- ceiling(x * no_reads)

#### Generate linearly decreasing read proportions and counts:
#x1 <- data.frame(prop=numeric())
#step_size <- 1/length(list_file[,1])
#for(k in 1:length(list_file[,1])){
  #x1 <- rbind(x1, (1 - (step_size*k)))
#}
#x1 <- sweep(x1, 2, colSums(x1), '/')
#y1 <- ceiling(x1*no_reads + 1)


#### Create the files:
list_file <- cbind(list_file, x)
write.table(list_file, file = 'list', quote = FALSE, sep = '\t', col.names = FALSE, row.names = FALSE)

list_file2 <- cbind(list_file, y)
write.table(list_file2, file = 'list2.txt', quote = FALSE, sep = '\t', col.names = FALSE, row.names = FALSE)

#plot(x$x)
