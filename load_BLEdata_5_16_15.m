%This function loads the data from saved files and does some interleaving
%and other stuff.  The final arrays can be read to simulate a realtime
%signal on the MCU.

%load data
data=load(fname);
t=data(:,1);
ax=data(:,2); ay=data(:,3); az=data(:,4);
ang=data(:,5); %da=data(:,6);
gx=data(:,7); gy=data(:,8); gz=data(:,9); p=data(:,10);
ax2=data(:,11); ay2=data(:,12); az2=data(:,13);
mx=data(:,14); my=data(:,15); mz=data(:,16);
qw=data(:,17); qx=data(:,18); qy=data(:,19); qz=data(:,20);
grav_ang=data(:,21); grav_angz=data(:,22); grav_angy=data(:,23);

%fix ax2, as it was converted differently
ax2=ax2*(512/2)*(8/32768);
ay2=ay2*(512/2)*(8/32768);
az2=az2*(512/2)*(8/32768);

%now interleave acceleration data
c=0;
dta=.015;
npt=length(ax);
for m=1:npt
    %update counter
    c=c+1;
    %get time
    if c>1
        ta(c)=ta(c-1)+dta;
    else
        ta(c)=0;
    end
    %save second acc value as previous
    tax(c)=ax2(m); 
    tay(c)=ay2(m);
    taz(c)=az2(m);
    %update counter
    c=c+1;
    %save time
    ta(c)=ta(c-1)+dta;
    %save first acc value
    tax(c)=ax(m); 
    tay(c)=ay(m);
    taz(c)=az(m);
end

%reassign
ax=tax; ay=tay; az=taz;
amag=sqrt(ax.^2+ay.^2+az.^2);

%now create time array for other data points
dtang=.03;
t=linspace(0,npt*dtang,npt);

%interpolate gyroscope and angle data to acc data
gx=interp1(t,gx,ta,'pchip');
gy=interp1(t,gy,ta,'pchip');
gz=interp1(t,gz,ta,'pchip');
ang=interp1(t,ang,ta,'pchip');
qw=interp1(t,qw,ta,'pchip');
qx=interp1(t,qx,ta,'pchip');
qy=interp1(t,qy,ta,'pchip');
qz=interp1(t,qz,ta,'pchip');
%ahip=interp1(t,ahip,ta,'pchip');
% grav_ang=interp1(t,grav_ang,ta,'pchip');
% grav_angz=interp1(t,grav_angz,ta,'pchip');

%convert time back to miliseconds
ta=ta*1000;

%rotate ay and az and gy and gz
% R=[cos(arot),-sin(arot);sin(arot),cos(arot)];
% for m=1:length(ay);
%     aprime=R*[ay(m);az(m)];
%     ay(m)=aprime(1); az(m)=aprime(2);
%     gprime=R*[gy(m);gz(m)];
%     gy(m)=gprime(1); gz(m)=gprime(2);
% end

%subtract offset from ahip as test
%ahip=ahip+10;

%get rhx a different way
% lshin=20/12; lthigh=20/12;
% xshin=-lshin*sin(grav_angz*pi/180);
% xthigh=-lthigh*sin(ahip*pi/180);
% rhx=xthigh+xshin;

%estimate hip height
% ht=lthigh*cos(ahip*pi/180);
% hs=lshin*cos(grav_angz*pi/180);
% h=ht+hs;