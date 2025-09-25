function demo_difference_expansion(img, secret_bits, img_name)
    % DEMO THUẬT TOÁN DIFFERENCE EXPANSION
    % Input:
    %   img - ảnh gốc
    %   secret_bits - dữ liệu cần giấu
    %   img_name - tên ảnh để hiển thị
    
    fprintf('\n=======================================\n');
    fprintf('DEMO THUẬT TOÁN DIFFERENCE EXPANSION\n');
    fprintf('=======================================\n');
    
    % Bước 1: Embedding
    fprintf('\n🔹 BƯỚC 1: EMBEDDING (Giấu tin)\n');
    tic;
    [stego_img, location_map, embedded_length] = difference_expansion_embed(img, secret_bits);
    embed_time = toc;
    
    % Bước 2: Extraction
    fprintf('\n🔹 BƯỚC 2: EXTRACTION (Trích xuất)\n');
    tic;
    [recovered_img, extracted_bits] = difference_expansion_extract(stego_img, location_map, embedded_length);
    extract_time = toc;
    
    % Bước 3: Khôi phục text
    fprintf('\n🔹 BƯỚC 3: KHÔI PHỤC DỮ LIỆU\n');
    recovered_text = bits_to_text(extracted_bits);
    
    % Đánh giá chất lượng
    fprintf('\n🔹 ĐÁNH GIÁ CHẤT LƯỢNG\n');
    
    % PSNR giữa ảnh gốc và stego
    mse_stego = mean((img(:) - stego_img(:)).^2);
    if mse_stego == 0
        psnr_stego = Inf;
    else
        psnr_stego = 10 * log10(255^2 / mse_stego);
    end
    
    % PSNR giữa ảnh gốc và recovered (phải bằng Inf nếu thuật toán đúng)
    mse_recovered = mean((img(:) - recovered_img(:)).^2);
    if mse_recovered == 0
        psnr_recovered = Inf;
    else
        psnr_recovered = 10 * log10(255^2 / mse_recovered);
    end
    
    % Hiển thị kết quả
    fprintf('Kết quả Difference Expansion:\n');
    fprintf('- Thời gian embedding: %.4f giây\n', embed_time);
    fprintf('- Thời gian extraction: %.4f giây\n', extract_time);
    fprintf('- PSNR (Cover vs Stego): %.2f dB\n', psnr_stego);
    fprintf('- PSNR (Cover vs Recovered): %.2f dB\n', psnr_recovered);
    fprintf('- Tỷ lệ embedding: %.4f bpp\n', embedded_length / numel(img));
    fprintf('- Text khôi phục: "%s"\n', recovered_text);
    
    % Kiểm tra tính reversible
    is_reversible = isequal(img, recovered_img);
    if is_reversible
        fprintf('- Tính reversible: ✓ THÀNH CÔNG\n');
    else
        fprintf('- Tính reversible: ✗ THẤT BẠI\n');
    end
    
    % Hiển thị ảnh
    figure('Name', sprintf('Difference Expansion - %s', img_name), 'Position', [100, 100, 1200, 400]);
    
    subplot(1, 3, 1);
    imshow(uint8(img));
    title('Ảnh gốc (Cover Image)');
    xlabel(sprintf('Kích thước: %dx%d', size(img,1), size(img,2)));
    
    subplot(1, 3, 2);
    imshow(uint8(stego_img));
    title('Ảnh đã giấu tin (Stego Image)');
    xlabel(sprintf('PSNR: %.2f dB', psnr_stego));
    
    subplot(1, 3, 3);
    imshow(uint8(recovered_img));
    title('Ảnh khôi phục (Recovered Image)');
    xlabel(sprintf('PSNR: %.2f dB', psnr_recovered));
    
    % Hiển thị histogram so sánh
    figure('Name', sprintf('Histogram Comparison - DE - %s', img_name), 'Position', [150, 150, 1000, 300]);
    
    subplot(1, 3, 1);
    histogram(img(:), 0:255, 'FaceColor', 'blue', 'EdgeColor', 'none');
    title('Histogram - Ảnh gốc');
    xlim([0, 255]);
    
    subplot(1, 3, 2);
    histogram(stego_img(:), 0:255, 'FaceColor', 'red', 'EdgeColor', 'none');
    title('Histogram - Ảnh stego');
    xlim([0, 255]);
    
    subplot(1, 3, 3);
    histogram(recovered_img(:), 0:255, 'FaceColor', 'green', 'EdgeColor', 'none');
    title('Histogram - Ảnh khôi phục');
    xlim([0, 255]);
    
    fprintf('\n✅ Demo Difference Expansion hoàn thành!\n');
end
