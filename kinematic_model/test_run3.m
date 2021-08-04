%constants
%m from https://www.greentoyota.com/research/new-toyota-rav4-dimensions-weight.htm
m=1642.004; %kg, upper end of the weight, curbweight
l=2.67716; %meter (in=105.4)
track=1.6002; %meter (in=63)
%giving an arbitrary number for l1 and l2 that is reasonable till we aquire
%the actual numbers
l1=1.251204; %meter(in=49.26)
l2=1.415796; %meter (in=55.74)


%read data in
drive_data2=readtable('../outputs/withNewFeatures/dataByLocation_2021-01-19-22-14-05_2T3Y1RFV8KC014025.csv','NumHeaderLines',1);
%converting the table to a double array
drive_data2=table2array(drive_data2);
 
% figure(1);
% plot(isnan(drive_data2(:, 11)));
% hold on;
% plot(isnan(drive_data2(:, 4)));
% hold on;
% plot(isnan(drive_data2(:, 8)));
% legend('SteerAngle','Speed','Yaw Rate');
% input('wait');

Time=drive_data2(:,1);
Longitude=drive_data2(:,2);
Longitude=Longitude*111000; %convert longitude from degree to meters?
Latitude=drive_data2(:,3);
Latitude=Latitude*111000; %convert latitude rom degrees to meters?
Speed=drive_data2(:,4); %KPH
Speed=Speed*1000.0/3600.0; %converted K/H to m/s
latAccel=drive_data2(:,5);
longAccel=drive_data2(:,6);
ZAccel=drive_data2(:,7);
YawRate=drive_data2(:,8);
SteerAngle=drive_data2(:,11); %degrees

rd=gradient(YawRate);
sd=gradient(SteerAngle);

w=size(Time);
num_samp=w(1,1);

Vy=zeros(1,9465);
 %first calculation, initial values
Vyi=0;
Caf(1)=(YawRate(1)*Speed(1)*m)/SteerAngle(1);  
Vy(1)=(1/m)*Caf(1)*SteerAngle(1)-YawRate(1)*Speed(1);
R(1)=lat_of_c(l,SteerAngle(1),track);
Vx(1)=lon_vel(R(1),YawRate(1));
X0=0;
Y0=0;
Latitude=Latitude-Latitude(1);
Longitude=Longitude-Longitude(1);
head_angle(1)=trapz(Time(1),YawRate(1),1);

for a=2:num_samp
    if (isnan(Time(a)))
        disp('isnan')
        disp(a)
        Time(a) = -1;
    end
    if (isnan(Longitude(a)))
        disp('isnan')
        disp(a)
        Longitude(a) = mean(Longitude(a-2:a-1));
    end
    if (isnan(Latitude(a)))
        disp('isnan')
        disp(a)
        Latitude(a) = mean(Latitude(a-2:a-1));
    end

    Vx(a)=Speed(a);
    Caf(a)=(YawRate(a)*Vx(a)*m)/((1e-5)+SteerAngle(a)); %speed to Vx
    Vy(a)=(1/m)*Caf(a)*SteerAngle(a)-YawRate(a)*Vx(a); %speed to Vx
    
    head_angle(a)=head_angle(a-1)+YawRate(a)*(Time(a)-Time(a-1));
    
    %matricies for VX VY calculation
    M1=[cosd(head_angle(a)),-sind(head_angle(a));sind(head_angle(a)),cosd(head_angle(a))];
    M2=[Vx(a);Vy(a)];
    M=M1*M2;
    VX(a)=M(1,1); 
    VY(a)=M(2,1);
    
    %matrixes for X Y calculations
    N1=[X0;Y0]; 
    disp(length(Time(2:a)));
    N2= [trapz(Time(2:a)',Vx(2:a).*cosd(head_angle(2:a))-Vy(2:a).*sind(head_angle(2:a)),2);trapz(Time(2:a)',Vx(2:a).*sind(head_angle(2:a))+Vy(2:a).*cosd(head_angle(2:a)),2)];
    N=N1+N2;
    X(a)=N(1,1);
    Y(a)=N(2,1);
    
    figure(2);
    xlim auto;
    ylim auto;
    scatter(X(a),Y(a),'ro');
    hold on;
    scatter(Longitude(a),Latitude(a),'ko');%
    pause(.5);
    hold on; %
    grid on;
    xlabel('X axis');
    ylabel('Yaxis');
end
 


 %DX is change in position on x axis
for d=1:num_samp-1
    DX(d)=Vx(d).*(Time(d+1)-Time(d));
end
totalX=sum(DX);
%dy i
for f=1:num_samp-1
    DY(f)=Vy(f).*(Time(f+1)-Time(f));
end
totalY=sum(DY);
DX(num_samp)=0;
DY(num_samp)=0;