% concatenating two images
%
% 2019, Alexander Heimel

%% top 
imtop = imread('Mark_Rutte_2015_(1).jpg');
imtop = mean(imtop,3); % converting to grayscale

imtop = imtop(1:600,:);
imtop = imresize(imtop,[600 1000]);
imagesc(imtop)
axis image
colormap gray

%% bottom
imbot = imread('kim.jpg');
imbot = mean(imbot,3);
imbot = imbot(1200:2:end,round(linspace(1,end,1000)));
imagesc(imbot)
axis image
colormap gray

%% concatenate
imcat = [imtop;imbot];


imcat(imcat>230) = mode(imtop(:));
imagesc(imcat)
axis image off


