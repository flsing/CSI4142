# first 2 questions
income = c(17546.00, 30085.10, 16575.40, 20375.40, 50576.30, 37869.60, 8877.07, 24946.60, 2500304.30, 24212.10, 59803.90, 26658.80, 15735.80, 55204.70)
income = sort(income)
median(income)
age = c(48,40,51,23,57,57,22,58,37,54,66,52,44,66)
age = sort(age)
median(age)

# outlier detection
customer <- read.csv("Customer.csv", stringsAsFactors = FALSE, sep = ",")
customer$income = as.numeric(gsub("[\\$,]", "", customer$income))
customer$mortgage = as.numeric(gsub("[\\$,]", "", customer$mortgage))
print(customer)
plot(customer$income, na.rm = TRUE)
boxplot(customer$income)
hist(customer$income)
plot(customer$income, customer$mortgage, na.rm = TRUE)

outlier_values <- boxplot.stats(customer$income)$out  # outlier values.
boxplot(customer$income, main="Income", boxwex=0.1)
mtext(paste("Outliers: ", paste(outlier_values, collapse=", ")), cex=0.9)
plot(customer$income, main="Income", boxwex=0.1)
mtext(paste("Outliers: ", paste(outlier_values, collapse=", ")), cex=0.9)
