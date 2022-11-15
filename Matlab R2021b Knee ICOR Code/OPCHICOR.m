%clear;close all;

load('OPCHZeroedData.mat');
load('KThetaF.mat');
Zerodata = data;
%clear data
format compact

%% moving average

M = movmean(Zerodata,5);

data = M;

%%

step_size = 10; %Resolution of Making ICOR Path
N_Step = round(size(data,1)/step_size)-1 ;

ICOR = zeros (N_Step,2);
ICORB = zeros (N_Step,2);
bdata = zeros (N_Step,5);
bdata(:,1) = 1:1:N_Step;

%% Plot Input

%plot Input data
% figure
% plot ( data(:,1) , data(:,2) , 'b' , data(:,1) , data(:,3) , 'r'...
%      , data(:,1) , data(:,4) , 'c' , data(:,1) , data(:,5) , 'm' )

%plot two Marker 95,96

figure(2)
axis equal
hold on

%plot(Zerodata(:,2),Zerodata(:,3),'r') %Plot Zeroed Data
%plot(Zerodata(:,4),Zerodata(:,5),'b')

plot ( data(:,2) , data(:,3) , 'b' , data(:,4) , data(:,5) , 'r' ) %PLot MovingAverage Data

for k = 1:1:5

%     Seti1 = [100   74   70    60    49    36];
%     Seti2 =[90   74];
%     Seti3 =[90   71];
%     Seti4 =[100   73];
%     Seti5 =[100   72];
   
    Seti = [100   74   70    60    49    36;90   74 0 0 0 0;90   71 0 0 0 0;100   73 0 0 0 0;100   72 0 0 0 0];
    N_Step = [5 1 1 1 1];

    for j = 1:1:N_Step(1,k)
        %% Calculation for First(1) Perpendicular Line

        disp(['j = ' num2str(j)])

        syms x1 xp1
        %i = ((j-1)*step_size) + 1 ;
        ii =Seti(k,:);%ii = [1    40    50    60    70    80    86]; Seti5;
        i = ii(1,j);
        step_size = ii(1,j+1)-ii(1,j);
        Mi = ( data(i + step_size,3) - data(i,3) ) / ( data(i + step_size,2) - data(i,2) ) ;
        y1 = ( Mi * ( x1 - data(i + step_size,2) )) + data(i + step_size,3) ; %function of First(1) Base Line in i Try
        if data(i + step_size,2) < data(i,2)
            fplot(y1,[data(i + step_size,2) data(i,2)],'k') %plot the First(1) Base Line in i Try
        else
            fplot(y1,[data(i,2) data(i + step_size,2)],'k') %plot the First(1) Base Line in i Try
        end

        bdata(j,2) = data(i,2); %x1
        bdata(j,3) = data(i,3); %y1
        %plot(bdata(j,2),bdata(j,3),'r*') %%%%%%%%%%%%%%%

        Xi_1 = data(i,2); Yi_1 = data(i,3);Xi_2 = data(i + step_size,2); Yi_2 = data(i + step_size,3);
        plot(Xi_1,Yi_1,'ko');plot(Xi_2,Yi_2,'k.'); %plot the Two o Dots for First(1) Base Line in i Try

        X_MPi = ( ((data(i + step_size,2)-data(i,2))/2)+data(i,2) ) ; Y_MPi = ( ((data(i + step_size,3)-data(i,3))/2)+data(i,3) );
        plot(X_MPi,Y_MPi,'r*') %Plot (MP)Middle Point for First(1) Base Line of i try

        yp1 = ( (-1/Mi) * ( xp1 - X_MPi )) + Y_MPi ; %function of First(1) Perpendicular Line in i Try

        %% Calculation for Second(2) Perpendicular Line

        syms x2 xp2

        Mi2 = ( data(i + step_size,5) - data(i,5) ) / ( data(i + step_size,4) - data(i,4) ) ;
        y2 = ( Mi2 * ( x2 - data(i + step_size,4) )) + data(i + step_size,5) ; %function of Second(2) Base Line in i Try

        if data(i + step_size,4) < data(i,4)
            fplot(y2,[data(i + step_size,4) data(i,4)],'k') %plot the Second(2) Base Line in i Try
        else
            fplot(y2,[data(i,4) data(i + step_size,4)],'k') %plot the Second(2) Base Line in i Try
        end


        bdata(j,4) = data(i,4); %x1data(i,5)
        bdata(j,5) = data(i,5); %y1
        %plot(bdata(j,4),bdata(j,5),'r*') %%%%%%%%%%%%%%%%%

        Xi2_1 = data(i,4); Yi2_1 = data(i,5);Xi2_2 = data(i + step_size,4); Yi2_2 = data(i + step_size,5);
        plot(Xi2_1,Yi2_1,'ko');plot(Xi2_2,Yi2_2,'k.'); %plot the Two o Dots for Second(2) Base Line in i Try

        X2_MPi = ( ((data(i + step_size,4)-data(i,4))/2)+data(i,4) ) ; Y2_MPi = ( ((data(i + step_size,5)-data(i,5))/2)+data(i,5) );
        plot(X2_MPi,Y2_MPi,'r*') %Plot (MP)Middle Point for Second(2) Base Line of i try

        yp2 = ( (-1/Mi2) * ( xp2 - X2_MPi )) + Y2_MPi ; %function of Second(2) Perpendicular Line in i Try

        %% Solve System of two Perpendicular Line functions to get location of ICOR in i Try

        syms x y

        xp1 = x ;
        eqn1 = eval(yp1) - y ==0;
        xp2 = x ;
        eqn2 = eval(yp2) - y ==0; %change variable name to x&y

        sol = solve([eqn1, eqn2], [x, y]);
        ICOR_x = sol.x;
        ICOR_y = sol.y; %solve System of two Perpendicular Line functions

        figure(2)

        plot(ICOR_x,ICOR_y,'kx')  %Plot ICOR Point for i try
        
        SM = [0 ,5,6,7,8];
        ICOR(j+SM(1,k),1) = double(ICOR_x);
        ICOR(j+SM(1,k),2) = double(ICOR_y); %Save ICOR X&Y

        %yp1 = ( (-1/Mi) * ( xp1 - X_MPi )) + Y_MPi ; %function of First(1) Perpendicular Line in i Try

        if  X_MPi < ICOR(j,1)
            fplot(yp1,[X_MPi ICOR(j,1)],'b') %plot the  First(1) Perpendicular Line in i Try
        else
            fplot(yp1,[ICOR(j,1) X_MPi],'b') %plot the  First(1) Perpendicular Line in i Try
        end

        if  X2_MPi < ICOR(j,1)
            fplot(yp2,[X2_MPi ICOR(j,1)],'r') %plot the Second(2) Perpendicular Line in i Try
        else
            fplot(yp2,[ICOR(j,1) X2_MPi],'r') %plot the Second(2) Perpendicular Line in i Try
        end

        pause(1)

    end
