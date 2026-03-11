# A: Nhập và xuất dữ liệu

# 1. Nhập dữ liệu từ CSV
  # Tạo dữ liệu cho bộ data
Product <- c("Product A", "Product B", "Product C", "Product D", "Product E")
Price <- c(10, 20, 15, 30, 25)
Quantity <- c(100, 150, 200, 120, 180)
  # Tạo data frame
sales_data <- data.frame(Product,Price,Quantity)
print(sales_data)
  # Ghi dữ liệu ra file CSV
write.csv(sales_data, "sales.csv", row.names = FALSE)
  # Đọc dữ liệu từ file CSV
sales_csv <- read.csv("sales.csv")
print(sales_csv)

# 2. Nhập dữ liệu từ Excel
  # Tạo dữ liệu cho bộ data
CustomerID <- c(1, 2, 3, 4, 5)
Name <- c("John", "Alice", "Bob", "Diana", "Eve")
Country <- c("USA", "UK", "Canada", "Australia", "Germany")
  # Tạo data frame
customer_data <- data.frame(CustomerID,Name,Country)
print(customer_data)
  # Ghi dữ liệu ra file Excel
library(writexl)
write_xlsx(customer_data, "customer.xlsx")
  # Đọc dữ liệu từ file Excel
library(readxl)
customer_excel <- read_excel("customer.xlsx")
print(customer_excel)

# 3. Xuất bộ sales ra file CSV mới với tên sales_updated.csv
write.csv(sales_csv, "sales_updated.csv", row.names = FALSE)

# B: Xử lý dữ liệu bị thiếu

# 1. Tạo dữ liệu có giá trị NA
EmployeeID <- c(1001, 1002, 1003, 1004, 1005)
Department <- c("HR", "IT", "Sales", NA, "Marketing")
Salary <- c(50000, 60000, NA, 70000, NA)
finance_data <- data.frame(EmployeeID,Department,Salary)
print(finance_data)

# 2. Kiểm tra dữ liệu thiếu
  # Kiểm tra các giá trị NA trong dữ liệu
na_info <- is.na(finance_data)
print(na_info)
  # Số lượng giá trị NA trong từng cột
na_count <- colSums(is.na(finance_data))
print(na_count)

# 3. Xử lý dữ liệu thiếu
  # TH1: Xóa các dòng chứa NA
finance_data_no_na <- na.omit(finance_data)
print(finance_data_no_na)
  #TH2: Thay thế NA bằng giá trị trung bình
finance_data_no_na <- finance_data
finance_data_no_na$Salary[is.na(finance_data_no_na$Salary)] <- mean(finance_data_no_na$Salary, na.rm = TRUE)
print(finance_data_no_na)

# 4. Kiểm tra dòng hoàn chỉnh
completed_rows <- complete.cases(finance_data)
print(completed_rows)
print(finance_data[completed_rows, ])




