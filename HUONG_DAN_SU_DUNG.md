# HƯỚNG DẪN SỬ DỤNG NHANH

## 🚀 KHỞI CHẠY CHƯƠNG TRÌNH

### Cách 1: Demo tự động (Khuyến nghị cho lần đầu)
```matlab
>> test_automatic
```
Script này sẽ:
- Tự động test tất cả functions
- Hiển thị kết quả chi tiết
- Không cần input từ user

### Cách 2: Demo tương tác
```matlab
>> main_demo
```
Chương trình sẽ hỏi:
1. Chọn thuật toán (1: DE, 2: HS, 3: So sánh)
2. Chọn ảnh test (1: Lena, 2: Cameraman, 3: Ảnh tùy chỉnh)

## 📋 CÁC LỆNH QUAN TRỌNG

### Test từng thuật toán riêng:
```matlab
% Test Difference Expansion
img = create_test_lena();
secret_bits = text_to_bits('Hello World!');
demo_difference_expansion(img, secret_bits, 'Test');

% Test Histogram Shifting  
demo_histogram_shifting(img, secret_bits, 'Test');

% So sánh cả hai
demo_comparison(img, secret_bits, 'Test');
```

### Tạo ảnh test:
```matlab
img_lena = create_test_lena();      % 512x512
img_cam = create_test_cameraman();  % 256x256
```

### Chuyển đổi dữ liệu:
```matlab
bits = text_to_bits('Secret message');
text = bits_to_text(bits);
```

## 🔧 TROUBLESHOOTING

### Lỗi "Undefined function":
```matlab
addpath(pwd);  % Thêm thư mục hiện tại vào path
```

### Lỗi "Out of memory":
- Sử dụng ảnh nhỏ hơn
- Giảm độ dài message

### Không giấu được hết dữ liệu:
- Thử ảnh có texture phong phú hơn
- Giảm độ dài secret message

## 📊 HIỂU KẾT QUẢ

### PSNR (Peak Signal-to-Noise Ratio):
- > 50 dB: Chất lượng rất tốt
- 40-50 dB: Chất lượng tốt  
- < 40 dB: Chất lượng trung bình

### Capacity (bpp - bits per pixel):
- > 0.5 bpp: Dung lượng cao
- 0.1-0.5 bpp: Dung lượng trung bình
- < 0.1 bpp: Dung lượng thấp

### Reversibility:
- ✓: Khôi phục hoàn toàn ảnh gốc
- ✗: Có sai khác nhỏ (có thể do rounding error)

## 🎯 DEMO NHANH 30 GIÂY

```matlab
% 1. Chạy test tự động
test_automatic;

% 2. Hoặc demo nhanh
img = create_test_cameraman();
bits = text_to_bits('Demo RDH');
demo_comparison(img, bits, 'Quick Demo');
```

## 📁 CẤU TRÚC FILE

- `main_demo.m`: Chương trình chính
- `test_automatic.m`: Test tự động  
- `demo_*.m`: Các demo riêng biệt
- `*_embed.m`, `*_extract.m`: Thuật toán core
- `README.md`: Tài liệu đầy đủ
- `BAO_CAO_LY_THUYET.md`: Báo cáo lý thuyết

---
**Lưu ý:** Đảm bảo tất cả file .m nằm trong cùng thư mục và đã add path MATLAB.
