classdef SimplePhotoshop < matlab.apps.AppBase

    % 属性对应于应用程序组件
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        LoadImageButton            matlab.ui.control.Button
        SaveImageButton            matlab.ui.control.Button
        GeometricTransformPanel    matlab.ui.container.Panel
        ImageRotationButton        matlab.ui.control.Button
        ImageScalingButton         matlab.ui.control.Button
        SpatialEnhancementPanel    matlab.ui.container.Panel
        BrightnessAdjustmentSlider matlab.ui.control.Slider
        ContrastAdjustmentSlider   matlab.ui.control.Slider
        FrequencyEnhancementPanel  matlab.ui.container.Panel
        LowPassFilterButton        matlab.ui.control.Button
        HighPassFilterButton       matlab.ui.control.Button
        ImageAxes                  matlab.ui.control.UIAxes
        
        OriginalImage              % 存储原始图像
        ProcessedImage             % 存储处理后的图像

    end

    methods (Access = private)
        
        % 回调函数: LoadImageButton
        function LoadImage(app, event)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
            if isequal(file,0)
                return;
            end
            app.OriginalImage = imread(fullfile(path, file));
            app.ProcessedImage = app.OriginalImage;
            imshow(app.OriginalImage, 'Parent', app.ImageAxes);
        end
        
        % 回调函数: SaveImageButton
        function SaveImage(app, event)
            if isempty(app.ProcessedImage)
                return;
            end
            [file, path] = uiputfile({'*.jpg;*.png;*.bmp', 'Image Files'});
            if isequal(file,0)
                return;
            end
            imwrite(app.ProcessedImage, fullfile(path, file));
        end
        
        % 回调函数: ImageRotationButton
        function RotateImage(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            angle = inputdlg('输入旋转角度:','旋转图像');
            if isempty(angle)
                return;
            end
            app.ProcessedImage = myRotateImage(app.OriginalImage, str2double(angle{1}));
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % 回调函数: ImageScalingButton
        function ScaleImage(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            scale = inputdlg('输入缩放因子:','缩放图像');
            if isempty(scale)
                return;
            end
            app.ProcessedImage = my_img_resize(app.OriginalImage, str2double(scale{1}));
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % 回调函数: BrightnessAdjustmentSlider
        function AdjustBrightness(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            value = app.BrightnessAdjustmentSlider.Value;
            app.ProcessedImage = my_imadjust(app.OriginalImage, 1, value);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % 回调函数: ContrastAdjustmentSlider
        function AdjustContrast(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            value = app.ContrastAdjustmentSlider.Value;
            app.ProcessedImage = my_imadjust(app.OriginalImage, value, 0);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % 回调函数: LowPassFilterButton
        function LowPassFilter(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            h = my_gaussian_filter(5, 2);
            app.ProcessedImage = my_imfilter(app.OriginalImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % 回调函数: HighPassFilterButton
        function HighPassFilter(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            h = my_sobel_filter();
            app.ProcessedImage = my_imfilter(app.OriginalImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
    end

    % 应用程序初始化和构造
    methods (Access = public)

        % 构造应用程序
        function app = SimplePhotoshop()

            % 创建和配置组件
            createComponents(app)

            % 将应用程序注册到 App Designer
            registerApp(app, app.UIFigure)
        end

        % 在应用程序删除之前执行的代码
        function delete(app)
            delete(app.UIFigure)
        end
    end

    % 组件初始化
    methods (Access = private)

        % 创建 UIFigure 和组件
        function createComponents(app)

            % 创建 UIFigure 并在创建所有组件之前隐藏
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 800 480];
            app.UIFigure.Name = 'Simple Photoshop';

            % 创建 ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            title(app.ImageAxes, '图像')
            app.ImageAxes.Position = [190 61 600 400];

            % 创建 LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImage, true);
            app.LoadImageButton.Position = [500 16 100 22];
            app.LoadImageButton.Text = '加载图像';

            % 创建 SaveImageButton
            app.SaveImageButton = uibutton(app.UIFigure, 'push');
            app.SaveImageButton.ButtonPushedFcn = createCallbackFcn(app, @SaveImage, true);
            app.SaveImageButton.Position = [331 16 100 22];
            app.SaveImageButton.Text = '保存图像';

            % 创建 GeometricTransformPanel
            app.GeometricTransformPanel = uipanel(app.UIFigure);
            app.GeometricTransformPanel.Title = '几何变换';
            app.GeometricTransformPanel.Position = [10 270 120 100];

            % 创建 ImageRotationButton
            app.ImageRotationButton = uibutton(app.GeometricTransformPanel, 'push');
            app.ImageRotationButton.ButtonPushedFcn = createCallbackFcn(app, @RotateImage, true);
            app.ImageRotationButton.Position = [11 40 100 22];
            app.ImageRotationButton.Text = '旋转图像';

            % 创建 ImageScalingButton
            app.ImageScalingButton = uibutton(app.GeometricTransformPanel, 'push');
            app.ImageScalingButton.ButtonPushedFcn = createCallbackFcn(app, @ScaleImage, true);
            app.ImageScalingButton.Position = [11 10 100 22];
            app.ImageScalingButton.Text = '缩放图像';

            % 创建 SpatialEnhancementPanel
            app.SpatialEnhancementPanel = uipanel(app.UIFigure);
            app.SpatialEnhancementPanel.Title = '空间增强';
            app.SpatialEnhancementPanel.Position = [10 160 170 100];

            % 创建 BrightnessAdjustmentSlider
            app.BrightnessAdjustmentSlider = uislider(app.SpatialEnhancementPanel);
            app.BrightnessAdjustmentSlider.Limits = [-1 1];
            app.BrightnessAdjustmentSlider.ValueChangedFcn = createCallbackFcn(app, @AdjustBrightness, true);
            app.BrightnessAdjustmentSlider.Position = [11 60 150 3];
            app.BrightnessAdjustmentSlider.Value = 0;

            % 创建 ContrastAdjustmentSlider
            app.ContrastAdjustmentSlider = uislider(app.SpatialEnhancementPanel);
            app.ContrastAdjustmentSlider.Limits = [0 1];
            app.ContrastAdjustmentSlider.ValueChangedFcn = createCallbackFcn(app, @AdjustContrast, true);
            app.ContrastAdjustmentSlider.Position = [11 30 150 3];
            app.ContrastAdjustmentSlider.Value = 0.5;

            % 创建 FrequencyEnhancementPanel
            app.FrequencyEnhancementPanel = uipanel(app.UIFigure);
            app.FrequencyEnhancementPanel.Title = '频率增强';
            app.FrequencyEnhancementPanel.Position = [10 50 120 100];

            % 创建 LowPassFilterButton
            app.LowPassFilterButton = uibutton(app.FrequencyEnhancementPanel, 'push');
            app.LowPassFilterButton.ButtonPushedFcn = createCallbackFcn(app, @LowPassFilter, true);
            app.LowPassFilterButton.Position = [11 40 100 22];
            app.LowPassFilterButton.Text = '低通滤波';

            % 创建 HighPassFilterButton
            app.HighPassFilterButton = uibutton(app.FrequencyEnhancementPanel, 'push');
            app.HighPassFilterButton.ButtonPushedFcn = createCallbackFcn(app, @HighPassFilter, true);
            app.HighPassFilterButton.Position = [11 10 100 22];
            app.HighPassFilterButton.Text = '高通滤波';

            % 在创建所有组件之后显示图形
            app.UIFigure.Visible = 'on';
        end
    end
end

