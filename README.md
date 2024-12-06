# Simple Photo Shop - Image Processing System

## Overview
This image processing system is a MATLAB-based graphical user interface (GUI) application that offers various image processing features, such as geometric transformations, spatial enhancement, and frequency enhancement. Users can load, process, and save images using the app's interactive controls.

## Features
1. **Geometric Transformations**:
   - **Image Rotation**: Allows users to rotate the image by a specified angle.
   - **Image Scaling**: Allows users to scale the image by a given factor.

2. **Spatial Enhancement**:
   - **Brightness Adjustment**: Users can adjust the brightness of the image.
   - **Contrast Adjustment**: Users can adjust the contrast of the image.

3. **Frequency Enhancement**:
   - **Low Pass Filter**: Apply a Gaussian filter for low-frequency enhancement.
   - **High Pass Filter**: Apply a Sobel filter for high-frequency enhancement.

## Functions
- **Main Program**: `SimplePhotoshop`
- **Rotate Function**: `myRotateImage`
- **Generate Sobel Filter Function**: `my_sobel_filter`
- **Edge Padding Function**: `my_padarray`
- **Rescaling Function**: `my_img_resize`
- **Filter Matrix Convolution Function**: `my_imfilter`
- **Image Space Enhancement Function**: `my_imadjust`
- **Generate Gaussian Filter Function**: `my_gaussian_filter`

