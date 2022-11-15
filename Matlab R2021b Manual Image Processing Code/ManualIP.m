clc;clear;close all;

%% Inputs

AF = 86 ; % Frist frame (This frame is considered in the calculations.)
TF = 184 ; % Finall frame (This frame is considered in the calculations.)
TT = TF - AF + 1 ; % Totall number of frames considered.
Rez = 512; % Resolution of picture   Rez*Rez (Example: 512*512 pixel)

rawdata = zeros(TT,10);
x = zeros(1,4);
y = zeros(1,4);

t = 0; % Start Time
dt = 1/15; % Time Increment (Calculate From FPS of the Video)

%% Manual Image Processing section

i = 1;

while i <= TT

    img = imread(sprintf('XA0001_0%03d.png',i+AF-1)); % Read frame in i try

    rawdata(i,1) = i; % The number of the selected frame
    rawdata(i,2) = t; % The time of occurrence of this frame
    
    f = figure;
    imshow(img)
    hold on
    f.WindowState = 'maximized'; % Make figure fullscreen
    A = ['Frame  ', num2str(i),'/',num2str(TT)];
    title(A)
    
    for j = 1:4

        [x(j),y(j)] = ginput(1);
        
        rawdata(i,2+(2*j-1)) =x(j); % Storage x(j)
        rawdata(i,2+(2*j)) = Rez - y(j); % Storage y(j): it should be substract to Rez becuse of Wrong locating (0,0) in imshow

        plot(x(j),y(j),'.r','markersize',10); % plot selected point
       
    end

    if i == 1 %% Save First Frame as a Refrence
        saveas(f,sprintf('1Ref.png'));
    else
    end

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
