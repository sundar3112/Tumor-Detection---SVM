
Datatable=table;

image_folder = ["/MATLAB Drive/Biological Database Project - Tumor Detection/Dataset/BRAIN TUMOUR IMAGES/benign","/MATLAB Drive/Biological Database Project - Tumor Detection/Dataset/BRAIN TUMOUR IMAGES/malignant"]
%disp(image_folder(1))
for folder_no = 1:2
    %fprintf('folder no:%d\n',folder_no)
    filenames = dir(fullfile(char(image_folder(folder_no)), '*.png'));
    total_images = numel(filenames);
    for n = 1:total_images
%         fprintf('Image no:%d',n)
%         fprintf('filenames(n).name: %s',filenames(n).name)
%         fprintf('image_folder(i): %s',image_folder(i))
        full_name= fullfile(char(image_folder(folder_no)), filenames(n).name);
        i = imread(full_name);
        %figure (n);
        %i = imread('img_2.jpg');
        if size(i,3)==3
        i = rgb2gray(i);
        end
        ia = imadjust(i); %enhancement
        subplot(2,2,1);
        imshow(ia);
        title('Enhanced Image')
        it = imbinarize(ia,0.75); %segmentation
        subplot(2,2,2);
        imshow(it);
        title('Segmented Image')
        SE = strel('disk',9);
        io = imopen(it,SE); %morphology
        subplot(2,2,3);
        imshow(io);
        title('Post Morphological Operations')
        glcms = graycomatrix(io); %GLCM matrix
        stats1.tumour=folder_no-1;
        stats2 = GLCM_Features1(glcms,0); % More GLCM features
        stats=[struct2table(stats1),struct2table(stats2)];
        Datatable = [Datatable;(stats)];
    end
end

Feature_table=Datatable
writetable(Datatable, '/MATLAB Drive/Features.csv')
writetable(Datatable, '/MATLAB Drive/Features.xlsx')
disp("Dataset Created")