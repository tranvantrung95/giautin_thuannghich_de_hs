function demo_comparison(img, secret_bits, img_name)
    % SO SÁNH THUẬT TOÁN DE VÀ HS
    % Input:
    %   img - ảnh gốc
    %   secret_bits - dữ liệu cần giấu
    %   img_name - tên ảnh để hiển thị
    
    fprintf('\n=======================================\n');
    fprintf('SO SÁNH THUẬT TOÁN DE VÀ HS\n');
    fprintf('=======================================\n');
    
    %% DIFFERENCE EXPANSION
    fprintf('\n🔸 THỰC HIỆN DIFFERENCE EXPANSION\n');
    tic;
    [stego_img_de, location_map, embedded_length_de] = difference_expansion_embed(img, secret_bits);
    embed_time_de = toc;
    
    tic;
    [recovered_img_de, extracted_bits_de] = difference_expansion_extract(stego_img_de, location_map, embedded_length_de);
    extract_time_de = toc;
    
    % Tính PSNR cho DE
    mse_de = mean((img(:) - stego_img_de(:)).^2);
    if mse_de == 0
        psnr_de = Inf;
    else
        psnr_de = 10 * log10(255^2 / mse_de);
    end
    is_reversible_de = isequal(img, recovered_img_de);
    
    %% HISTOGRAM SHIFTING
    fprintf('\n🔸 THỰC HIỆN HISTOGRAM SHIFTING\n');
    tic;
    [stego_img_hs, peak_point, zero_point, embedded_length_hs] = histogram_shifting_embed(img, secret_bits);
    embed_time_hs = toc;
    
    tic;
    [recovered_img_hs, extracted_bits_hs] = histogram_shifting_extract(stego_img_hs, peak_point, zero_point, embedded_length_hs);
    extract_time_hs = toc;
    
    % Tính PSNR cho HS
    mse_hs = mean((img(:) - stego_img_hs(:)).^2);
    if mse_hs == 0
        psnr_hs = Inf;
    else
        psnr_hs = 10 * log10(255^2 / mse_hs);
    end
    is_reversible_hs = isequal(img, recovered_img_hs);
    
    %% BẢNG SO SÁNH
    fprintf('\n📊 BẢNG SO SÁNH KẾT QUẢ\n');
    fprintf('==============================================================\n');
    fprintf('| Tiêu chí                    | DE           | HS           |\n');
    fprintf('==============================================================\n');
    fprintf('| Thời gian Embedding (s)     | %8.4f     | %8.4f     |\n', embed_time_de, embed_time_hs);
    fprintf('| Thời gian Extraction (s)    | %8.4f     | %8.4f     |\n', extract_time_de, extract_time_hs);
    fprintf('| PSNR (dB)                   | %8.2f     | %8.2f     |\n', psnr_de, psnr_hs);
    fprintf('| Bits được giấu              | %8d     | %8d     |\n', embedded_length_de, embedded_length_hs);
    fprintf('| Tỷ lệ embedding (bpp)       | %8.4f     | %8.4f     |\n', embedded_length_de/numel(img), embedded_length_hs/numel(img));
    de_rev_str = '';
    if is_reversible_de
        de_rev_str = '✓';
    else
        de_rev_str = '✗';
    end
    
    hs_rev_str = '';
    if is_reversible_hs
        hs_rev_str = '✓';
    else
        hs_rev_str = '✗';
    end
    
    fprintf('| Tính reversible             | %8s     | %8s     |\n', de_rev_str, hs_rev_str);
    fprintf('==============================================================\n');
    
    % Khôi phục text
    recovered_text_de = bits_to_text(extracted_bits_de);
    recovered_text_hs = bits_to_text(extracted_bits_hs);
    
    fprintf('\nText khôi phục từ DE: "%s"\n', recovered_text_de);
    fprintf('Text khôi phục từ HS: "%s"\n', recovered_text_hs);
    
    %% ĐÁNH GIÁ CHI TIẾT
    fprintf('\n📈 PHÂN TÍCH CHI TIẾT\n');
    
    % Capacity analysis
    total_pixels = numel(img);
    capacity_de = embedded_length_de / total_pixels;
    capacity_hs = embedded_length_hs / total_pixels;
    
    fprintf('\n🔹 Dung lượng giấu tin:\n');
    fprintf('- DE có thể giấu: %.4f bpp (%d bits)\n', capacity_de, embedded_length_de);
    fprintf('- HS có thể giấu: %.4f bpp (%d bits)\n', capacity_hs, embedded_length_hs);
    
    if capacity_de > capacity_hs
        fprintf('- DE có dung lượng cao hơn HS\n');
    elseif capacity_hs > capacity_de
        fprintf('- HS có dung lượng cao hơn DE\n');
    else
        fprintf('- Hai thuật toán có dung lượng tương đương\n');
    end
    
    % Quality analysis
    fprintf('\n🔹 Chất lượng ảnh:\n');
    if psnr_de > psnr_hs
        fprintf('- DE cho chất lượng ảnh tốt hơn (PSNR cao hơn)\n');
    elseif psnr_hs > psnr_de
        fprintf('- HS cho chất lượng ảnh tốt hơn (PSNR cao hơn)\n');
    else
        fprintf('- Hai thuật toán cho chất lượng ảnh tương đương\n');
    end
    
    % Speed analysis
    total_time_de = embed_time_de + extract_time_de;
    total_time_hs = embed_time_hs + extract_time_hs;
    
    fprintf('\n🔹 Tốc độ xử lý:\n');
    if total_time_de < total_time_hs
        fprintf('- DE nhanh hơn HS (%.4f s vs %.4f s)\n', total_time_de, total_time_hs);
    elseif total_time_hs < total_time_de
        fprintf('- HS nhanh hơn DE (%.4f s vs %.4f s)\n', total_time_hs, total_time_de);
    else
        fprintf('- Hai thuật toán có tốc độ tương đương\n');
    end
    
    %% HIỂN THỊ ẢNH SO SÁNH
    figure('Name', sprintf('So sánh DE vs HS - %s', img_name), 'Position', [100, 100, 1400, 800]);
    
    % Ảnh gốc
    subplot(2, 3, 1);
    imshow(uint8(img));
    title('Ảnh gốc');
    xlabel(sprintf('%dx%d pixels', size(img,1), size(img,2)));
    
    % DE results
    subplot(2, 3, 2);
    imshow(uint8(stego_img_de));
    title('DE - Stego Image');
    xlabel(sprintf('PSNR: %.2f dB', psnr_de));
    
    subplot(2, 3, 3);
    imshow(uint8(recovered_img_de));
    title('DE - Recovered');
    if is_reversible_de
        xlabel('Reversible: ✓');
    else
        xlabel('Reversible: ✗');
    end
    
    % HS results
    subplot(2, 3, 5);
    imshow(uint8(stego_img_hs));
    title('HS - Stego Image');
    xlabel(sprintf('PSNR: %.2f dB', psnr_hs));
    
    subplot(2, 3, 6);
    imshow(uint8(recovered_img_hs));
    title('HS - Recovered');
    if is_reversible_hs
        xlabel('Reversible: ✓');
    else
        xlabel('Reversible: ✗');
    end
    
    % Performance comparison chart
    subplot(2, 3, 4);
    categories = {'PSNR (dB)', 'Capacity (bpp × 1000)', 'Speed (1/time × 100)'};
    de_scores = [psnr_de, embedded_length_de/numel(img)*1000, 1/total_time_de*100];
    hs_scores = [psnr_hs, embedded_length_hs/numel(img)*1000, 1/total_time_hs*100];
    
    x = 1:length(categories);
    bar_width = 0.35;
    
    bar(x - bar_width/2, de_scores, bar_width, 'FaceColor', 'blue', 'DisplayName', 'DE');
    hold on;
    bar(x + bar_width/2, hs_scores, bar_width, 'FaceColor', 'red', 'DisplayName', 'HS');
    
    set(gca, 'XTick', x, 'XTickLabel', categories);
    ylabel('Điểm số');
    title('So sánh hiệu suất');
    legend('DE', 'HS');
    grid on;
    hold off;
    
    fprintf('\n✅ Demo so sánh hoàn thành!\n');
    
    %% KẾT LUẬN
    fprintf('\n🎯 KẾT LUẬN\n');
    fprintf('=====================================\n');
    
    % Determine winner for each criterion
    de_wins = 0;
    hs_wins = 0;
    
    if psnr_de > psnr_hs
        de_wins = de_wins + 1;
        fprintf('- Chất lượng ảnh: DE thắng\n');
    elseif psnr_hs > psnr_de
        hs_wins = hs_wins + 1;
        fprintf('- Chất lượng ảnh: HS thắng\n');
    else
        fprintf('- Chất lượng ảnh: Hòa\n');
    end
    
    if capacity_de > capacity_hs
        de_wins = de_wins + 1;
        fprintf('- Dung lượng giấu tin: DE thắng\n');
    elseif capacity_hs > capacity_de
        hs_wins = hs_wins + 1;
        fprintf('- Dung lượng giấu tin: HS thắng\n');
    else
        fprintf('- Dung lượng giấu tin: Hòa\n');
    end
    
    if total_time_de < total_time_hs
        de_wins = de_wins + 1;
        fprintf('- Tốc độ xử lý: DE thắng\n');
    elseif total_time_hs < total_time_de
        hs_wins = hs_wins + 1;
        fprintf('- Tốc độ xử lý: HS thắng\n');
    else
        fprintf('- Tốc độ xử lý: Hòa\n');
    end
    
    fprintf('\n🏆 TỔNG KẾT: ');
    if de_wins > hs_wins
        fprintf('DE vượt trội hơn (%d vs %d)\n', de_wins, hs_wins);
    elseif hs_wins > de_wins
        fprintf('HS vượt trội hơn (%d vs %d)\n', hs_wins, de_wins);
    else
        fprintf('Hòa (%d vs %d)\n', de_wins, hs_wins);
    end
    
    fprintf('=====================================\n');
end
