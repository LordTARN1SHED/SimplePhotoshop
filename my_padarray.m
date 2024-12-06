function paddedImage = my_padarray(image, padSizeY, padSizeX)
    % image 是输入的图像
    % padSizeY 和 padSizeX 是垂直和水平方向的填充尺寸
    
    % 获取图像尺寸
    [imageHeight, imageWidth, ~] = size(image);
    
    % 创建一个更大的零矩阵
    paddedImage = zeros(imageHeight + 2*padSizeY, imageWidth + 2*padSizeX, 'like', image);
    
    % 将原始图像放置在零矩阵的中心
    paddedImage(padSizeY+1:padSizeY+imageHeight, padSizeX+1:padSizeX+imageWidth, :) = image;
end