end
%
% for j = 1:1:N_Step
%     %% Calculation for First(1) Perpendicular Line
%
%     disp(['j = ' num2str(j)])
%
%     syms x1 xp1
% %     i = ((j-1)*step_size) + 1 ;
%     ii = [7    20    33    46    59    72    85    100];
%     i = ii(1,j);
%     step_size = ii(1,j+1)-ii(1,j);
%     Mi = ( data(i + step_size,3) - data(i,3) ) / ( data(i + step_size,2) - data(i,2) ) ;
%     y1 = ( Mi * ( x1 - data(i + step_size,2) )) + data(i + step_size,3) ; %function of First(1) Base Line in i Try
%     if data(i + step_size,2) < data(i,2)
%         fplot(y1,[data(i + step_size,2) data(i,2)],'k') %plot the First(1) Base Line in i Try
%     else
%         fplot(y1,[data(i,2) data(i + step_size,2)],'k') %plot the First(1) Base Line in i Try
%     end
%
%     bdata(j,2) = data(i,2); %x1
%     bdata(j,3) = data(i,3); %y1
%     %plot(bdata(j,2),bdata(j,3),'r*') %%%%%%%%%%%%%%%
%
%     Xi_1 = data(i,2); Yi_1 = data(i,3);Xi_2 = data(i + step_size,2); Yi_2 = data(i + step_size,3);
%     plot(Xi_1,Yi_1,'ko');plot(Xi_2,Yi_2,'k.'); %plot the Two o Dots for First(1) Base Line in i Try
%
%     X_MPi = ( ((data(i + step_size,2)-data(i,2))/2)+data(i,2) ) ; Y_MPi = ( ((data(i + step_size,3)-data(i,3))/2)+data(i,3) );
%     plot(X_MPi,Y_MPi,'r*') %Plot (MP)Middle Point for First(1) Base Line of i try
%
%     yp1 = ( (-1/Mi) * ( xp1 - X_MPi )) + Y_MPi ; %function of First(1) Perpendicular Line in i Try
%
%     %% Calculation for Second(2) Perpendicular Line
%
%     syms x2 xp2
%
%     Mi2 = ( data(i + step_size,5) - data(i,5) ) / ( data(i + step_size,4) - data(i,4) ) ;
%     y2 = ( Mi2 * ( x2 - data(i + step_size,4) )) + data(i + step_size,5) ; %function of Second(2) Base Line in i Try
%
%     if data(i + step_size,4) < data(i,4)
%         fplot(y2,[data(i + step_size,4) data(i,4)],'k') %plot the Second(2) Base Line in i Try
%     else
%         fplot(y2,[data(i,4) data(i + step_size,4)],'k') %plot the Second(2) Base Line in i Try
%     end
%
%
%     bdata(j,4) = data(i,4); %x1data(i,5)
%     bdata(j,5) = data(i,5); %y1
%     %plot(bdata(j,4),bdata(j,5),'r*') %%%%%%%%%%%%%%%%%
%
%     Xi2_1 = data(i,4); Yi2_1 = data(i,5);Xi2_2 = data(i + step_size,4); Yi2_2 = data(i + step_size,5);
%     plot(Xi2_1,Yi2_1,'ko');plot(Xi2_2,Yi2_2,'k.'); %plot the Two o Dots for Second(2) Base Line in i Try
%
%     X2_MPi = ( ((data(i + step_size,4)-data(i,4))/2)+data(i,4) ) ; Y2_MPi = ( ((data(i + step_size,5)-data(i,5))/2)+data(i,5) );
%     plot(X2_MPi,Y2_MPi,'r*') %Plot (MP)Middle Point for Second(2) Base Line of i try
%
%     yp2 = ( (-1/Mi2) * ( xp2 - X2_MPi )) + Y2_MPi ; %function of Second(2) Perpendicular Line in i Try
%
%     %% Solve System of two Perpendicular Line functions to get location of ICOR in i Try
%
%     syms x y
%
%     xp1 = x ;
%     eqn1 = eval(yp1) - y ==0;
%     xp2 = x ;
%     eqn2 = eval(yp2) - y ==0; %change variable name to x&y
%
%     sol = solve([eqn1, eqn2], [x, y]);
%     ICOR_x = sol.x;
%     ICOR_y = sol.y; %solve System of two Perpendicular Line functions
%
%     figure(2)
%
%     plot(ICOR_x,ICOR_y,'kx')  %Plot ICOR Point for i try
%
%     ICOR(j,1) = double(ICOR_x);
%     ICOR(j,2) = double(ICOR_y); %Save ICOR X&Y
%     %yp1 = ( (-1/Mi) * ( xp1 - X_MPi )) + Y_MPi ; %function of First(1) Perpendicular Line in i Try
%
%     if  X_MPi < ICOR(j,1)
%         fplot(yp1,[X_MPi ICOR(j,1)],'b') %plot the  First(1) Perpendicular Line in i Try
%     else
%         fplot(yp1,[ICOR(j,1) X_MPi],'b') %plot the  First(1) Perpendicular Line in i Try
%     end
%
%     if  X2_MPi < ICOR(j,1)
%         fplot(yp2,[X2_MPi ICOR(j,1)],'r') %plot the Second(2) Perpendicular Line in i Try
%     else
%         fplot(yp2,[ICOR(j,1) X2_MPi],'r') %plot the Second(2) Perpendicular Line in i Try
%     end
%
%     pause(3)
%
% end
%% calculate R and Theta
% figure
% plot(ICOR(:,1),ICOR(:,2))
% axis equal
%
% for k = 1:1:N_Step
%     w = k*step_size ;
%     r1(k,1) = sqrt( (ICOR(k,1)-data(w-1,2))^2 + (ICOR(k,2)-data(w-1,3))^2 );
%     r2(k,1) = sqrt( (ICOR(k,1)-data(w-1,4) )^2 + (ICOR(k,2)-data(w-1,5) )^2 );
%     t1(k,1) = atan2d( (ICOR(k,2)-data(w-1,3)) , (ICOR(k,1)-data(w-1,2)) );
%     if  ( t1(k,1)<0 )
%          t1(k,1) =  360+t1(k,1);
%     end
%     t2(k,1) = atan2d( (ICOR(k,2)-data(w-1,5)) , (ICOR(k,1)-data(w-1,4)) );
%      if  ( t2(k,1)<0 )
%          t2(k,1) =  360+t2(k,1);
%     end
%     tr(k,1) = atan2d( (data(w-1,3)-data(w-1,5)) , (data(w-1,2)-data(w-1,4)) );
%     if  ( tr(k,1)<0 )
%          tr(k,1) =  360+tr(k,1);
%     end
%     t1f(k,1) = t1(k,1)-tr(k,1) ;
%     t2f(k,1) = t2(k,1)-tr(k,1) ;
% end

