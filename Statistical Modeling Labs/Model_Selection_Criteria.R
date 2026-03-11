data(mtcars)
head(mtcars)

# Chạy mô hình hồi quy tuyến Lnh
model4 <- lm(mpg ~ wt + hp + disp, data = mtcars)
summary(model4)

library(car)
model2 <- lm(mpg ~ wt + hp + qsec + drat, data = mtcars)
#Kiểm định VIF cho mô hình 2
vif(model2)

library(lmtest)
# Dữ liệu mẫu
data(mtcars)
# Mô hình 1: đơn giản
model1 <- lm(mpg ~ wt + hp, data = mtcars)
vif(model1)
# Mô hình 2: phức tạp hơn
model2 <- lm(mpg ~ wt + hp + qsec + drat, data = mtcars)
vif(model2)
# Mô hình 3: đầy đủ
model3 <- lm(mpg ~ ., data = mtcars)
vif(model3)
# So sánh AIC và BIC giữa các mô hình
AIC(model1, model2, model3)
BIC(model1, model2, model3)



