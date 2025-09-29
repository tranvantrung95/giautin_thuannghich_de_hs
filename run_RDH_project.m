function run_RDH_project()
% RUN_RDH_PROJECT - Script chính để chạy toàn bộ project RDH
% Tự động setup và khởi chạy hệ thống GUI 3 workflow

fprintf('========================================\n');
fprintf('    HỆ THỐNG GIẤU TIN THUẬN NGHỊCH\n');
fprintf('     REVERSIBLE DATA HIDING (RDH)\n');
fprintf('     🔒 GUI 3 WORKFLOW BẢO MẬT 🔒\n');
fprintf('========================================\n\n');

try
    % Kiểm tra và thiết lập môi trường
    fprintf('1. KIỂM TRA MÔI TRƯỜNG...\n');
    
    % Kiểm tra MATLAB version
    matlab_version = version;
    fprintf('   MATLAB Version: %s\n', matlab_version);
    
    % Kiểm tra toolbox cần thiết
    try
        if license('test', 'image_toolbox')
            fprintf('   ✓ Image Processing Toolbox\n');
        else
            fprintf('   ⚠ Image Processing Toolbox (có thể chưa cài đặt)\n');
        end
    catch
        fprintf('   ⚠ Không thể kiểm tra Image Processing Toolbox\n');
    end
    
    % Kiểm tra current directory
    current_dir = pwd;
    fprintf('   Working Directory: %s\n', current_dir);
    
    % Kiểm tra files quan trọng
    fprintf('\n2. KIỂM TRA FILES DỰ ÁN...\n');
    
    project_files = {
        'RDH_GUI_3Part.m',        % GUI chính
        'embed_DE.m',             % Thuật toán DE 
        'extract_DE.m',
        'embed_HS.m',             % Thuật toán HS
        'extract_HS.m', 
        'text_to_binary.m',       % Text processing
        'binary_to_text.m',
        'calculate_psnr.m',       % Utilities
        'create_demo_image.m',
        'README.md'               % Tài liệu
    };
    
    all_files_exist = true;
    for i = 1:length(project_files)
        if exist(project_files{i}, 'file') == 2
            fprintf('   ✓ %s\n', project_files{i});
        else
            fprintf('   ✗ %s (MISSING)\n', project_files{i});
            all_files_exist = false;
        end
    end
    
    if ~all_files_exist
        error('Một số file quan trọng bị thiếu. Vui lòng kiểm tra lại project.');
    end
    
    % Test cơ bản
    fprintf('\n3. KIỂM TRA CHỨC NĂNG CƠ BẢN...\n');
    
    % Test tạo ảnh demo
    try
        demo_img = create_demo_image();
        fprintf('   ✓ Tạo ảnh demo\n');
    catch err
        fprintf('   ✗ Lỗi tạo ảnh demo: %s\n', err.message);
        return;
    end
    
    % Test chuyển đổi text (với encoding mới)
    try
        test_text = 'Hello RDH! Xin chào!';
        binary_data = text_to_binary(test_text);
        recovered_text = binary_to_text(binary_data);
        if strcmp(test_text, recovered_text)
            fprintf('   ✓ Chuyển đổi text/binary (16-bit encoding)\n');
        else
            fprintf('   ✗ Lỗi chuyển đổi text/binary\n');
        end
    catch err
        fprintf('   ✗ Lỗi test text/binary: %s\n', err.message);
    end
    
    % Test thuật toán HS (khuyến nghị)
    try
        secret_bits = text_to_binary('Test HS');
        [watermarked, info] = embed_HS(demo_img, secret_bits);
        [recovered, extracted] = extract_HS(watermarked, info);
        if isequal(demo_img, recovered)
            fprintf('   ✓ Thuật toán HS (Histogram Shifting)\n');
        else
            fprintf('   ✗ Lỗi thuật toán HS\n');
        end
    catch err
        fprintf('   ✗ Lỗi test HS: %s\n', err.message);
    end
    
    % Test thuật toán DE
    try
        secret_bits = text_to_binary('Test DE');
        [watermarked, info] = embed_DE(demo_img, secret_bits);
        [recovered, extracted] = extract_DE(watermarked, info);
        if isequal(demo_img, recovered)
            fprintf('   ✓ Thuật toán DE (Difference Expansion)\n');
        else
            fprintf('   ✗ Lỗi thuật toán DE\n');
        end
    catch err
        fprintf('   ✗ Lỗi test DE: %s\n', err.message);
    end
    
    % Hướng dẫn sử dụng
    fprintf('\n4. HƯỚNG DẪN SỬ DỤNG\n');
    fprintf('=====================================\n\n');
    
    fprintf('🔒 CHỨC NĂNG CHÍNH - 3 WORKFLOW BẢO MẬT:\n');
    fprintf('   • Tab 1 - GIẤU TIN: Nhúng dữ liệu vào ảnh\n');
    fprintf('   • Tab 2 - TRÍCH XUẤT: Lấy dữ liệu từ ảnh đã giấu tin\n');
    fprintf('   • Tab 3 - KHÔI PHỤC: Khôi phục ảnh gốc hoàn hảo\n');
    fprintf('   • Bảo mật 2 lớp: Ảnh + File embed info\n');
    fprintf('   • Hỗ trợ tiếng Việt đầy đủ\n\n');
    
    fprintf('🧮 THUẬT TOÁN:\n');
    fprintf('   • HS (Histogram Shifting) - Khuyến nghị: PSNR cao\n');
    fprintf('   • DE (Difference Expansion) - Dự phòng: Capacity lớn\n\n');
    
    fprintf('🚀 WORKFLOW:\n');
    fprintf('   1. Tab 1: Ảnh gốc + Dữ liệu → Ảnh giấu tin + File embed\n');
    fprintf('   2. Tab 2: Ảnh giấu tin + File embed → Dữ liệu bí mật\n');
    fprintf('   3. Tab 3: Ảnh giấu tin + File embed → Ảnh gốc khôi phục\n\n');
    
    fprintf('📖 TÀI LIỆU:\n');
    fprintf('   • Đọc file README.md\n');
    fprintf('   • Test với ảnh Demo trong GUI\n');
    fprintf('   • Thử với ảnh riêng của bạn\n\n');
    
    % Tùy chọn khởi chạy
    fprintf('🎯 LỰA CHỌN TIẾP THEO:\n');
    fprintf('========================================\n');
    
    % Prompt user choice
    fprintf('\nBạn muốn làm gì tiếp theo?\n');
    fprintf('1. 🚀 Chạy GUI ngay (Khuyến nghị)\n');
    fprintf('2. 📖 Xem tài liệu README\n');
    fprintf('3. 👋 Thoát\n\n');
    
    choice = input('Nhập lựa chọn (1-3): ');
    
    switch choice
        case 1
            fprintf('\n🚀 Đang khởi chạy GUI 3 Workflow...\n');
            fprintf('💡 Hãy bắt đầu với Tab 1 - GIẤU TIN!\n\n');
            RDH_GUI_3Part;
            
        case 2
            fprintf('\n📖 Mở file README...\n');
            if exist('README.md', 'file')
                edit README.md;
            else
                fprintf('File README không tồn tại.\n');
            end
            
        case 3
            fprintf('\n👋 Cảm ơn bạn đã sử dụng RDH System!\n');
            
        otherwise
            fprintf('\n⚠️ Lựa chọn không hợp lệ. Khởi chạy GUI mặc định...\n');
            RDH_GUI_3Part;
    end
    
    fprintf('\n========================================\n');
    fprintf('     🎯 RDH SYSTEM - SẴN SÀNG SỬ DỤNG!\n');
    fprintf('========================================\n');
    
catch err
    fprintf('\n❌ LỖI TỔNG QUÁT: %s\n', err.message);
    fprintf('\nStack trace:\n');
    for i = 1:length(err.stack)
        fprintf('   %s (line %d)\n', err.stack(i).name, err.stack(i).line);
    end
    fprintf('\nVui lòng kiểm tra lại cài đặt và thử lại.\n');
    fprintf('💡 Gợi ý: Chạy trực tiếp RDH_GUI_3Part nếu gặp lỗi.\n');
end
end