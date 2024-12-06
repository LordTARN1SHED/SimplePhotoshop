function adjustedImage = my_imadjust(image, contrast, brightness)
    % 默认情况下对比度和亮度不变
    if nargin < 2 || isempty(contrast)
        contrast = 1;
    end
    if nargin < 3 || isempty(brightness)
        brightness = 0;
    end
    
    % 将图像归一化到 [0, 1] 范围
    normalizedImage = double(image) / 255;
    
    % 调整对比度
    adjustedImage = contrast * (normalizedImage - 0.5) + 0.5;
    
    % 调整亮度
    adjustedImage = adjustedImage + brightness;
    
    % 限制像素值在 [0, 1] 范围内
    adjustedImage = min(max(adjustedImage, 0), 1);
    
    % 将调整后的图像重新缩放到 [0, 255] 范围，并转换为 uint8 类型
    adjustedImage = uint8(255 * adjustedImage);
end
