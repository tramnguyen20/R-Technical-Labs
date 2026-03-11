library(quantmod)
library(dplyr)
library(ggplot2)
library(tidyr)

# Phần A – Chuẩn bị dữ liệu

# 1. Tải dữ liệu giá cổ phiếu của 2 mã chứng khoán trong khoảng thời gian từ 01/01/2022 đến nay.
# Lấy 2 mã AAPL mà MSFT
symbols <- c("AAPL", "MSFT")  
getSymbols(symbols, from = "2022-01-01", to = Sys.Date(), auto.assign = TRUE)
# Chuyển thành dạng data frame
aapl_df <- data.frame(Date = index(AAPL), coredata(AAPL[, "AAPL.Close"]))
msft_df <- data.frame(Date = index(MSFT), coredata(MSFT[, "MSFT.Close"]))
# Đổi tên cột để dễ phân biệt
colnames(aapl_df) <- c("Date", "Close_AAPL")
colnames(msft_df) <- c("Date", "Close_MSFT")
head(aapl_df)
head(msft_df)

# 2. Tính log returns hàng ngày cho từng mã.
# Gộp 2 bộ data theo Date
stock_data <- merge(aapl_df, msft_df, by = "Date")
# Tính log returns hàng ngày
stock_data <- stock_data %>%
  mutate(
    log_return_AAPL = c(NA, diff(log(Close_AAPL))),
    log_return_MSFT = c(NA, diff(log(Close_MSFT)))
  ) %>%
  na.omit()  
head(stock_data)

# Phần B – Trực quan hóa cơ bản

# 3. Vẽ biểu đồ đường thể hiện giá đóng cửa theo thời gian.
close_plot <- ggplot(stock_data, aes(x = Date)) +
  geom_line(aes(y = Close_AAPL, color = "AAPL")) +
  geom_line(aes(y = Close_MSFT, color = "MSFT")) +
  labs(
    title = "Biểu đồ đường thể hiện giá đóng cửa theo thời gian",
    x = "Date",
    y = "Closing Price")
close_plot

# 4. Vẽ histogram và density plot cho log returns của mỗi mã.
# Mã AAPL
logAAPL_plot <- ggplot(stock_data, aes(x = log_return_AAPL)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "blue", alpha = 0.7) +
  geom_density(color = "darkblue") +
  labs(
    title = "Biểu đồ histogram và density plot cho log returns của AAPL",
    x = "Log Returns",
    y = "Density")
logAAPL_plot
# Mã MSFT
logMSFT_plot <- ggplot(stock_data, aes(x = log_return_MSFT)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "green", alpha = 0.7) +
  geom_density(color = "darkgreen") +
  labs(
    title = "Biểu đồ histogram và density plot cho log returns của MSFT",
    x = "Log Returns",
    y = "Density")
logMSFT_plot

# 5. Vẽ boxplot để so sánh log returns giữa hai mã chứng khoán.
# Chuyển đổi thành long data
long_data <- stock_data %>%
  pivot_longer(cols = starts_with("log_return"), names_to = "Stock", values_to = "Log_Returns")
# Vẽ biểu đồ
Boxplot <- ggplot(long_data, aes(x = Stock, y = Log_Returns, fill = Stock)) +
  geom_boxplot() +
  labs(
    title = "Boxplot để so sánh log returns giữa hai mã chứng khoán",
    x = "Stock",
    y = "Log Returns") +
  scale_fill_manual(values = c("log_return_AAPL" = "blue", "log_return_MSFT" = "green"))
Boxplot