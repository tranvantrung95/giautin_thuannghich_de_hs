# 🔒 Hệ Thống Giấu Tin Khôi Phục (RDH - Reversible Data Hiding)

## 📋 Mô Tả Project

Hệ thống **Reversible Data Hiding (RDH)** cho phép giấu dữ liệu bí mật vào ảnh với khả năng **khôi phục hoàn hảo** cả dữ liệu và ảnh gốc. Project được thiết kế với giao diện GUI 3 workflow riêng biệt đảm bảo logic bảo mật đúng chuẩn.

## 🚀 Tính Năng Chính

### 🔐 **3 Workflow Bảo Mật:**
1. **🔒 Tab 1 - GIẤU TIN:** Nhúng dữ liệu bí mật vào ảnh
2. **🔓 Tab 2 - TRÍCH XUẤT:** Lấy dữ liệu bí mật từ ảnh đã giấu tin  
3. **♻️ Tab 3 - KHÔI PHỤC:** Khôi phục ảnh gốc hoàn hảo (100%)

### 🛡️ **Bảo Mật 2 Lớp:**
- **Ảnh đã giấu tin:** Có thể chia sẻ công khai
- **File embed info:** "Chìa khóa" bí mật để trích xuất

### 🧮 **2 Thuật Toán RDH:**
- **Histogram Shifting (HS):** Khuyến nghị - PSNR cao, ít méo ảnh
- **Difference Expansion (DE):** Dự phòng - Capacity lớn

## 📁 Cấu Trúc Project

```
RDH_Project/
├── 🖥️ GUI & Main Files
│   ├── RDH_GUI_3Part.m       # GUI chính - 3 workflow
│   ├── run_RDH_project.m     # File khởi chạy
│   └── README.md             # Tài liệu này
├── 🔧 Core Algorithms  
│   ├── embed_HS.m            # Thuật toán Histogram Shifting (Embed)
│   ├── extract_HS.m          # Thuật toán Histogram Shifting (Extract)
│   ├── embed_DE.m            # Thuật toán Difference Expansion (Embed)
│   └── extract_DE.m          # Thuật toán Difference Expansion (Extract)
├── 🔤 Text Processing
│   ├── text_to_binary.m      # Chuyển text → binary (16-bit encoding)
│   └── binary_to_text.m      # Chuyển binary → text (với fallback)
└── 🛠️ Utilities
    ├── create_demo_image.m   # Tạo ảnh demo cho test
    ├── calculate_psnr.m      # Tính PSNR đánh giá chất lượng
    └── README_Vietnamese.md  # Tài liệu cũ (tham khảo)
```

## 🚀 Hướng Dẫn Sử Dụng

### 📥 **Cài Đặt & Khởi Chạy:**

```matlab
% Trong MATLAB, chạy:
run_RDH_project

% Hoặc trực tiếp:
RDH_GUI_3Part
```

### 🔒 **Workflow 1: GIẤU TIN**

1. **Nạp ảnh gốc** hoặc chọn **"Ảnh Demo"**
2. **Nhập dữ liệu bí mật** (ví dụ: "Tin mật quan trọng!")
3. **Chọn thuật toán:** Histogram Shifting (khuyến nghị)
4. **Nhấn "THỰC HIỆN GIẤU TIN"**
5. **⚠️ QUAN TRỌNG:** Lưu cả 2 file:
   - **💾 "Lưu ảnh đã giấu tin"** → `secret.png` (chia sẻ được)
   - **📁 "Lưu thông tin embed"** → `key.mat` (giữ bí mật!)

### 🔓 **Workflow 2: TRÍCH XUẤT**

1. **📷 "Nạp ảnh đã giấu tin"** → chọn `secret.png`
2. **📁 "Nạp thông tin embed"** → chọn `key.mat`
3. **Nhấn "TRÍCH XUẤT DỮ LIỆU"**
4. **Xem kết quả:** "Tin mật quan trọng!"
5. *(Tùy chọn)* **Lưu dữ liệu** → file `.txt`

### ♻️ **Workflow 3: KHÔI PHỤC**

1. **📷 "Nạp ảnh đã giấu tin"** → chọn `secret.png`  
2. **📁 "Nạp thông tin embed"** → chọn `key.mat`
3. **Nhấn "KHÔI PHỤC ẢNH GỐC"**
4. **Kết quả:** Ảnh gốc hoàn hảo (MSE = 0)
5. *(Tùy chọn)* **Lưu ảnh khôi phục**

## 🛡️ Logic Bảo Mật

### ✅ **Thiết Kế Đúng Chuẩn RDH:**

