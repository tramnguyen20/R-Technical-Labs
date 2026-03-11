library(quantmod)
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(moments)

# 1. Tải dữ liệu và chuyển đổi
getSymbols("AAPL", from = "2020-01-01", to = "2024-12-31", auto.assign = TRUE)
aapl_df <- data.frame(Date = index(AAPL), coredata(AAPL))
names(aapl_df) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted")

# 2. Tính daily_return và cum_return
aapl_df$daily_return <- c(NA, diff(log(aapl_df$Close)))
aapl_df$daily_return[is.na(aapl_df$daily_return)] <- 0
daily_return
aapl_df$cum_return <- cumsum(aapl_df$daily_return)
cum_return

# 3. Thống kê mô tả
summary_stats <- aapl_df %>%
  summarise(
    mean = mean(daily_return, na.rm = TRUE),
    sd = sd(daily_return, na.rm = TRUE),
    min = min(daily_return, na.rm = TRUE),
    max = max(daily_return, na.rm = TRUE),
    skew = skewness(daily_return, na.rm = TRUE),
    kurt = kurtosis(daily_return, na.rm = TRUE)
  )
summary_stats

# 4. Phân loại biến động
sd_value <- sd(aapl_df$daily_return, na.rm = TRUE)
classify_volatility <- function(x, threshold_low, threshold_high) {
  if (x < threshold_low) {
    return("Low")
  } else if (x > threshold_high) {
    return("High")
  } else {
    return("Medium")
  }
}
aapl_df$volatility <- sapply(aapl_df$daily_return, classify_volatility, 
                             threshold_low = -sd_value, 
                             threshold_high = sd_value)
aapl_df

# 5. Sắp xếp dữ liệu
# Theo lãi suất
sorted_by_return <- aapl_df[order(aapl_df$daily_return), ]
sorted_by_return
# Theo thời gian
sorted_by_date <- aapl_df[order(aapl_df$Date, decreasing = TRUE), ]
sorted_by_date

# 6. Gộp dữ liệu AAPL và SPY, tính beta
getSymbols(c("AAPL", "SPY"), from = "2020-01-01", to = "2024-12-31", auto.assign = TRUE)
# Tạo data.frame cho AAPL và SPY
aapl_data <- data.frame(Date = index(AAPL), coredata(AAPL[, "AAPL.Close"]))
spy_data  <- data.frame(Date = index(SPY), coredata(SPY[, "SPY.Close"]))
colnames(aapl_data)[2] <- "AAPL_Close"
colnames(spy_data)[2]  <- "SPY_Close"
#Gộp dữ liệu theo ngày
df <- merge(aapl_data, spy_data, by = "Date")
df
#Tính log return
df <- df %>%
  arrange(Date) %>%
  mutate(
    AAPL_return = log(AAPL_Close) - log(lag(AAPL_Close)),
    SPY_return = log(SPY_Close) - log(lag(SPY_Close))
  )
# Loại bỏ NA để tránh lỗi khi tính toán
df_clean <- na.omit(df)
# Tính hệ số beta
cov_ab <- cov(df_clean$AAPL_return, df_clean$SPY_return)
var_b  <- var(df_clean$SPY_return)
beta   <- cov_ab / var_b
beta

# 7. Tổng hợp dữ liệu theo tháng
aapl_df$Month <- floor_date(aapl_df$Date, "month")
monthly_summary <- aapl_df %>%
  group_by(Month) %>%
  summarise(mean_return = mean(daily_return, na.rm = TRUE))
monthly_summary

# 8. Chuyển đổi sang dạng long
long_data <- aapl_df %>%
  pivot_longer(cols = c(Close), 
               names_to = "Variable",
               values_to = "Value")
long_data

# 9. Vẽ biểu đồ
# Biểu đồ giá đống cửa
plot1 <- ggplot(aapl_df, aes(x = Date, y = Close)) +
  geom_line(color = "blue") +
  labs(title = "Giá đóng cửa của AAPL", x = "Ngày", y = "Giá đóng cửa")
# Biểu đồ daily return
plot2 <- ggplot(aapl_df, aes(x = Date, y = daily_return)) +
  geom_line(color = "red") +
  labs(title = "Daily Return của AAPL", x = "Ngày", y = "Daily Return")

# 10. Xuất file CSV
output_data <- merge(aapl_df[, c("Date", "daily_return", "volatility")], 
                     monthly_summary, by.x = "Date", by.y = "Month", all.x = TRUE)
write.csv(output_data, "AAPL_analysis.csv", row.names = FALSE, fileEncoding = "UTF-8")
