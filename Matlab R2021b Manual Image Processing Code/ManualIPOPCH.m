clc;clear;close all;

%% Inputs

AF = 46 ; % Frist frame (This frame is considered in the calculations.)
TF = 147 ; % Finall frame (This frame is considered in the calculations.)
TT = TF - AF + 1 ; % Totall number of frames considered.
Rez = 1080; % Resolution of picture   Rez*Rez (Example: 512*512 pixel)

OPCHrawdata = zeros(TT,10);

x = zeros(1,4);
y = zeros(1,4);

t = 0; % Start Time
dt = 1/60.01; % Time Increment (Calculate From FPS of the Video)

%% Manual Image Processing section

i = 1;

while i <= TT

    img = imread(sprintf('MyMoCa%03d.png',i+AF-1)); % Read frame in i try

    OPCHrawdata(i,1) = i; % The number of the selected frame
    OPCHrawdata(i,2) = t; % The time of occurrence of this frame



    for j = 1:4

        f = figure(1);
        imshow(img(:,:,1))
        hold on
        f.WindowState = 'maximized'; % Make figure fullscreen
        A = ['Frame  ', num2str(i),'/',num2str(TT)];
        title(A)
        [cimg,rect] = imcrop(img); % rect[xmin ymin width height]
        f.WindowState = 'maximized'; % Make figure fullscreen
        clf
        imshow(cimg(:,:,1))
        f.WindowState = 'maximized'; % Make figure fullscreen
        [x(j),y(j)] = ginput(1);

        OPCHrawdata(i,2+(2*j-1)) =rect(1,1) + x(j); % Storage x(j)
        OPCHrawdata(i,2+(2*j)) = Rez - y(j) - rect(1,2); % Storage y(j): it should be substract to Rez becuse of Wrong locating (0,0) in imshow

        plot(x(j),y(j),'.r','markersize',10); % plot selected point

    end

    if i == 1 %% Save First Frame as a Refrence
        %saveas(f,sprintf('1Ref.png'));
    else
    end
    %% Plot

    close
    f = figure;
    imshow(img(:,:,1))
    hold on
    f.WindowState = 'maximized'; % Make figure fullscreen
    A = ['Frame  ', num2str(i),'/',num2str(TT)];
    title(A)
    plot(OPCHrawdata(i,3),Rez-OPCHrawdata(i,4),'.y','markersize',10); % plot selected point
    plot(OPCHrawdata(i,5),Rez-OPCHrawdata(i,6),'.y','markersize',10); % plot selected point
    plot(OPCHrawdata(i,7),Rez-OPCHrawdata(i,8),'.y','markersize',10); % plot selected point
    plot(OPCHrawdata(i,9),Rez-OPCHrawdata(i,10),'.y','markersize',10); % plot selected point

    %% Checking Question

    answer = questdlg('Is it OK?','Checking','Yes','No, Try Again This Frame','Repeat Previous Frame','No, Try Again This Frame');
    switch answer
        case 'Yes'
            i = i+1;
        case 'No, Try Again' %i = i;

        case 'Repeat Previous Frame'
            i = i-1;
    end

    t=t+dt; % Create Next Time's of frame
    close

end

% [cimg,rect] = imcrop(img);
% imshow(cimg(:,:,1))
% [centersDark, radiiDark] = imfindcircles(cimg,[5 19],'ObjectPolarity','dark')
% viscircles(centersDark, radiiDark,'Color','b');
% cimg = cimg(:,:,1);
%
% figure(4)
% hold on
% nexttile
% imshow(cimg)
% cimagf = cimg;
% nexttile
% imshow(cimagf)
% hr = 30; % Half Range
%
% for i = 1:size(cimg,1)
%     for j = 1:size(cimg,2)
%         minVal = min(min(cimg));
%         if (cimg(i,j) >= minVal-hr) && (cimg(i,j) <= minVal+hr)
%             cimagf(i,j) = 0;
%         else
%             cimagf(i,j) = 255;
%         end
%     end
% end
% imshow(cimagf)
%
% imshow(cimg)
% [centersDark, radiiDark] = imfindcircles(cimg,[6 20],'ObjectPolarity','dark')
% viscircles(centersDark, radiiDark,'Color','b');