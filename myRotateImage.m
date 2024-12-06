function rotatedImage = myRotateImage(image, angle)
    % 将角度从度转换为弧度
    angleRad = deg2rad(angle);
    
    % 获取图像的尺寸
    [rows, cols, ~] = size(image);
    
    % 计算图像中心的坐标
    centerX = cols / 2;
    centerY = rows / 2;
    
    % 计算旋转矩阵
    rotationMatrix = [cos(angleRad), -sin(angleRad); sin(angleRad), cos(angleRad)];
    
    % 对每个像素应用旋转
    rotatedImage = zeros(size(image), 'like', image); % 初始化旋转后的图像
    for y = 1:rows
        for x = 1:cols
            % 将坐标平移到中心
            translatedX = x - centerX;
            translatedY = y - centerY;
            
            % 应用旋转
            rotatedXY = rotationMatrix * [translatedX; translatedY];
            
            % 将坐标平移回去
            rotatedX = round(rotatedXY(1) + centerX);
            rotatedY = round(rotatedXY(2) + centerY);
            
            % 检查旋转后的坐标是否在边界内
            if rotatedX >= 1 && rotatedX <= cols && rotatedY >= 1 && rotatedY <= rows
                % 赋值像素值
                rotatedImage(y, x, :) = image(rotatedY, rotatedX, :);
            end
        end
    end
end
