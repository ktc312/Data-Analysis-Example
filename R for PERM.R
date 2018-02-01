setwd('/Users/Leo/GitHub/Data-Analysis-Example')

file_list <- list.files(file.path(getwd(), 'data/all_perm'), pattern = "*.csv", full.names = TRUE)
length(file_list)

read_csv_filename <- function(filename){
        ret <- read.csv(filename, header=FALSE, sep=",", na.strings="" )
        ret$Country <- gsub("[+]", " ", strsplit(basename(file.path(filename)), "_", fixed = TRUE)[[1]][1])
        ret
}

original_data <- data.frame(do.call(rbind,lapply(file_list,read_csv_filename)))
colnames(original_data) <- c('id', 'Date', 'Employer', 'City_State', 'Status', 'Job_Title', 'Wage_Offer','Country')
str(original_data)
head(original_data, 3)

# clean the data, column by column

# Drop id
perm_data= subset(original_data, select = -c(id) )

# Parse dates and sort
perm_data$Date <- as.Date(perm_data$Date)
perm_data <- perm_data[order(perm_data$Date, decreasing = TRUE),]

# Employer name
library(plyr)

original_counts <- count(perm_data, 'Employer')
original_counts <- original_counts[order(original_counts$freq,decreasing = TRUE),]
head(original_counts, 10)

cat('--------------------------------\n')
cat('Employer names need to clean up.\n')
cat('--------------------------------\n')

head(original_counts[grepl("Apple ", original_counts[["Employer"]]) | 
                     grepl("Apple,", original_counts[["Employer"]]),], 5)



