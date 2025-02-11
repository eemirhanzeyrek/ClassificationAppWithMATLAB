function myGUI

    screenSize = get(0, 'ScreenSize');
    windowWidth = 600;
    windowHeight = 400;
    windowPosition = [(screenSize(3) - windowWidth) / 2, (screenSize(4) - windowHeight) / 2, windowWidth, windowHeight];

    hFig = figure('Position', windowPosition, 'Name', 'Model Selection and Result Display', 'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', 'Resize', 'off');  

    hButtonGroup = uibuttongroup('Parent', hFig, 'Position', [0.02, 0.1, 0.3, 0.8]);

    hRadiobutton1 = uicontrol(hButtonGroup, 'Style', 'radiobutton', 'String', 'Cancer Recognition', ...
                              'Position', [10, 200, 150, 30], 'Value', 1);
    
    hRadiobutton2 = uicontrol(hButtonGroup, 'Style', 'radiobutton', 'String', 'Transfer Learning', ...
                              'Position', [10, 170, 150, 30]);

    hButton = uicontrol('Parent', hFig, 'Style', 'pushbutton', 'String', 'Select Image', ...
                       'Position', [44, 60, 120, 30], 'Callback', @selectImage);
                     
    hAxes = axes('Parent', hFig, 'Position', [0.4, 0.1, 0.55, 0.8]);

    try
        loadedData = load('trainedNetwork_cancerRecognition.mat', 'net'); 
        netRecognition = loadedData.net;
        
        loadedData = load('trainedNetwork_cancerTransfer.mat', 'net'); 
        netTransfer = loadedData.net;
    catch
        error('An error occurred while loading trained models.');
    end

    function selectImage(~, ~)
        [fileName, filePath] = uigetfile({'*.png;*.jpg;*.jpeg;*.gif', 'Supported File Types'; '*.*', 'All Files'}, 'Select Image File');

        if isequal(fileName, 0)
            disp('The transaction was canceled.');
            return;
        end
        
        imagePath = fullfile(filePath, fileName);
        img = imread(imagePath);
        img = imresize(img, [227, 227]);

        if get(hRadiobutton1, 'Value') 
            [out, ~] = classify(netRecognition, img);
        elseif get(hRadiobutton2, 'Value') 
            [out, ~] = classify(netTransfer, img);
        else
            disp('Invalid model selection.');
            return;
        end

        imshow(img, 'Parent', hAxes);
        title(hAxes, out);
    end
end