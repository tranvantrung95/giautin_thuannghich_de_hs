function demo_histogram_shifting(img, secret_bits, img_name)
    % DEMO THUẬT TOÁN HISTOGRAM SHIFTING
    % Input:
    %   img - ảnh gốc
    %   secret_bits - dữ liệu cần giấu
    %   img_name - tên ảnh để hiển thị
    
    fprintf('\n=======================================\n');
    fprintf('DEMO THUẬT TOÁN HISTOGRAM SHIFTING\n');
    fprintf('=======================================\n');
    
    % Bước 1: Embedding
    fprintf('\n🔹 BƯỚC 1: EMBEDDING (Giấu tin)\n');
    tic;
    [stego_img, peak_point, zero_point, embedded_length] = histogram_shifting_embed(img, secret_bits);
    embed_time = toc;
    
    % Bước 2: Extraction
    fprintf('\n🔹 BƯỚC 2: EXTRACTION (Trích xuất)\n');
    tic;
    [recovered_img, extracted_bits] = histogram_shifting_extract(stego_img, peak_point, zero_point, embedded_length);
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
    fprintf('Kết quả Histogram Shifting:\n');
    fprintf('- Thời gian embedding: %.4f giây\n', embed_time);
    fprintf('- Thời gian extraction: %.4f giây\n', extract_time);
    fprintf('- PSNR (Cover vs Stego): %.2f dB\n', psnr_stego);
    fprintf('- PSNR (Cover vs Recovered): %.2f dB\n', psnr_recovered);
    fprintf('- Tỷ lệ embedding: %.4f bpp\n', embedded_length / numel(img));
    fprintf('- Peak point sử dụng: %d\n', peak_point);
    fprintf('- Zero point sử dụng: %d\n', zero_point);
    fprintf('- Text khôi phục: "%s"\n', recovered_text);
    
    % Kiểm tra tính reversible
    is_reversible = isequal(img, recovered_img);
    if is_reversible
        fprintf('- Tính reversible: ✓ THÀNH CÔNG\n');
    else
        fprintf('- Tính reversible: ✗ THẤT BẠI\n');
    end
    
    % Hiển thị ảnh
    figure('Name', sprintf('Histogram Shifting - %s', img_name), 'Position', [200, 200, 1200, 400]);
    
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
    
    % Hiển thị histogram với peak và zero points
    figure('Name', sprintf('Histogram Analysis - HS - %s', img_name), 'Position', [250, 250, 1200, 600]);
    
    % Tính histogram cho visualization
    hist_cover = zeros(1, 256);
    hist_stego = zeros(1, 256);
    hist_recovered = zeros(1, 256);
    
    for val = 0:255
        hist_cover(val+1) = sum(img(:) == val);
        hist_stego(val+1) = sum(stego_img(:) == val);
        hist_recovered(val+1) = sum(recovered_img(:) == val);
    end
    
    subplot(2, 2, 1);
    bar(0:255, hist_cover, 'FaceColor', 'blue', 'EdgeColor', 'none');
    title('Histogram - Ảnh gốc');
    xlabel('Giá trị pixel');
    ylabel('Tần số');
    xlim([0, 255]);
    hold on;
    plot([peak_point, peak_point], [0, max(hist_cover)], 'r--', 'LineWidth', 2);
    plot([zero_point, zero_point], [0, max(hist_cover)], 'g--', 'LineWidth', 2);
    legend('Histogram', 'Peak Point', 'Zero Point');
    hold off;
    
    subplot(2, 2, 2);
    bar(0:255, hist_stego, 'FaceColor', 'red', 'EdgeColor', 'none');
    title('Histogram - Ảnh stego');
    xlabel('Giá trị pixel');
    ylabel('Tần số');
    xlim([0, 255]);
    hold on;
    plot([peak_point, peak_point], [0, max(hist_stego)], 'r--', 'LineWidth', 2);
    plot([zero_point, zero_point], [0, max(hist_stego)], 'g--', 'LineWidth', 2);
    legend('Histogram', 'Peak Point', 'Zero Point');
    hold off;
    
    subplot(2, 2, 3);
    bar(0:255, hist_recovered, 'FaceColor', 'green', 'EdgeColor', 'none');
    title('Histogram - Ảnh khôi phục');
    xlabel('Giá trị pixel');
    ylabel('Tần số');
    xlim([0, 255]);
    hold on;
    plot([peak_point, peak_point], [0, max(hist_recovered)], 'r--', 'LineWidth', 2);
    plot([zero_point, zero_point], [0, max(hist_recovered)], 'g--', 'LineWidth', 2);
    legend('Histogram', 'Peak Point', 'Zero Point');
    hold off;
    
    subplot(2, 2, 4);
    % So sánh trực tiếp histogram
    plot(0:255, hist_cover, 'b-', 'LineWidth', 1.5); hold on;
    plot(0:255, hist_stego, 'r--', 'LineWidth', 1.5);
    plot(0:255, hist_recovered, 'g:', 'LineWidth', 1.5);
    title('So sánh Histogram');
    xlabel('Giá trị pixel');
    ylabel('Tần số');
    xlim([0, 255]);
    legend('Cover', 'Stego', 'Recovered');
    grid on;
    hold off;
    
    fprintf('\n✅ Demo Histogram Shifting hoàn thành!\n');
end
