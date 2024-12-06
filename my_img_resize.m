function resizedImage = my_img_resize(image, scaleFactor)
    % 获取原始图像的尺寸
    [rows, cols, channels] = size(image);
    
    % 计算调整大小后的图像尺寸
    newRows = round(rows * scaleFactor);
    newCols = round(cols * scaleFactor);
    
    % 初始化调整大小后的图像
    resizedImage = zeros(newRows, newCols, channels, 'like', image);
    
    % 计算行和列索引的缩放因子
    rowScale = rows / newRows;
    colScale = cols / newCols;
    
    % 循环遍历调整大小后的图像中的每个像素
    for i = 1:newRows
        for j = 1:newCols
            % 计算原始图像中相应像素的位置
            x = round(i * rowScale);
            y = round(j * colScale);
            
            % 确保索引在边界内
            x = max(1, min(x, rows));
            y = max(1, min(y, cols));
            
            % 将原始图像中的像素值赋给调整大小后的图像
            resizedImage(i, j, :) = image(x, y, :);
        end
    end
end
