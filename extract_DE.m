function [recovered_img, extracted_bits] = extract_DE(watermarked_img, embed_info)
% EXTRACT_DE - Trích xuất dữ liệu từ ảnh đã giấu tin bằng DE
% Input:
%   watermarked_img: Ảnh đã giấu tin
%   embed_info: Thông tin embed từ quá trình embed
% Output:
%   recovered_img: Ảnh đã khôi phục (giống ảnh gốc)
%   extracted_bits: Dữ liệu đã trích xuất dưới dạng chuỗi bit

try
    % Lấy thông tin embed
    is_color = embed_info.is_color;
    locations = embed_info.locations;
    secret_length = embed_info.secret_length;
    
    % Chuyển về grayscale nếu cần
    if is_color
        gray_watermarked = watermarked_img(:,:,1);
    else
        gray_watermarked = watermarked_img;
    end
    
    % Chuyển về double
    gray_watermarked = double(gray_watermarked);
    recovered_gray = gray_watermarked;
    
    % Khởi tạo chuỗi bit trích xuất
    extracted_data = zeros(size(locations, 1), 1);
    
    % Trích xuất bit từ các vị trí đã embed
    for k = 1:size(locations, 1)
        i = locations(k, 1);
        j = locations(k, 2);
        original_d = locations(k, 3);
        embedded_bit = locations(k, 4);
        
        % Lấy pixel đã watermark
        x_marked = gray_watermarked(i, j);
        y_marked = gray_watermarked(i, j+1);
        
        % Tính average và difference mới (match với embed)
        avg = (x_marked + y_marked) / 2;
        d_marked = x_marked - y_marked;
        
        % Trích xuất bit: extracted_bit = d_marked mod 2
        extracted_bit = mod(d_marked, 2);
        extracted_data(k) = extracted_bit;
        
        % Khôi phục difference gốc: d_original = floor(d_marked / 2)
        d_original = floor(d_marked / 2);
        
        % Khôi phục pixel gốc (match với embed formula)
        x_original = avg + ceil(d_original / 2);
        y_original = avg - floor(d_original / 2);
        
        recovered_gray(i, j) = x_original;
        recovered_gray(i, j+1) = y_original;
    end
    
    % Chuyển về uint8
    recovered_gray = uint8(round(recovered_gray));
    
    % Tạo ảnh kết quả cuối cùng
    if is_color
        recovered_img = embed_info.color_img;
        recovered_img(:,:,1) = recovered_gray;
    else
        recovered_img = recovered_gray;
    end
    
    % Chuyển extracted_data thành chuỗi bit
    extracted_bits = '';
    for i = 1:min(length(extracted_data), secret_length)
        extracted_bits = [extracted_bits, num2str(extracted_data(i))];
    end
    
    % Đảm bảo đúng độ dài
    if length(extracted_bits) < secret_length
        % Thêm bit 0 nếu thiếu
        extracted_bits = [extracted_bits, repmat('0', 1, secret_length - length(extracted_bits))];
    elseif length(extracted_bits) > secret_length
        % Cắt bớt nếu thừa
        extracted_bits = extracted_bits(1:secret_length);
    end
    
    fprintf('DE Extraction hoàn thành: %d bit đã được trích xuất\n', ...
        length(extracted_bits));
    
catch err
    error('Lỗi trong quá trình extract DE: %s', err.message);
end
end

