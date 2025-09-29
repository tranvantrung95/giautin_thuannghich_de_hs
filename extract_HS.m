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
    
    % Chuyển về grayscale nếu cần
    if is_color
        gray_watermarked = watermarked_img(:,:,1);
    else
        gray_watermarked = watermarked_img;
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
        embedded_bit = embedded_locations(k, 3);
        
        pixel_val = gray_watermarked(i, j);
        
        if embedded_bit == 1
            % Pixel đã được chuyển sang zero_point direction
            extracted_data = [extracted_data, 1];
            recovered_gray(i, j) = peak_point;
        else
            % Pixel vẫn ở peak_point
            extracted_data = [extracted_data, 0];
            recovered_gray(i, j) = peak_point;
        end
    end
    
    % Bước 2: Khôi phục histogram bằng cách shift ngược lại (sử dụng pre_shift_range)
    if isfield(embed_info, 'pre_shift_range') && ~isempty(embed_info.pre_shift_range)
        pre_shift_range = embed_info.pre_shift_range;
        
        for i = 1:rows
            for j = 1:cols
                pixel_val = recovered_gray(i, j);
                
                % Kiểm tra pixel có bị pre-shift không và shift ngược lại
                if shift_direction == 1
                    % Đã shift sang phải, shift ngược về trái
                    if pixel_val >= pre_shift_range(1) + 1 && pixel_val <= pre_shift_range(2) + 1
                        % Kiểm tra xem có phải pixel đã embed không
                        is_embedded = false;
                        for k = 1:size(embedded_locations, 1)
                            if embedded_locations(k, 1) == i && embedded_locations(k, 2) == j
                                is_embedded = true;
                                break;
                            end
                        end
                        
                        if ~is_embedded
                            recovered_gray(i, j) = pixel_val - 1;
                        end
                    end
                else
                    % Đã shift sang trái, shift ngược về phải  
                    if pixel_val >= pre_shift_range(1) - 1 && pixel_val <= pre_shift_range(2) - 1
                        % Kiểm tra xem có phải pixel đã embed không
                        is_embedded = false;
                        for k = 1:size(embedded_locations, 1)
                            if embedded_locations(k, 1) == i && embedded_locations(k, 2) == j
                                is_embedded = true;
                                break;
                            end
                        end
                        
                        if ~is_embedded
                            recovered_gray(i, j) = pixel_val + 1;
                        end
                    end
                end
            end
        end
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

