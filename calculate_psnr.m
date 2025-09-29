function psnr_value = calculate_psnr(original_img, watermarked_img)
% CALCULATE_PSNR - Tính Peak Signal-to-Noise Ratio (PSNR)
% Input:
%   original_img: Ảnh gốc
%   watermarked_img: Ảnh đã watermark
% Output:
%   psnr_value: Giá trị PSNR tính bằng dB

try
    % Chuyển về double
    original_img = double(original_img);
    watermarked_img = double(watermarked_img);
    
    % Kiểm tra kích thước
    if ~isequal(size(original_img), size(watermarked_img))
        error('Kích thước ảnh gốc và ảnh watermark không khớp');
    end
    
    % Tính Mean Square Error (MSE)
    mse = mean((original_img(:) - watermarked_img(:)).^2);
    
    % Tránh chia cho 0
    if mse == 0
        psnr_value = Inf;
        fprintf('MSE = 0, PSNR = Inf (ảnh giống hệt nhau)\n');
        return;
    end
    
    % Tính PSNR
    max_pixel_value = 255; % Giả sử ảnh 8-bit
    psnr_value = 10 * log10((max_pixel_value^2) / mse);
    
    fprintf('MSE: %.6f\n', mse);
    fprintf('PSNR: %.2f dB\n', psnr_value);
    
catch err
    error('Lỗi trong calculate_psnr: %s', err.message);
end
end