%plot([0,r1(1,1)],[0,0])
%
% M0 = atan2d( ( bdata(1,3) - bdata(1,5) ) , ( bdata(1,2) - bdata(1,4)) ) ;
%
% for a = 1:1:N_Step
%
%     syms xb
%
%     Mm = atan2d ( ( bdata(a,3) - bdata(a,5) ) , ( bdata(a,2) - bdata(a,4) ) );
%     if  ( Mm<0 )
%         Mm =  360+Mm;
%     end
%
%     Mf1 = atan2d ( ( ICOR(a,2) - bdata(a,3) ) , ( ICOR(a,1) - bdata(a,2) ) ) ;
%     if  ( Mf1<0 )
%         Mf1 =  360+Mf1;
%     end
%
%     Mf1it = Mf1 - (Mm-M0);
%     Mf1i = sind(Mf1it)/cosd(Mf1it);
%
%     yf1 = ( Mf1i * ( xb - bdata(1,2) )) + bdata(1,3);
%     %fplot(yf1,[-50 100]) %plot
%
%     Mf2 = atan2d( ( ICOR(a,2) - bdata(a,5) ) , ( ICOR(a,1) - bdata(a,4) ) ) ;
%     if  ( Mf2<0 )
%         Mf2 =  360+Mf2;
%     end
%
%     Mf2it = Mf2 - (Mm-M0);
%     Mf2i = sind(Mf2it)/cosd(Mf2it);
%
%     yf2 = ( Mf2i * ( xb - bdata(1,4) )) + bdata(1,5);
%     %fplot(yf2,[-50 100])
%
%     syms x y
%
%     xb = x ;
%     eqn1 = eval(yf1) - y ==0;
%     eqn2 = eval(yf2) - y ==0; %change variable name to x&y
%
%     sol = solve([eqn1, eqn2], [x, y]);
%     ICORB_x = sol.x;
%     ICORB_y = sol.y; %solve System of two Perpendicular Line functions
%
%     %plot(ICORB_x,ICORB_y,'ro')  %Plot ICOR Point for i try
%
%     ICORB(a,1) = double(ICORB_x);
%     ICORB(a,2) = double(ICORB_y); %Save ICOR X&Y
%
%
%     pause(0.01)
%
% end
%% TEST & Check For ICORB
% for i = 1:1:N_Step
%     r1 = sqrt( (ICOR(i,1)-bdata(i,2))^2 + (ICOR(i,2)-bdata(i,3))^2 );
%     r1p = sqrt( (ICORB(i,1)-bdata(1,2))^2 + (ICORB(i,2)-bdata(1,3))^2 );
%     Error_1 = abs(r1-r1p);
%     if Error_1 > 0.01
%         fprintf('in i = %d We have Error between r1-r1p With the amount of %7.4f mm \n',i,Error_1);
%         i = i - 1;
%     end
%     r2 = sqrt( (ICOR(i,1)-bdata(i,4))^2 + (ICOR(i,2)-bdata(i,5))^2 );
%     r2p = sqrt( (ICORB(i,1)-bdata(1,4))^2 + (ICORB(i,2)-bdata(1,5))^2 );
%     Error_2 = abs(r2-r2p);
%     if Error_2 > 0.01
%         fprintf('in i = %d We have Error between r2-r2p With the amount of %7.4f mm \n',i,Error_2);
%         i = i - 1;
%     end
% end

% for i = 1:120:N_Step
%     plot([ICOR(i,1),bdata(i,2)],[ICOR(i,2),bdata(i,3)])
%     plot([ICOR(i,1),bdata(i,4)],[ICOR(i,2),bdata(i,5)])
%
%     plot([ICORB(i,1),bdata(1,2)],[ICORB(i,2),bdata(1,3)])
%     plot([ICORB(i,1),bdata(1,4)],[ICORB(i,2),bdata(1,5)])
%
%     plot(bdata(i,4),bdata(i,5),'ko')
%     plot(bdata(i,2),bdata(i,3),'ko')
% end
%% Result
%
% figure(2)
% hold on
% axis equal
% plot ( ICOR(:,1) , ICOR(:,2) , 'b' , ICORB(:,1) , ICORB(:,2) , 'r' )
% legend('Space Centrode','Body Centrode')
% figure(2)
% axis equal
% plot(Zerodata(:,2),Zerodata(:,3),'r')
% plot(Zerodata(:,4),Zerodata(:,5),'b')
%
% plot(M(:,2),M(:,3),'b')
% plot(M(:,4),M(:,5),'r')