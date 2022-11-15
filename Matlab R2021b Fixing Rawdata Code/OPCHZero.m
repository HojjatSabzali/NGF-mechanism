clc;clear;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Hojjat Sabzali                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code used for fixing raw data. line AB/EF on the thigh in the world
% coordinate system is fixed, and the position of the CD/GH is corrected

load('OPCHrawdataE99.mat');
OPCHrawdata = OPCHrawdata(1:100,:);
rawdata = OPCHrawdata;
data = zeros(100,5);
len = zeros(100,1);
Length_34 = zeros(100,1);
data(:,1) = rawdata(:,1);
f = figure ;
%f.WindowState = 'maximized';

for i = 1:100
    %clf  %clear figure to see created data as a frame
    axis equal
    hold on

    plot(rawdata(i,3),rawdata(i,4),'k*') % plot the input data
    plot(rawdata(i,5),rawdata(i,6),'k*')
    plot([rawdata(i,3),rawdata(i,5)],[rawdata(i,4),rawdata(i,6)]) %Line12
    plot(rawdata(i,7),rawdata(i,8),'k*')
    plot(rawdata(i,9),rawdata(i,10),'k*')
    plot([rawdata(i,7),rawdata(i,9)],[rawdata(i,8),rawdata(i,10)]) %Line34

    %     plot([wdata(i,3),wdata(i,7)],[wdata(i,4),wdata(i,8)])% plot Test for slope of line 1-3 & 1-4
    %     plot([wdata(i,3),wdata(i,9)],[wdata(i,4),wdata(i,10)])

    X_i1 = ( rawdata(i,3) - rawdata(i,3) );
    Y_i1 = ( rawdata(i,4) - rawdata(i,4) );
    plot(X_i1,Y_i1,'k*') % 1st Point Location

    X_i2 = ( rawdata(i,3) - rawdata(i,3) );
    r_1 = sqrt( ((rawdata(i,3)-rawdata(i,5))^2) + ((rawdata(i,4)-rawdata(i,6))^2));
    Y_i2 = ( -r_1 );
    plot(X_i2,Y_i2,'k*') % 2nd Point Location

    plot([X_i1,X_i2],[Y_i1,Y_i2]) %PLot Line 12

    r_2 = sqrt( ((rawdata(i,3)-rawdata(i,7))^2) + ((rawdata(i,4)-rawdata(i,8))^2));

    theta_1 = asind( abs(rawdata(i,6)-rawdata(i,4)) / r_1 ); % or acosd

    if (i <= 102)
        theta_2 = asind( abs(rawdata(i,8)-rawdata(i,4)) / r_2 );% or acosd
    else
        theta_2 = acosd( abs(rawdata(i,8)-rawdata(i,4)) / r_2 );
    end

    %     if_1 = (rawdata(i,7)-rawdata(i,3)); %X13
    %     if_2 = (rawdata(i,5)-rawdata(i,3)); %X12
    %     if ( i <= 102)
    %         if (if_1 <= 0)
    %             if (if_2 <= 0)
    %                 dtheta_1 = theta_2-theta_1;
    %             else
    %                 dtheta_1 = theta_2+theta_1;
    %             end
    %         else
    %             dtheta_1 = theta_2-theta_1;
    %         end
    %     else
    %         dtheta_1 = theta_2+theta_1;
    %     end

    dtheta_1 = theta_2+theta_1;

    X_i3 = -r_2 * sind(abs(dtheta_1));
    Y_i3 = -r_2 * cosd(abs(dtheta_1));

    %     if ( i <= 102 )
    %         X_i3 = -r_2 * sind(abs(dtheta_1));
    %         Y_i3 = -r_2 * cosd(abs(dtheta_1));
    %     else
    %         X_i3 = -r_2 * cosd(abs(dtheta_1));
    %         Y_i3 = r_2 * sind(abs(dtheta_1));
    %     end

    plot(X_i3,Y_i3,'k*') % 3rd Point Location

    r_3 = sqrt( ((rawdata(i,3)-rawdata(i,9))^2) + ((rawdata(i,4)-rawdata(i,10))^2));

    theta_3 = acosd( abs(rawdata(i,10)-rawdata(i,4)) / r_3 ); % or asind

