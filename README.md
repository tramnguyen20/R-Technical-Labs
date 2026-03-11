# R Programming Technical Labs: Data Science & Quantitative Finance

## Overview
Kho lưu trữ này hệ thống hóa các kỹ năng xử lý dữ liệu và mô hình hóa tài chính bằng ngôn ngữ R. Các nội dung được chia thành 3 mảng chính: Tiền xử lý dữ liệu, Phân tích định lượng và Mô hình hóa thống kê.

## Directory Structure

### 1. Data Wrangling & EDA
Tập trung vào quy trình làm sạch và chuẩn hóa dữ liệu đầu vào:
- **Data_Manipulation_Basics.R**: Các thao tác cơ bản với `dplyr` và xử lý logic bảng tính.
- **Data_Import_Export_Excel_CSV.R**: Kỹ thuật kết nối dữ liệu đa nguồn (Excel, CSV) và xử lý dữ liệu khuyết thiếu (Missing values).
- **EDA_Corporate_Dataset.R**: Phân tích khám phá cấu trúc dữ liệu doanh nghiệp quy mô lớn.

### 2. Quantitative Finance
Định lượng hiệu suất và rủi ro thị trường:
- **Stock_Return_and_Beta_Estimation.R**: Tính toán lợi suất logarit, lợi suất tích lũy và đo lường rủi ro hệ thống (Beta).
- **FAANG_Portfolio_Risk_Stats.R**: Phân tích các moment thống kê bậc cao (Skewness, Kurtosis) và hệ số biến thiên (CV).
- **Market_Risk_Rolling_Beta.R**: Ước lượng rủi ro động qua thời gian bằng Rolling Windows và tác động của cấu trúc vốn.

### 3. Statistical Modeling
Xây dựng và tối ưu hóa các mô hình dự báo:
- **Logistic_Regression_Stock_Direction.R**: Ứng dụng mô hình phân loại nhị phân để dự báo xác suất biến động giá cổ phiếu.
- **Model_Selection_Criteria.R**: Quy trình lựa chọn mô hình tối ưu dựa trên AIC, BIC và kiểm soát đa cộng tuyến (VIF).
- **Statistical_Viz_with_Ggplot2.R**: Trực quan hóa dữ liệu theo chuẩn báo cáo phân tích rủi ro.

## Technical Stack
- **Data Handling**: `tidyverse` (dplyr, tidyr), `zoo`, `lubridate`
- **Quantitative Finance**: `quantmod`, `PerformanceAnalytics`, `moments`
- **Modeling**: `car`, `lmtest`, `pscl`, `pROC`, `margins`

---
