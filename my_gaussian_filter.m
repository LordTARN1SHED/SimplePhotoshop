function h = my_gaussian_filter(size, sigma)
    % 创建一个大小为 size x size 的高斯滤波器
    % sigma 是高斯分布的标准差
    
    % 创建一个大小为 size x size 的网格，以便计算高斯分布
    [X, Y] = meshgrid(-floor(size/2):floor(size/2), -floor(size/2):floor(size/2));
    
    % 计算高斯分布
    h = exp(-(X.^2 + Y.^2) / (2*sigma^2)) / (2*pi*sigma^2);
    
    % 将滤波器归一化
    h = h / sum(h, 'all');
end