```
📤 NGƯỜI GỬI:
Tab 1: Ảnh gốc + "Tin mật" → secret.png + key.mat
├── Gửi công khai: secret.png (qua email, mạng xã hội...)
└── Gửi riêng: key.mat (qua kênh bảo mật)

📥 NGƯỜI NHẬN:  
Tab 2: secret.png + key.mat → "Tin mật"
Tab 3: secret.png + key.mat → Ảnh gốc
```

### 🔒 **Các Biện Pháp Bảo Mật:**

- **❌ Tab 2 & 3 KHÔNG nhận ảnh gốc** (tránh rò rỉ)
- **⚠️ Cảnh báo tự động** nếu file có tên nghi ngờ (`original`, `demo`, `goc`...)
- **🔐 Xác nhận dialog** khi chọn file có dấu hiệu là ảnh gốc
- **📷 Nút rõ ràng:** "NẠP ẢNH ĐÃ GIẤU TIN" 

## 🧮 Chi Tiết Thuật Toán

### 📊 **Histogram Shifting (HS) - Khuyến Nghị**

**Ưu điểm:**
- ✅ PSNR cao (thường > 50dB)
- ✅ Ít méo ảnh, chất lượng tốt
- ✅ Khôi phục hoàn hảo 100%

**Tối ưu hóa:**
- 🎯 Tránh pixel cực trị (0, 255)
- 🎯 Tạo "artificial zero point" gần peak
- 🎯 Pre-shifting chỉ trong phạm vi nhỏ
- 🎯 Giới hạn capacity để đảm bảo chất lượng

### ⚡ **Difference Expansion (DE) - Dự Phòng**

**Ưu điểm:**
- ✅ Capacity lớn hơn HS
- ✅ Khôi phục hoàn hảo 100%

**Nhược điểm:**  
- ❌ PSNR thấp hơn HS
- ❌ Có thể gây méo ảnh nhiều hơn

## 🔤 Text Encoding

### 📝 **Định Dạng Encoding:**
```
[16-bit char1][16-bit char2]...[16-bit charN][8-bit length]
```

### 🛡️ **Bảo Vệ Header:**
- Header 8-bit ở cuối (protected position)
- Fallback calculation từ total bits
- Hỗ trợ Unicode/Vietnamese đầy đủ
- Error handling với padding

## 📈 Hiệu Suất & Chất Lượng

### 🎯 **Histogram Shifting:**
- **PSNR:** 50-70dB (Excellent)
- **Capacity:** Vừa phải, đủ cho text
- **Khuyến nghị:** Dùng cho hầu hết trường hợp

### ⚡ **Difference Expansion:**  
- **PSNR:** 19-30dB (Acceptable)
- **Capacity:** Lớn
- **Khuyến nghị:** Dùng khi cần capacity cao

## 🔧 Yêu Cầu Hệ Thống

- **MATLAB** R2018b trở lên
- **Image Processing Toolbox**
- **Minimum RAM:** 4GB
- **Supported formats:** PNG, JPG, BMP, TIF

## 🐛 Troubleshooting

### ❓ **Lỗi Thường Gặp:**

**🚨 "Unrecognized field name"**
```
Nguyên nhân: Lỗi handle management
Giải pháp: Restart MATLAB và chạy lại RDH_GUI_3Part
```

**🚨 "Text bị garbled"**
```
Nguyên nhân: Lỗi encoding/decoding  
Giải pháp: Kiểm tra file embed info có đúng không
```

**🚨 "Không thể embed hết dữ liệu"**
```
Nguyên nhân: Text quá dài hoặc ảnh không đủ capacity
Giải pháp: Rút ngắn text hoặc dùng ảnh lớn hơn
```

## 📚 Tài Liệu Tham Khảo

- **Reversible Data Hiding:** Ni et al., "Reversible Data Hiding", IEEE Transactions
- **Histogram Shifting:** Ni et al., "Reversible Data Hiding Based on Histogram Shifting"  
- **Difference Expansion:** Tian, "Reversible Data Embedding Using a Difference Expansion"

## 👨‍💻 Thông Tin Project

- **Ngôn ngữ:** MATLAB
- **GUI Framework:** MATLAB GUIDE/Programmatic
- **Encoding:** Custom 16-bit + 8-bit header
- **Bảo mật:** 2-layer security model

---

## 🆘 Hỗ Trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra **Troubleshooting** ở trên
2. Đảm bảo MATLAB có **Image Processing Toolbox**
3. Restart MATLAB và thử lại

**🎯 Project hoàn chỉnh và sẵn sàng sử dụng!**