## Main Code
```matlab
classdef SimplePhotoshop < matlab.apps.AppBase

    % Properties corresponding to application components
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
        
        OriginalImage              % Store original image
        ProcessedImage             % Store processed image
    end

    methods (Access = private)
        
        % Callback function: LoadImageButton
        function LoadImage(app, event)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
            if isequal(file,0)
                return;
            end
            app.OriginalImage = imread(fullfile(path, file));
            app.ProcessedImage = app.OriginalImage;
            imshow(app.OriginalImage, 'Parent', app.ImageAxes);
        end
        
        % Callback function: SaveImageButton
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
        
        % Callback function: ImageRotationButton
        function RotateImage(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            angle = inputdlg('Enter Rotation Angle:', 'Rotate Image');
            if isempty(angle)
                return;
            end
            app.ProcessedImage = myRotateImage(app.OriginalImage, str2double(angle{1}));
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % Callback function: ImageScalingButton
        function ScaleImage(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            scale = inputdlg('Enter Scaling Factor:', 'Scale Image');
            if isempty(scale)
                return;
            end
            app.ProcessedImage = my_img_resize(app.OriginalImage, str2double(scale{1}));
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % Callback function: BrightnessAdjustmentSlider
        function AdjustBrightness(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            value = app.BrightnessAdjustmentSlider.Value;
            app.ProcessedImage = my_imadjust(app.OriginalImage, 1, value);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % Callback function: ContrastAdjustmentSlider
        function AdjustContrast(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            value = app.ContrastAdjustmentSlider.Value;
            app.ProcessedImage = my_imadjust(app.OriginalImage, value, 0);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % Callback function: LowPassFilterButton
        function LowPassFilter(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            h = my_gaussian_filter(5, 2);
            app.ProcessedImage = my_imfilter(app.OriginalImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
        
        % Callback function: HighPassFilterButton
        function HighPassFilter(app, event)
            if isempty(app.OriginalImage)
                return;
            end
            h = my_sobel_filter();
            app.ProcessedImage = my_imfilter(app.OriginalImage, h);
            imshow(app.ProcessedImage, 'Parent', app.ImageAxes);
        end
    end

    % App initialization and construction
    methods (Access = public)

        % Constructor for the application
        function app = SimplePhotoshop()
            createComponents(app)
            registerApp(app, app.UIFigure)
        end

        % Cleanup code before app is deleted
        function delete(app)
            delete(app.UIFigure)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 800 480];
            app.UIFigure.Name = 'Simple Photoshop';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            title(app.ImageAxes, 'Image')
            app.ImageAxes.Position = [190 61 600 400];

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImage, true);
            app.LoadImageButton.Position = [500 16 100 22];
            app.LoadImageButton.Text = 'Load Image';

            % Create SaveImageButton
            app.SaveImageButton = uibutton(app.UIFigure, 'push');
            app.SaveImageButton.ButtonPushedFcn = createCallbackFcn(app, @SaveImage, true);
            app.SaveImageButton.Position = [331 16 100 22];
            app.SaveImageButton.Text = 'Save Image';

            % Create GeometricTransformPanel
            app.GeometricTransformPanel = uipanel(app.UIFigure);
            app.GeometricTransformPanel.Title = 'Geometric Transformation';
            app.GeometricTransformPanel.Position = [10 270 120 100];

            % Create ImageRotationButton
            app.ImageRotationButton = uibutton(app.GeometricTransformPanel, 'push');
            app.ImageRotationButton.ButtonPushedFcn = createCallbackFcn(app, @RotateImage, true);
            app.ImageRotationButton.Position = [11 40 100 22];
            app.ImageRotationButton.Text = 'Rotate Image';

            % Create ImageScalingButton
            app.ImageScalingButton = uibutton(app.GeometricTransformPanel, 'push');
            app.ImageScalingButton.ButtonPushedFcn = createCallbackFcn(app, @ScaleImage, true);
            app.ImageScalingButton.Position = [11 10 100 22];
            app.ImageScalingButton.Text = 'Scale Image';

            % Create SpatialEnhancementPanel
            app.SpatialEnhancementPanel = uipanel(app.UIFigure);
            app.SpatialEnhancementPanel.Title = 'Spatial Enhancement';
            app.SpatialEnhancementPanel.Position = [10 160 170 100];

            % Create BrightnessAdjustmentSlider
            app.BrightnessAdjustmentSlider = uislider(app.SpatialEnhancementPanel);
            app.BrightnessAdjustmentSlider.Limits = [-1 1];
            app.BrightnessAdjustmentSlider.ValueChangedFcn = createCallbackFcn(app, @AdjustBrightness, true);
            app.BrightnessAdjustmentSlider.Position = [11 60 150 3];
            app.BrightnessAdjustmentSlider.Value = 0;

            % Create ContrastAdjustmentSlider
            app.ContrastAdjustmentSlider = uislider(app.SpatialEnhancementPanel);
            app.ContrastAdjustmentSlider.Limits = [0 1];
            app.ContrastAdjustmentSlider.ValueChangedFcn = createCallbackFcn(app, @AdjustContrast, true);
            app.ContrastAdjustmentSlider.Position = [11 30 150 3];
            app.ContrastAdjustmentSlider.Value = 0.5;

            % Create FrequencyEnhancementPanel
            app.FrequencyEnhancementPanel = uipanel(app.UIFigure);
            app.FrequencyEnhancementPanel.Title = 'Frequency Enhancement';
            app.FrequencyEnhancementPanel.Position = [10 50 120 100];

            % Create LowPassFilterButton
            app.LowPassFilterButton = uibutton(app.FrequencyEnhancementPanel, 'push');
            app.LowPassFilterButton.ButtonPushedFcn = createCallbackFcn(app, @LowPassFilter, true);
            app.LowPassFilterButton.Position = [11 40 100 22];
            app.LowPassFilterButton.Text = 'Low Pass Filter';

            % Create HighPassFilterButton
            app.HighPassFilterButton = uibutton(app.FrequencyEnhancementPanel, 'push');
            app.HighPassFilterButton.ButtonPushedFcn = createCallbackFcn(app, @HighPassFilter, true);
            app.HighPassFilterButton.Position = [11 10 100 22];
            app.HighPassFilterButton.Text = 'High Pass Filter';

            % Make the UIFigure visible now that the components are created
            app.UIFigure.Visible = 'on';
        end
    end
end
