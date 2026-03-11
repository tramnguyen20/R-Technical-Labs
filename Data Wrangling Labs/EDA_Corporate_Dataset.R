# 1. Thông tin bộ dữ liệu
library(readxl)
companies_data <- read_excel("1000_Companies.xlsx")
# Các dòng đầu và các dòng cuối của bộ dữ liệu
head(companies_data)
tail(companies_data)
# Kiểm tra số dòng và số cột
nrow(companies_data)
ncol(companies_data)
#Kiểm tra cấu trúc dữ liệu
str(companies_data)
# Tóm tắt dữ liệu
summary(companies_data)
# Kiểm tra số lượng công ty ở mỗi bang
state_count <- table(companies_data$State)
state_count

