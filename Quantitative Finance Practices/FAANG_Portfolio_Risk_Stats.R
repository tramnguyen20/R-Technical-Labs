library(quantmod)
library(dplyr)
library(psych)
library(moments)
library(purrr)

# Phần 1: Tiền xử lý dữ liệu
# Lấy giá đóng cửa hàng ngày của 3 mã cổ phiếu.
symbols <- c("META", "AMZN", "TSLA")
getSymbols(symbols, from = "2022-01-01", to = Sys.Date(), auto.assign = TRUE)
# Chuyển đổi thành data frame và lấy giá đóng cửa
meta <- data.frame(Date = index(META), coredata(META[, "META.Close"]))
amzn <- data.frame(Date = index(AMZN), coredata(AMZN[, "AMZN.Close"]))
tsla <- data.frame(Date = index(TSLA), coredata(TSLA[, "TSLA.Close"]))
# Tính lợi suất logarit hàng ngày (log return) cho từng mã.
meta <- meta %>%
  mutate(log_return_META = c(NA, diff(log(META.Close)))) %>%
  na.omit()  # Loại bỏ NA

amzn <- amzn %>%
  mutate(log_return_AMZN = c(NA, diff(log(AMZN.Close)))) %>%
  na.omit()

tsla <- tsla %>%
  mutate(log_return_TSLA = c(NA, diff(log(TSLA.Close)))) %>%
  na.omit()
# Kết hợp tất cả vào một data.frame.
stock_data <- reduce(list(meta, amzn, tsla), full_join, by = "Date") %>%
  na.omit()  # Loại bỏ các hàng chứa NA do không có dữ liệu đầy đủ ở cùng ngày
head(stock_data)

# Phần 2: Thống kê mô tả
# Áp dụng các hàm summary(), mean(), sd(), range(), quantile() cho từng chuỗi lợi suất.
basic_stats <- stock_data %>%
  reframe(
    mean_META = mean(log_return_META),
    sd_META = sd(log_return_META),
    range_META = paste(range(log_return_META), collapse = " to "),
    mean_AMZN = mean(log_return_AMZN),
    sd_AMZN = sd(log_return_AMZN),
    range_AMZN = paste(range(log_return_AMZN), collapse = " to "),
    mean_TSLA = mean(log_return_TSLA),
    sd_TSLA = sd(log_return_TSLA),
    range_TSLA = paste(range(log_return_TSLA), collapse = " to ")
  )
basic_stats
# Tính hệ số biến thiên (CV), độ lệch, độ nhọn cho mỗi chuỗi.
advanced_stats <- stock_data %>%
  summarise(
    cv_META = sd(log_return_META) / mean(log_return_META),
    skew_META = skewness(log_return_META),
    kurt_META = kurtosis(log_return_META),
    cv_AMZN = sd(log_return_AMZN) / mean(log_return_AMZN),
    skew_AMZN = skewness(log_return_AMZN),
    kurt_AMZN = kurtosis(log_return_AMZN),
    cv_TSLA = sd(log_return_TSLA) / mean(log_return_TSLA),
    skew_TSLA = skewness(log_return_TSLA),
    kurt_TSLA = kurtosis(log_return_TSLA)
  )
advanced_stats
# Tính ma trận hệ số tương quan giữa 3 chuỗi lợi suất.
cor_matrix <- stock_data %>%
  select(starts_with("log_return")) %>%
  cor()
cor_matrix
# Sử dụng psych::describe() hoặc pastecs::stat.desc() để trình bày phân tích chi tiết.
describe_stats <- stock_data %>%
  select(starts_with("log_return")) %>%
  psych::describe()
describe_stats