library(quantmod)
library(PerformanceAnalytics)
library(dplyr)
library(ggplot2)
library(zoo)

# Phần A: Xử lý dữ liệu
# Lấy dữ liệu cổ phiếu MSFT và chỉ số thị trường S&P 500
getSymbols("MSFT", from = "2015-01-01", to = "2024-12-31")  # Dữ liệu Microsoft
getSymbols("^GSPC", from = "2015-01-01", to = "2024-12-31") # Thị trường

# Biến Return: Tỷ suất sinh lợi hàng tháng của MSFT
stock_prices <- na.omit(Ad(MSFT))  # Giá điều chỉnh của Microsoft
market_prices <- na.omit(Ad(GSPC)) # Giá điều chỉnh của S&P 500
monthly_stock_returns <- monthlyReturn(stock_prices)
monthly_market_returns <- monthlyReturn(market_prices)

# Kết hợp return vào 1 object xts
combined_returns <- merge(monthly_stock_returns, monthly_market_returns)
colnames(combined_returns) <- c("Stock", "Market")

# Biến MarketRisk: Tính beta (rủi ro thị trường)
# Tính rolling beta với cửa sổ 12 tháng
rolling_beta <- rollapply(
  data = combined_returns,
  width = 12,
  FUN = function(x) {
    model <- lm(Stock ~ Market, data = as.data.frame(x))
    coef(model)[2]  # hệ số beta
  },
  by.column = FALSE,
  align = "right"
)

# Cắt dữ liệu để phù hợp với rolling beta
valid_returns <- combined_returns[index(rolling_beta), ]
n_obs <- nrow(valid_returns)

# Biến Size: Quy mô doanh nghiệp (log vốn hóa thị trường, giả định)
set.seed(123)
size <- log(rnorm(length(monthly_stock_returns), mean = 200e9, sd = 30e9))

# Biến Leverage: Đòn bẩy tài chính (giả định)
leverage <- rnorm(length(monthly_stock_returns), mean = 2, sd = 0.5)

# Tập hợp dữ liệu cuối cùng
data <- data.frame(
  Date = index(rolling_beta),
  Return = coredata(valid_returns$Stock),
  MarketRisk = coredata(rolling_beta),
  Size = size,
  Leverage = leverage
)
data <- data %>% rename(Return = Stock)
data

# Kiểm tra NA
sum(is.na(data))

# Xử lý NA (loại bỏ dòng chứa NA)
data <- na.omit(data)

# Kiểm tra NA lại lần nữa sau xử lý
sum(is.na(data))

# Mô tả thống kê
summary(data)

# Trực quan hóa phân phối biến Return
return_plot <- ggplot(data, aes(x = Return)) + 
  geom_histogram(fill = "skyblue", color = "black", bins = 20) +
  theme_minimal() + ggtitle("Phân phối tỷ suất sinh lợi")
return_plot

# Trực quan hóa mối quan hệ giữa các biến độc lập
pairs(data[, -1], main = "Mối liên hệ giữa các biến")

# Phần B: Xây dựng mô hình hồi quy
# Mô hình hồi quy tuyến tính
model1 <- lm(Return ~ MarketRisk + Size + Leverage, data = data)


