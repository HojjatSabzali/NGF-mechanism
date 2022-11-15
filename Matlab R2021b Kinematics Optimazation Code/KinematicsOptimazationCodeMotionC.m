clc;clear;close all;
format compact

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Hojjat Sabzali                  %
% Full Facturial Test For Get a&b Ellipse Variable  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load('sc.mat');
load('ICORM.mat');
ICORF = ICORM;

nax = 22; %number of attempts for each x %%%%%%%%%%%%%%%%%%%  22 & 54 check every ( 2.5 mm)
nay = 54; %number of attempts for each y  %%%%%%%%%%%%%%%%%%%

% ICOR = ICOR*15/100;
% Theta = deg2rad(160) ; %Insert deg of J
%% Prepare ICOR Data

ICORF = ICORF * (271/(3.647292606636859e+02));

Th = 27*(pi/180); %%%%%%%%%%%%%%%%%%%% 39 digree
Rm = [cos(Th) -sin(Th);sin(Th) cos(Th)];

ICORF = Rm * ICORF';
ICORF = ICORF';

plot(ICORF(:,1),ICORF(:,2))
axis equal

ICORF(:,1) = ICORF(:,1)*(-1);
ICORF = ICORF(1:8,:); %%%%%%%%%%%%%%%%%
ICOR = ICORF;
%plot(ICORF(:,1),ICORF(:,2))
%% Crop Data after max(ICOR x) to calculate precise Error

[mxi,axi] = max(ICOR(:,1));

ICOR = ICOR(1:axi,:);


%% Calculate

[mi,ai] = min(ICOR);
xc = ICOR(ai(1,2),1); %Locate (x,y) of ellipse center
yc = max(ICOR(:,2));

% syms y_c
%
% y1 = ICOR(1,2)   ;x1 = ICOR(1,1) ;
% y2 = ICOR(end,2) ;x2 = ICOR(end,1) ;
%
% m1 = (y_c-y1)/(xc-x1) ;
% m2 = (y2-y_c)/(x2-xc) ;
%
% eqn1 = atan2((y_c-y1),(xc-x1)) - atan2((y2-y_c),(x2-xc)) == pi-Theta ;
%
% sol1 = solve(eqn1);
% yc = double(sol1);



ICOR(:,1)=ICOR(:,1)-xc; %Center the j on (0,0) = Center of ellipse is (0,0)
ICOR(:,2)=ICOR(:,2)-yc;

Range_xs = abs(min(ICOR(:,1)))-(0.7*abs(min(ICOR(:,1)))); %%%%%%%%%%%
Range_ys = abs(min(ICOR(:,2)))-(0.4*abs(min(ICOR(:,2)))); %%%%%%%%%%%%%

Range_xf = abs(min(ICOR(:,1)))+(0.7*abs(min(ICOR(:,1)))); %%%%%%%%%%%
Range_yf = abs(min(ICOR(:,2)))+(0.4*abs(min(ICOR(:,2)))); %%%%%%%%%%

A = Range_xs:(Range_xf-Range_xs)/(nax-1):Range_xf; %range of x ( Investigate range 20%)
B = Range_ys:(Range_yf-Range_ys)/(nay-1):Range_yf; %range of y ( Investigate range 20%)

%% Calculate Error

syms R

LEF = zeros(size(A,2),size(B,2));
disp(['Number of attempts (i) = ' num2str(size(A,2)*size(B,2))])
h=1;
for j = 1:size(A,2)
    a = A(j);
    for k = 1:size(B,2)
        b = B(k);
        LEijk = 0 ;
        disp(['i = ' num2str(h)])
        for i = 1:size(ICOR,1)

            dx = (ICOR(i,1)) ; dy = (ICOR(i,2)) ;

            te = atan2d(dy,dx);
            if (te < 0)
                te = 360+te;
            end

            eqn2 = ( (( R*cosd(te) )^2) / (a^2) ) + ( (( R*sind(te) )^2) / (b^2) ) == 1 ; %Equation of ellipse

            sol2 = solve(eqn2);
            Ri = double(max(sol2)); %

            xi = Ri*cosd(te)  ; yi = Ri*sind(te) ; %

            LEi = pdist([ICOR(i,1),ICOR(i,2);xi,yi],'euclidean');
            LEijk = LEi+LEijk; % Final Length Error

        end
        LEF(j,k)= LEijk; % Store Totall Error
        h = h+1;
    end
end

figure('Name','Totall Error Trend','NumberTitle','off')
plot(1:size(LEF,1)*size(LEF,2),reshape(LEF',[],1))

[mi2,ai2]=min(LEF);
[mi3,ai3]=min(mi2);
k = ai3;
[mi4,ai4]=min(LEF');
[mi5,ai5]=min(mi4);
j = ai5;


a = A(j)
b = B(k)

figure(k+1*j)
hold on
axis equal
plot(ICOR(:,1),ICOR(:,2),'k.')
plot(ICOR(:,1),ICOR(:,2),'r')
plot(0,0,'rx')

%LE_F = 0;

dx = (ICOR(end,1)) ; dy = (ICOR(end,2)) ;

tet = 180:1:atan2d(dy,dx)+360;

for i = 1:size(tet,2)%size(ICOR,1)

    %dx = (ICOR(i,1)) ; dy = (ICOR(i,2)) ;

    te = tet(i);%atan2d(dy,dx);
    if (te<0)
        te = 360+te;
    end

    eqn2 = ( (( R*cosd(te) )^2) / (a^2) ) + ( (( R*sind(te) )^2) / (b^2) ) == 1 ; %Equation of ellipse

    sol2 = solve(eqn2);
    Ri = double(max(sol2)); %

    xi = Ri*cosd(te)  ; yi = Ri*sind(te) ; %

%     LEi = pdist([ICOR(i,1),ICOR(i,2);xi,yi],'euclidean');
%     LE_F = LEi+LE_F; % Final Length Error

    figure(k+1*j)
    plot (xi,yi,'b.')
%     plot([ICOR(i,1),xi],[ICOR(i,2),yi])
    pause(0.05)
end
figure(k+1*j)
axis equal
title(['Totall Error = ' num2str(LEF(j,k))])

% % Output
%
% IC = zeros(size(ICOR,1),1);
% ICORF=[ICOR IC];
% writematrix(ICORF, "ICORellipse.txt");



