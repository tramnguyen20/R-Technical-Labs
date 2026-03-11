library(quantmod)
library(pROC)
library(ISLR)
library(dplyr)
library(car)
library(margins)
library(ResourceSelection)
library(pscl)

symbols <- c("MSFT")  
getSymbols(symbols, from = "2022-01-01", to = "2023-12-31", auto.assign = TRUE)
price <- Cl(MSFT)
ret <- dailyReturn(price)
vol <- Vo(MSFT)

data <- data.frame(
  date = index(ret),
  return = as.numeric(ret),
  volume = as.numeric(vol)
)
data

data <- data %>% 
  mutate(
    log_volume = log(volume),
    return_lag = lag(return),
    direction = ifelse(return > 0, 1, 0), #biến phụ thuộc nhị phân
    MAS = zoo::rollmean(return, 5, fill = NA, align = "right")
  ) %>%
  na.omit()

# Mô hình hồi quy logistic
logit_model <- glm(direction ~ log_volume + return_lag + MAS,
                   data = data,
                   family = binomial(link = "logit"))
summary(logit_model)

# Kiểm định đa cộng tuyến
vif(logit_model)

# Marginal effects
mfx <- margins(logit_model)
summary(mfx)

# Kiểm định Hosmer-Lemeshow
hoslem.test(logit_model$y, fitted(logit_model), g = 10)

# ROC - AUC
prob <- predict(logit_model, type = "response")
roc_obj <- roc(logit_model$y, prob)
plot(roc_obj, col = "blue", main = "ROC Curve")
auc(roc_obj)

# Kiểm định likelihood Ratio (so sánh model với null model)
null_model <- glm(direction ~ 1, data = data, family = binomial)
anova(null_model, logit_model, test = "Chisq")

# Pseudo R²
pR2(logit_model)