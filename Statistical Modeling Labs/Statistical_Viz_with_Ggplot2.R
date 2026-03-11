library(ggplot2)
# 1.
ggplot(mtcars, aes(x = hp)) +
  geom_histogram(fill = "steelblue", color = "black") +
  labs(title = "Histogram of HP",
       x = "Horsepower",
       y = "Frequency")

# 2. 
ggplot(mtcars, aes(x = mpg, y = hp, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(title = "Scatter Plot with Color by Cylinder",
       x = "Miles per gallon (mpg)",
       y = "Horsepower (hp)")

# 3. 
ggplot(mtcars, aes(x = mpg, y = hp, color = factor(cyl))) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, linetype = "solid", color = "red") +
  labs(title = "Scatter Plot with Regression Line",
       x = "Miles per gallon (mpg)",
       y = "Horsepower (hp)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title = element_text(size = 12),
    legend.position = "top"
  )

# 4.
ggplot(mtcars, aes(x = factor(gear), y = mpg, fill = factor(gear))) +
  geom_boxplot() +
  labs(
    title = "Boxplot of MPG by Gear",
    x = "Number of Gears (gear)",
    y = "Miles Per Gallon (mpg)") +
  scale_fill_manual(values = c("red", "green", "blue")) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title = element_text(size = 12)
  )


# Bài 5
set.seed(123)
n <- 200
credit_data <- data.frame(
  CustomerID = 1:n,
  CreditGrade = sample(c("AAA", "AA", "A", "BBB", "BB"),
                       size = n,
                       replace = TRUE,
                       prob = c(0.1, 0.2, 0.4, 0.2, 0.1)))
credit_data
# Biến thành factor có thứ tự
credit_data$CreditGrade <- factor(credit_data$CreditGrade,
                                   levels = c("AAA", "AA", "A", "BBB", "BB"),
                                   ordered = TRUE)
freq_table <- table(credit_data$CreditGrade) # Tạo bảng tần suất
freq_table
# Theo tỷ lệ
round_table <- round(prop.table(table(credit_data$CreditGrade)) * 100, 1)
round_table
# Biểu đồ minh họa
library(ggplot2)
ggplot(credit_data, aes(x = CreditGrade)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Phân bố xếp hạng tín dụng khách hàng",
       x = "Xếp hạng tín dụng",
       y = "Số lượng") +
  theme_minimal()