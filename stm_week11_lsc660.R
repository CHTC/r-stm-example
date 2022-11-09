## LSC660, Demonstration of How to Implement Structural Topic Model on Social Media Posts for CHTC Purpose
## Kaiping Chen
## November 14, 2022
## Dataset we used: Canvas -> Module -> Week 9 -> "arboretum.csv"

# Step 0: Install packages to working directory
library_list <- c(getwd(), .libPaths())
.libPaths(library_list)

# Step 1: Install the Structural Topic Model Package
#install.packages("stm", repos='http://cran.us.r-project.org')
library("stm")
#install.packages("tm", repos='http://cran.us.r-project.org')
library("tm")

# Step 1: set up your working directory 
# You never need to set the working directory on CHTC
# setwd("~/OneDrive - UW-Madison/teaching/LSC660/week 11/")

# import the dataset (make sure your csv file is exactly the name like below)
data <- read.csv("arboretum.csv")

# Step 2: Preparation for Text Analysis
processed <- textProcessor(data$Description, metadata = data)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

docs <- out$documents
vocab <- out$vocab
meta <- out$meta


# Step 3: Run the function stm to generate the most prevalent 20 topics
InstaPrevFit <- stm(documents = out$documents, vocab = out$vocab,
                       K = 10, prevalence =~ Post_Type, max.em.its = 200,
                       data = out$meta, init.type = "Spectral", seed=6221433)

# plot the keywords for the 10 most prevalent topics
plot(InstaPrevFit, type = "summary", xlim = c(0, 0.5), labeltype = "frex", n = 6) #n=6 means I want to plot 6 keywords under each topic

# print something fun to show up in the CHTC log file
print("I am doing Structural Topic Model on CHTC!")

# export a csv file that stores the likelihood of how each post belongs to each topic
output <- InstaPrevFit$theta

write.csv(output, "documents_topic_prob.csv")
