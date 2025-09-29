# Hệ thống Giấu tin Thuận nghịch trong Ảnh (Reversible Data Hiding)

## Mô tả dự án

Đây là hệ thống hoàn chỉnh cho giấu tin thuận nghịch trong ảnh, được phát triển bằng MATLAB. Hệ thống hỗ trợ hai thuật toán chính:
- **DE (Difference Expansion)**: Thuật toán mở rộng hiệu số
- **HS (Histogram Shifting)**: Thuật toán dịch chuyển histogram

## Tính năng chính

✅ **GUI thân thiện**: Giao diện đồ họa dễ sử dụng  
✅ **Hai thuật toán RDH**: DE và HS với hiệu suất cao  
✅ **Khôi phục hoàn hảo**: Ảnh gốc được khôi phục 100%  
✅ **Đo lường chất lượng**: Tính toán PSNR tự động  
✅ **Hỗ trợ đa định dạng**: JPG, PNG, BMP, TIF  
✅ **Ảnh demo tích hợp**: Không cần chuẩn bị ảnh test  

## Cấu trúc file

```
RDH_Project/
├── RDH_GUI.m              # GUI chính
├── RDH_GUI.fig            # File layout GUI
├── embed_DE.m             # Thuật toán embed DE
├── extract_DE.m           # Thuật toán extract DE
├── embed_HS.m             # Thuật toán embed HS
├── extract_HS.m           # Thuật toán extract HS
├── text_to_binary.m       # Chuyển text sang binary
├── binary_to_text.m       # Chuyển binary sang text
├── calculate_psnr.m       # Tính toán PSNR
├── create_demo_image.m    # Tạo ảnh demo
├── test_RDH_system.m      # Script test hệ thống
└── README_Vietnamese.md   # Hướng dẫn này
```

## Hướng dẫn sử dụng

### 1. Chạy GUI
```matlab
% Mở MATLAB và chuyển đến thư mục project
cd('/Users/trantrung/RDH_Project')

% Chạy GUI
RDH_GUI
```

### 2. Sử dụng qua Command Line
```matlab
% Test toàn bộ hệ thống
test_RDH_system

% Hoặc test thủ công
demo_img = create_demo_image();
secret_text = 'Hello World!';
secret_bits = text_to_binary(secret_text);

% Test DE
[watermarked, info] = embed_DE(demo_img, secret_bits);
[recovered, extracted] = extract_DE(watermarked, info);
result_text = binary_to_text(extracted);

% Test HS
[watermarked, info] = embed_HS(demo_img, secret_bits);
[recovered, extracted] = extract_HS(watermarked, info);
result_text = binary_to_text(extracted);
```

### 3. Workflow trong GUI

1. **Chọn thuật toán**: DE hoặc HS từ dropdown
2. **Tải ảnh**: Click "Tải ảnh gốc" hoặc "Ảnh Demo"
3. **Nhập dữ liệu**: Gõ text cần giấu vào ô input
4. **Giấu tin**: Click "Giấu tin" để embed
5. **Trích xuất**: Click "Trích xuất" để extract và khôi phục
6. **Lưu kết quả**: Click "Lưu ảnh" để save file

## Thuật toán

### Difference Expansion (DE)
- **Nguyên lý**: Mở rộng hiệu số giữa các pixel liền kề
- **Ưu điểm**: Capacity cao, PSNR tốt
- **Công thức**: `d' = 2*d + secret_bit`
- **Phù hợp**: Ảnh có nhiều vùng smooth

### Histogram Shifting (HS)
- **Nguyên lý**: Dịch chuyển histogram để tạo không gian embed
- **Ưu điểm**: Ổn định, ít artifact
- **Công thức**: Shift các bins trong histogram
- **Phù hợp**: Ảnh có histogram concentrated

## Kết quả mong đợi

- **PSNR**: Thường > 40 dB cho chất lượng tốt
- **Khôi phục**: 100% giống ảnh gốc
- **Capacity**: Phụ thuộc vào đặc tính ảnh
- **Tốc độ**: Embed + Extract < 1 giây cho ảnh 256x256

## Troubleshooting

### Lỗi thường gặp

1. **"Undefined function"**
   - Đảm bảo tất cả file .m ở cùng thư mục
   - Chạy `addpath(pwd)` để thêm path

2. **"Không thể embed hết dữ liệu"**
   - Thử text ngắn hơn
   - Chọn ảnh có texture đa dạng hơn

3. **"Lỗi trong quá trình embed/extract"**
   - Kiểm tra ảnh input (phải là grayscale hoặc RGB)
   - Đảm bảo dữ liệu input hợp lệ

### Tips sử dụng

- **Chọn ảnh phù hợp**: Ảnh có đa dạng intensity
- **Dữ liệu ngắn**: Bắt đầu với text ngắn để test
- **So sánh thuật toán**: Thử cả DE và HS để thấy khác biệt
- **Kiểm tra PSNR**: PSNR > 30 dB là chấp nhận được

## Mở rộng

Dự án có thể mở rộng với:
- **Thuật toán khác**: PEE, PVO, etc.
- **Encryption**: Mã hóa dữ liệu trước khi embed
- **Batch processing**: Xử lý nhiều ảnh cùng lúc
- **Video RDH**: Áp dụng cho video

## Liên hệ

Nếu có vấn đề hoặc cần hỗ trợ, vui lòng tạo issue hoặc liên hệ trực tiếp.

---
*Phát triển bởi: [Tên sinh viên]*  
*Ngày: September 2025*  
*MATLAB Version: R2020b+*

