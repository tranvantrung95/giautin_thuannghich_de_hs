function [recovered_img, extracted_bits] = extract_HS(watermarked_img, embed_info)
% EXTRACT_HS - Trích xuất dữ liệu từ ảnh đã giấu tin bằng HS
% Input:
%   watermarked_img: Ảnh đã giấu tin
%   embed_info: Thông tin embed từ quá trình embed
% Output:
%   recovered_img: Ảnh đã khôi phục (giống ảnh gốc)
%   extracted_bits: Dữ liệu đã trích xuất dưới dạng chuỗi bit

try
    % Lấy thông tin embed
    is_color = embed_info.is_color;
    peak_point = embed_info.peak_point;
    zero_point = embed_info.zero_point;
    shift_direction = embed_info.shift_direction;
    shift_range = embed_info.shift_range;
    secret_length = embed_info.secret_length;
    embedded_locations = embed_info.embedded_locations;
    if isfield(embed_info, 'actual_embedded')
        secret_length = embed_info.actual_embedded;
    end
    
    % Chuyển về grayscale nếu cần
    if is_color
        ycbcr_img = rgb2ycbcr(watermarked_img);
        gray_watermarked = ycbcr_img(:,:,1);
    else
        gray_watermarked = watermarked_img;
        ycbcr_img = [];
    end
    
    % Chuyển về double
    gray_watermarked = double(gray_watermarked);
    [rows, cols] = size(gray_watermarked);
    
    % Khởi tạo ảnh khôi phục
    recovered_gray = gray_watermarked;
    
    % Bước 1: Trích xuất dữ liệu và khôi phục peak points
    extracted_data = [];
    
    % Trích xuất theo thứ tự embedded_locations
    for k = 1:size(embedded_locations, 1)
        i = embedded_locations(k, 1);
        j = embedded_locations(k, 2);

        pixel_val = gray_watermarked(i, j);

        % Suy ra bit dựa trên hướng shift
        if shift_direction == 1
            bit_val = pixel_val ~= peak_point; % 1 nếu đã dịch sang phải (>= peak+1)
        else
            bit_val = pixel_val ~= peak_point; % 1 nếu đã dịch sang trái (<= peak-1)
        end

        extracted_data = [extracted_data, bit_val];
        recovered_gray(i, j) = peak_point; % khôi phục về peak gốc
    end
    
    % Không cần bước khôi phục pre-shift vì embed đã bỏ qua pre-shift để thuận nghịch tuyệt đối
    
    % Chuyển về uint8
    recovered_gray = uint8(round(recovered_gray));
    
    % Tạo ảnh kết quả cuối cùng
    if is_color
        ycbcr_img(:,:,1) = recovered_gray;
        recovered_img = ycbcr2rgb(ycbcr_img);
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
        extracted_bits = [extracted_bits, repmat('0', 1, secret_length - length(extracted_bits))];
    elseif length(extracted_bits) > secret_length
        extracted_bits = extracted_bits(1:secret_length);
    end
    
    fprintf('HS Extraction hoàn thành: %d bit đã được trích xuất\n', ...
        length(extracted_bits));
    
catch err
    error('Lỗi trong quá trình extract HS: %s', err.message);
end
end
