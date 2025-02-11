[fileName, filePath] = uigetfile({'*.png;*.jpg;*.jpeg;*.gif', 'Supported File Types'; '*.*', 'All Files'}, 'Select Image File');

if isequal(fileName, 0)
    disp('The transaction was canceled.');
    return;
end

imagePath = fullfile(filePath, fileName);
a = imread(imagePath);
a = imresize(a, [227 227]);

[out, score] = classify(net, a);

figure;
imshow(a);
title(string(out));