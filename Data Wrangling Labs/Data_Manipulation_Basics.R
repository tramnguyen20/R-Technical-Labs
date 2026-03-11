age <- c(18,25,28,30,35,45,50,75)
ID <- c(1:8)
edu <- c(10,11,9,7,12,16,18,16)
income <- c(3,5,4,3,8,10,12,11)
exp <- c(1,0,5,3,7,9,5,3)
mydata <- data.frame(age,ID,edu,income,exp)
mydata
mydata$sum <- mydata$edu + mydata$exp
mydata
mydata_new <- subset(mydata, select = -sum)
mydata_new
install.packages("dplyr")
library(dplyr)
mydata1 <- mydata %>% select(-sum)
mydata1
if(!require(reshape)) install.packages("reshape")
mydata <- rename(mydata, c(age_new="age"))
names(mydata) <- c("age_new","ID_new","edu_new", "income_new", "exp_sum", "sum") 

df <- data.frame(a = 1:3, b = 4:6, c = 7:9)
library(reshape)
df <- rename(df, c(b = "doanh_thu"))
names(df)

ID <- c(1,2,3)
score <- c(85,90,79)

grade <- ifelse(score >= 90, "Xuất sắc", 
                ifelse(score >= 80, "Giỏi", "Khá"))

grade
data.frame(ID,score,grade)

returns <- c(0.01, -0.005, 0.003, 0.007)
cum_return <- 1
for (r in returns) {cum_return <- cum_return * (1+r)}
cum_return - 1 
metric <- "cumret"
result <- switch(metric,
                 mean = mean(returns),
                 sd = sd(returns),
                 var = var(returns),
                 cumret = prod(1 + returns) - 1,
                 "Chỉ số không hợp lệ!")
result


