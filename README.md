# GIẤU TIN THUẬN NGHỊCH TRONG ẢNH (REVERSIBLE DATA HIDING)

## 📋 TỔNG QUAN DỰ ÁN

Dự án này triển khai và so sánh hai thuật toán chính trong lĩnh vực Giấu tin thuận nghịch (Reversible Data Hiding - RDH):

1. **Difference Expansion (DE)** - Kỹ thuật mở rộng sai khác
2. **Histogram Shifting (HS)** - Kỹ thuật dịch chuyển histogram

## 🎯 MỤC TIÊU

- Nghiên cứu và hiểu rõ nguyên lý hoạt động của các thuật toán RDH
- Cài đặt thuật toán DE và HS bằng MATLAB
- Demo và so sánh hiệu suất của hai thuật toán
- Đảm bảo tính reversible: có thể khôi phục hoàn toàn ảnh gốc sau khi trích xuất dữ liệu

## 📁 CẤU TRÚC DỰ ÁN

```
Giautinthuannghich/
├── main_demo.m                          # Chương trình chính
├── README.md                            # Tài liệu hướng dẫn
│
├── --- ẢNH TEST ---
├── create_test_lena.m                   # Tạo ảnh Lena test
├── create_test_cameraman.m              # Tạo ảnh Cameraman test
│
├── --- CHUYỂN ĐỔI DỮ LIỆU ---
├── text_to_bits.m                       # Chuyển text sang bits
├── bits_to_text.m                       # Chuyển bits sang text
│
├── --- THUẬT TOÁN DIFFERENCE EXPANSION ---
├── difference_expansion_embed.m         # DE: Embedding
├── difference_expansion_extract.m       # DE: Extraction
├── demo_difference_expansion.m          # DE: Demo đầy đủ
│
├── --- THUẬT TOÁN HISTOGRAM SHIFTING ---
├── histogram_shifting_embed.m           # HS: Embedding
├── histogram_shifting_extract.m         # HS: Extraction
├── demo_histogram_shifting.m            # HS: Demo đầy đủ
│
└── --- SO SÁNH THUẬT TOÁN ---
    └── demo_comparison.m                # So sánh DE vs HS
```

## 🚀 HƯỚNG DẪN SỬ DỤNG

### Bước 1: Khởi chạy chương trình
```matlab
>> main_demo
```

### Bước 2: Lựa chọn thuật toán
```
Chọn thuật toán:
1. Difference Expansion (DE)
2. Histogram Shifting (HS)  
3. So sánh cả hai thuật toán
```

### Bước 3: Chọn ảnh test
```
Chọn ảnh test:
1. Lena (512x512)
2. Cameraman (256x256)
3. Ảnh tùy chỉnh
```

### Bước 4: Xem kết quả
- Chương trình sẽ hiển thị:
  - Quá trình embedding (giấu tin)
  - Quá trình extraction (trích xuất)
  - So sánh ảnh gốc, ảnh stego, ảnh khôi phục
  - Thống kê PSNR, capacity, tốc độ
  - Histogram analysis

## 🔬 THUẬT TOÁN

### 1. Difference Expansion (DE)

**Nguyên lý:**
- Sử dụng cặp pixel để tính average (l) và difference (h)
- Mở rộng difference: h' = 2h + b (b là bit cần giấu)
- Khôi phục: h = floor(h'/2), b = h' mod 2

**Ưu điểm:**
- Dung lượng giấu tin cao
- Phù hợp với ảnh có texture phong phú

**Nhược điểm:**
- Có thể gây overflow với một số loại ảnh
- PSNR thấp hơn HS với một số ảnh

### 2. Histogram Shifting (HS)

**Nguyên lý:**
- Tìm peak point (điểm có tần số cao nhất)
- Tìm zero point (điểm có tần số = 0 hoặc thấp nhất)
- Dịch chuyển histogram và giấu bit tại peak point

**Ưu điểm:**
- PSNR cao, chất lượng ảnh tốt
- Đơn giản, ít risk overflow

**Nhược điểm:**
- Dung lượng giấu tin thấp hơn DE
- Phụ thuộc vào đặc tính histogram của ảnh

## 📊 KẾT QUẢ DEMO

### Thông số đánh giá:
- **PSNR (Peak Signal-to-Noise Ratio)**: Chất lượng ảnh
- **Capacity**: Dung lượng giấu tin (bits per pixel)
- **Speed**: Tốc độ xử lý (giây)
- **Reversibility**: Tính khôi phục hoàn toàn

### Ví dụ kết quả với ảnh Lena 512x512:

| Tiêu chí | DE | HS |
|----------|----|----|
| PSNR (dB) | ~45-55 | ~50-60 |
| Capacity (bpp) | ~0.5-1.0 | ~0.1-0.5 |
| Tốc độ | Nhanh | Rất nhanh |
| Reversibility | ✓ | ✓ |

## 🛠️ YÊU CẦU HỆ THỐNG

- **MATLAB R2018b** trở lên
- **Image Processing Toolbox** (khuyến nghị)
- RAM: ít nhất 4GB
- Dung lượng: ~50MB

## 📖 TÀI LIỆU THAM KHẢO

1. Tian, J. (2003). "Reversible data embedding using a difference expansion"
2. Ni, Z., Shi, Y. Q., Ansari, N., Su, W. (2006). "Reversible data hiding"
3. Thodi, D. M., Rodriguez, J. J. (2007). "Expansion embedding techniques for reversible watermarking"

## 🔍 DEBUGGING VÀ TROUBLESHOOTING

### Lỗi thường gặp:

1. **"Undefined function"**
   - Đảm bảo tất cả file .m nằm trong cùng thư mục
   - Chạy `addpath(pwd)` để thêm thư mục hiện tại vào path

2. **"Không thể giấu hết dữ liệu"**
   - Giảm độ dài message cần giấu
   - Thử với ảnh có texture phong phú hơn

3. **"Out of memory"**
   - Sử dụng ảnh có kích thước nhỏ hơn
   - Đóng các ứng dụng khác đang chạy

### Debug mode:
```matlab
% Bật debug output chi tiết
debug_mode = true;
```

## 👥 TÁC GIẢ

- **Sinh viên:** [Tên sinh viên]
- **Lớp:** [Mã lớp]
- **Môn học:** Xử lý ảnh số / An ninh thông tin
- **Ngày:** September 2025

## 📄 LICENSE

Dự án này được phát triển cho mục đích học tập và nghiên cứu.

---

**Lưu ý:** Đây là phiên bản demo cho mục đích giáo dục. Để sử dụng trong thực tế, cần thêm các tối ưu hóa về bảo mật và hiệu suất.
