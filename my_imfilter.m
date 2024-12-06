function filteredImage = my_imfilter(image, filter)
    % image 是输入的图像
    % filter 是卷积核
    
    % 获取图像和卷积核的尺寸
    [imageHeight, imageWidth, ~] = size(image);
    [filterHeight, filterWidth] = size(filter);
    
    % 零填充图像以匹配卷积核大小
    padSizeX = floor(filterWidth / 2);
    padSizeY = floor(filterHeight / 2);
    paddedImage = my_padarray(image, padSizeY, padSizeX);
    
    % 创建输出图像
    filteredImage = zeros(imageHeight, imageWidth, 'like', image);
    
    % 执行卷积操作
    for i = 1:imageHeight
        for j = 1:imageWidth
            % 提取当前像素区域并将数据类型转换为相同类型
            imageRegion = double(paddedImage(i:i+filterHeight-1, j:j+filterWidth-1));
            
            % 将图像区域与卷积核进行点乘
            filteredImage(i, j) = sum(imageRegion .* filter, 'all');
        end
    end
end