%         if_3 = (rawdata(i,9)-rawdata(i,3));
%         if (if_3 <= 0)
%             if (if_2 <= 0)
%                 dtheta_2 = theta_3-theta_1;
%             else
%                 dtheta_2 = theta_3+theta_1;
%             end
%         else
dtheta_2 = theta_3-theta_1;


    %     if_5 = (rawdata(i,6)-rawdata(i,4))/(rawdata(i,5)-rawdata(i,3)); % slope of line between 1-2 points
    %     if_6 = (rawdata(i,10)-rawdata(i,4))/(rawdata(i,9)-rawdata(i,3)); % slope of line between 1-4 points
    %     if (if_5 <0 ) && (if_6 <0)
    %         if (if_5 < if_6)
    %             X_i4 = r_3 * sind(abs(dtheta_2));
    %         else
    %             X_i4 = -r_3 * sind(abs(dtheta_2));
    %         end
    %     else
    %         X_i4 = -r_3 * sind(abs(dtheta_2));
    %     end

    if_14 = theta_3-theta_1;
    if (if_14 <= 0)
        X_i4 = -r_3 * cosd(abs(dtheta_2));
        Y_i4 = r_3 * sind(abs(dtheta_2));
    else
        X_i4 = -r_3 * cosd(abs(dtheta_2));
        Y_i4 = -r_3 * sind(abs(dtheta_2));
    end



    plot(X_i4,Y_i4,'k*') % 4th Point Location

    plot([X_i3,X_i4],[Y_i3,Y_i4]) % PLot Line 34

    r_23 = sqrt( ((rawdata(i,5)-rawdata(i,7))^2) + ((rawdata(i,6)-rawdata(i,8))^2));
    rr_23 = sqrt( ((X_i3-X_i2)^2) + ((Y_i3-Y_i2)^2));
    Error_1 = abs(r_23-rr_23);

    %     plot([X_i1,X_i4],[Y_i1,Y_i4]) % plot Test for slope of line 1-4 & 1-3
    %     plot([X_i1,X_i3],[Y_i1,Y_i3])

    if (Error_1 >= 0.000001 )  % test point 3 with Comparision Length between 2-3 points
        fprintf('in i = %d You have Error between 2-3 points With the amount of %10.4f mm \n',i,Error_1);
    else
    end

    r_34 = sqrt( ((rawdata(i,7)-rawdata(i,9))^2) + ((rawdata(i,8)-rawdata(i,10))^2) );
    rr_34 = sqrt( ((X_i3-X_i4)^2) + ((Y_i3-Y_i4)^2) );
    Error_2 = abs(r_34-rr_34);

    Length_34(i) = r_34;

    if (Error_2 >= 0.000001 ) % test point 4 with Comparision Length between 3-4 points
        fprintf('in i = %d You have Error between 3-4 points With the amount of %7.4f mm \n',i,Error_2);
    else
    end

    len(i)=r_34;

    slop_d12 = atand(rawdata(i,6)-rawdata(i,4))/(rawdata(i,5)-rawdata(i,3)); % slope of line between 1-2 points
    slop_d23 = atand(rawdata(i,8)-rawdata(i,4))/(rawdata(i,7)-rawdata(i,3)); % slope of line between 3-4 points

    % slop_12 = (Y_i2-Y_i1)/(X_i2-X_i1); % slope of line between 1-2 points after transfer
    slop_23 = atand(Y_i4-Y_i3)/(X_i4-X_i3); % slope of line between 3-4 points after transfer

    Error_3 = abs(slop_d23-slop_d12);

    disp(i)
    pause(0.1)

    data(i,2) = X_i3; % storage created data
    data(i,3) = Y_i3;
    data(i,4) = X_i4;
    data(i,5) = Y_i4;

    KTheta = atan2d(data(i,3)-data(i,5),data(i,2)-data(i,4)); %Storage Knee Theta
    if KTheta < 0
        KThetaF(i) =90 + abs(KTheta);
    else
        KThetaF(i) =90 - abs(KTheta);
    end

end

KThetaF = KThetaF - (13.755096162198583)+7;
Mean_34 = mean(Length_34); % calculate avrage length of line between 3-4 points
X = data(:,2); % X & Y data for cftool
Y = data(:,3);

XX = data(:,4); % X & Y data for cftool
YY = data(:,5);
% clear dataf
% k=1;
% for j = 1:102
%     ch1 = atan2d(data(j+1,3)-data(j,3),data(j+1,2)-data(j,2));
%     ch2 = atan2d(data(j+1,5)-data(j,5),data(j+1,4)-data(j,4));
%     if (ch1 <= 0) && (ch2 <= 0)
% 
%         dataf(k,:) = data (j,:);
%        
%         plot([dataf(k,2),dataf(k,4)],[dataf(k,3),dataf(k,5)])
%         axis equal
%         hold on
%         k = k+1;
%         pause(2)
%     else
%         E4 = sqrt( ( data(j,3)-data(j+1,3) )^2 + ( data(j,2)-data(j+1,2) )^2 );
%         fprintf('in j = %d you have Error in point #3 with the amount of %7.4f \n',j,E4);
% 
%         E5 = sqrt( ( data(j,5)-data(j+1,5) )^2 + ( data(j,4)-data(j+1,4) )^2 );
%         fprintf('in j = %d you have Error in point #3 with the amount of %7.4f \n',j,E5);
%     end
% end
% 
