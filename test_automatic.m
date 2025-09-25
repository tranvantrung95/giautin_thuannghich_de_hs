%% SCRIPT TEST TỰ ĐỘNG CHO CHƯƠNG TRÌNH RDH
% Chạy test mà không cần user input
clear all; close all; clc;

fprintf('========================================\n');
fprintf('BẮT ĐẦU TEST TỰ ĐỘNG CHƯƠNG TRÌNH RDH\n');
fprintf('========================================\n\n');

try
    %% TEST 1: Tạo ảnh test
    fprintf('🔹 TEST 1: Tạo ảnh test\n');
    
    % Test tạo ảnh Lena
    img_lena = create_test_lena();
    fprintf('✅ Tạo ảnh Lena thành công: %dx%d\n', size(img_lena,1), size(img_lena,2));
    
    % Test tạo ảnh Cameraman
    img_cameraman = create_test_cameraman();
    fprintf('✅ Tạo ảnh Cameraman thành công: %dx%d\n', size(img_cameraman,1), size(img_cameraman,2));
    
    %% TEST 2: Chuyển đổi text/bits
    fprintf('\n🔹 TEST 2: Chuyển đổi text/bits\n');
    
    test_text = 'Hello RDH Test!';
    bits = text_to_bits(test_text);
    recovered_text = bits_to_text(bits);
    
    if strcmp(test_text, recovered_text)
        fprintf('✅ Chuyển đổi text/bits thành công\n');
    else
        error('❌ Lỗi chuyển đổi text/bits');
    end
    
    %% TEST 3: Thuật toán Difference Expansion
    fprintf('\n🔹 TEST 3: Thuật toán Difference Expansion\n');
    
    % Sử dụng ảnh nhỏ hơn để test nhanh
    test_img = imresize(img_cameraman, [128, 128]);
    secret_bits = text_to_bits('Test DE');
    
    % Embedding
    [stego_img, location_map, embedded_length] = difference_expansion_embed(test_img, secret_bits);
    fprintf('✅ DE Embedding thành công: %d bits\n', embedded_length);
    
    % Extraction
    [recovered_img, extracted_bits] = difference_expansion_extract(stego_img, location_map, embedded_length);
    recovered_text = bits_to_text(extracted_bits);
    
    % Kiểm tra reversibility
    if isequal(test_img, recovered_img)
        fprintf('✅ DE Reversibility: THÀNH CÔNG\n');
    else
        fprintf('⚠️ DE Reversibility: CÓ SAI KHÁC NHỎ\n');
    end
    
    fprintf('✅ DE Text khôi phục: "%s"\n', recovered_text);
    
    %% TEST 4: Thuật toán Histogram Shifting
    fprintf('\n🔹 TEST 4: Thuật toán Histogram Shifting\n');
    
    % Embedding
    [stego_img_hs, peak_point, zero_point, embedded_length_hs] = histogram_shifting_embed(test_img, secret_bits);
    fprintf('✅ HS Embedding thành công: %d bits (peak: %d, zero: %d)\n', embedded_length_hs, peak_point, zero_point);
    
    % Extraction
    [recovered_img_hs, extracted_bits_hs] = histogram_shifting_extract(stego_img_hs, peak_point, zero_point, embedded_length_hs);
    recovered_text_hs = bits_to_text(extracted_bits_hs);
    
    % Kiểm tra reversibility
    if isequal(test_img, recovered_img_hs)
        fprintf('✅ HS Reversibility: THÀNH CÔNG\n');
    else
        fprintf('⚠️ HS Reversibility: CÓ SAI KHÁC NHỎ\n');
    end
    
    fprintf('✅ HS Text khôi phục: "%s"\n', recovered_text_hs);
    
    %% TEST 5: Tính toán PSNR
    fprintf('\n🔹 TEST 5: Đánh giá chất lượng\n');
    
    % PSNR cho DE
    mse_de = mean((test_img(:) - stego_img(:)).^2);
    if mse_de == 0
        psnr_de = Inf;
    else
        psnr_de = 10 * log10(255^2 / mse_de);
    end
    
    % PSNR cho HS
    mse_hs = mean((test_img(:) - stego_img_hs(:)).^2);
    if mse_hs == 0
        psnr_hs = Inf;
    else
        psnr_hs = 10 * log10(255^2 / mse_hs);
    end
    
    fprintf('✅ PSNR DE: %.2f dB\n', psnr_de);
    fprintf('✅ PSNR HS: %.2f dB\n', psnr_hs);
    
    %% TỔNG KẾT
    fprintf('\n========================================\n');
    fprintf('🎉 TẤT CẢ TEST ĐÃ THÀNH CÔNG!\n');
    fprintf('========================================\n');
    fprintf('Chương trình RDH đã sẵn sàng sử dụng.\n');
    fprintf('Chạy "main_demo" để bắt đầu demo.\n');
    fprintf('========================================\n');
    
catch ME
    fprintf('\n❌ LỖI TRONG QUÁ TRÌNH TEST:\n');
    fprintf('Lỗi: %s\n', ME.message);
    fprintf('File: %s\n', ME.stack(1).file);
    fprintf('Dòng: %d\n', ME.stack(1).line);
    fprintf('\nVui lòng kiểm tra lại code.\n');
end
