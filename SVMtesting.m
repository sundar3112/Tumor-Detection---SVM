
% Training the model with the features dataset
disp(newline)
disp(newline)
disp('Training Model...');
T = readtable('/MATLAB Drive/Features.csv');
SVMModel= fitcsvm(T,'tumour','KernelFunction','rbf',...
    'Standardize',true,'Classnames',{'0','1'});
disp('SVM Model Trained');


% Finding the features of the target image
disp('Aquiring target image...');
%i = imread('/MATLAB Drive/Target_images/malignant/malignant_1.jpg');
i = imread('/MATLAB Drive/Biological Database Project - Tumor Detection/Target_images/Target_images/malignant/malignant_2.jpg');
disp('Target image aquired');
disp('Processing image...');

if size(i,3)==3
i = rgb2gray(i);
end

figure(1)
subplot(2,2,1);
imshow(i);
title('Target Image');

ia = imadjust(i); %enhancement
subplot(2,2,2);
imshow(ia);
title('Enhanced Image');
disp('enhancement done');

it = imbinarize(ia,0.75); %segmentation
subplot(2,2,3);
imshow(it);
title('Segmented Image')
disp('segmentation done');

SE = strel('disk',9);
io = imopen(it,SE); %morphology
subplot(2,2,4);
imshow(io);
title('Post Morphological Operations')
disp('morphology done');
disp('Image processing complete');

disp('Extracting features...');
glcms = graycomatrix(io); %GLCM matrix
stats1.tumour=0;
stats2 = GLCM_Features1(glcms,0);
newX = [struct2table(stats1),struct2table(stats2)]; %contains target image features
disp('Features Extracted');


% Predicting if target image is benign or malignant
[label,score] = predict(SVMModel,newX);
disp(newline)
disp('##TEST RESULT##')
if isequal(label,{'0'})
disp('The target image has a BENIGN tumour');
elseif isequal(label,{'1'})
disp('The target image has a MALIGNANT tumour');
end
