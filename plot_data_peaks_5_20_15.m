%This file reads data saved by the smart knee gui and plots it and does
%other stuff

%prep space
clear all; clc; close all;

%specify filename
% fname='running_varied.txt';
% fname='walking_test.txt';
% fname='jumping.txt';
% fname='squatting.txt';
fname='varied_test1.txt';
% fname='balance_board.txt';
% fname='jogging_incline_4_11_15.txt';
% fname='boarding_run2_4_12_15.txt';
% fname='ski4_4_18_15.txt';
% fname='lunge_walk_4_18_15.txt';
% fname='jumps and cuts_4_17_15.txt';
% fname='ski5_4_18_15.txt';
% fname='bbal2_4_19_15.txt';
% fname='becs_joghike_4_19_15.txt';
% fname='becs1_jogging.txt';
% fname='stairs_test.txt';
% fname='stairs_down_test.txt';
% fname='bike2_5_02_15.txt';
% fname='tap_dance_5_02_15.txt';
% fname='xavier_run1_decal.txt';
% fname='xavier_mediumRun_5_04_15.txt';
% fname='xavier_sprint_5_04_15.txt';
% fname='running_Jared1_5_03_15.txt';
% fname='walking_Jarod_5_03_15.txt';
% fname='jogging_naomi_5_03_15.txt';
% fname='squats_xavier1_5_06_15.txt';
% fname='xavier_jumps1_5_06_15.txt';
% fname='jared_biking_5_11_15.txt';
% fname='jared_squat1_5_05_15.txt';
% fname='jacob_test1_5_15_15.txt';

%Start test code
load_BLEdata_5_16_15; %load data set

%-----------MCU Code: Initialize Variables via Header File----------
bend_recognition_header_5_17_15;
%-------------------------------------------------------------------


%loop through points in order to simulate real time acquisition
c=0; %initialize loop counter
for m=1:length(ax)
    
    %%%%%% This is the start of the MCU loop code%%%%
    
    %-------------compute hip angle----------------------------
    %compute gravity unit vector  from quaternions
    gravx=2*(qx(m)*qz(m)-qw(m)*qy(m));
    gravy=2*(qw(m)*qx(m)+qy(m)*qz(m));
    gravz=(qw(m)*qw(m)-qx(m)*qx(m)-qy(m)*qy(m)+qz(m)*qz(m));
    mgrav=sqrt(power(gravx,2)+power(gravy,2)+power(gravz,2));
    gravx=gravx/mgrav; gravy=gravy/mgrav; gravz=gravz/mgrav;

    %rotate yz plane of gravity angle for sensor mounting
    gravz=gravy*sin(arot)+gravz*cos(arot);

    %get gravity angle in z and y directions
    %for now this is kind of a "hack" as it ignores rotation
    grav_angz=atan2(gravz,gravx)*180/pi-gravz_offset;

    %now get hip angle by adding grav_ang and ang
    tahip=grav_angz+fang.fc;  
    
    %----------flip sign on ax since it's "upside down"------------
    ax(m)=-ax(m);
   
    %------load values from m to m-3 -------------------------------
    if m>3 
        fang.fl3=fang.fl2; fahip.fl3=fahip.fl2; fax.fl3=fax.fl2; tl3=tl2;
        fang.fl2=fang.fl; fahip.fl2=fahip.fl; fax.fl2=fax.fl; tl2=tl;
        fang.fl=fang.fc; fahip.fl=fahip.fc; fax.fl=fax.fc; tl=tc;
        fang.fc=ang(m); fahip.fc=tahip; fax.fc=ax(m); tc=ta(m);
    elseif m==3
        fang.fl2=fang.fl; fahip.fl2=fahip.fl; fax.fl2=fax.fl; tl2=tl;
        fang.fl=fang.fc; fahip.fl=fahip.fc; fax.fl=fax.fc; tl=tc;
        fang.fc=ang(m); fahip.fc=tahip; fax.fc=ax(m); tc=ta(m);
    elseif m==2
        fang.fl=fang.fc; fahip.fl=fahip.fc; fax.fl=fax.fc; tl=tc;
        fang.fc=ang(m); fahip.fc=tahip; fax.fc=ax(m); tc=ta(m);
    elseif m==1
        fang.fc=ang(m); fahip.fc=tahip; fax.fc=ax(m); tc=ta(m);
        fang.fl=fang.fc; fahip.fl=fahip.fc; fax.fl=fax.fc; tl=tc;
    end
      
    %-------------compute derivatives------------------------------
    if m>3
        fang.fdot=(fang.fc-fang.fl3)/(tc-tl3);
        fahip.fdot=(fahip.fc-fahip.fl3)/(tc-tl3);
    else
        fang.fdot=0;
        fahip.fdot=0;
    end
    
    %------------------compute running averages-----------------
   
    %compute exponential running average for ax
    if m==1
        fax.mean=fax.fc; fax.mean_last=fax.fc;
    else
        fax.mean=exp_running_average(fax.fc,fax.mean_last,fax.alpha);
        fax.mean_last=fax.mean;
    end
    
       %compute exponential running average for ang
    if m==1
        fang.mean=fang.fc; fang.mean_last=fang.fc;
    else
        fang.mean=exp_running_average(fang.fc,fang.mean_last,fang.alpha);
        fang.mean_last=fang.mean;
    end
    
    %compute exponential running average for ahip
    if m==1
        fahip.mean=fahip.fc; fahip.mean_last=fahip.fc;
    else
        fahip.mean=exp_running_average(fahip.fc,fahip.mean_last,fahip.alpha);
        fahip.mean_last=fahip.mean;
    end
    
        
    %--------------compute ax peaks--------------------------------
    %load values into structure every iteration
    fax.tl=tl; fax.tc=tc;
    
    %update threshold value in ax parameter array so that the thresh is
    %equal to the running average times the scale factor
    fax.fthresh=fax.mean*fax.fthresh_scale;
    
    %now run algorithm on ax data
    fax=find_peaks(fax);

    %--------------compute knee ang peaks--------------------------------
    
    %these are inputs that need to be updated every iteration
    fang.tc=tc; fang.tl=tl;
    fang.fthresh=fang.mean*fang.fthresh_scale; %scale threshold
    fang.fdot_minus=fang.fmax*fang.fdot_minus_scale; %scale fdot_minus

    %update peak find state machine
    fang=peak_subpeak_findV2(fang,fax);
    

    %--------------compute ahip peaks--------------------------------
    
    %these are inputs that need to be updated every iteration
    fahip.tc=tc; fahip.tl=tl;
    fahip.fthresh=fahip.mean*fahip.fthresh_scale;
    fahip.fdot_minus=fahip.fmax*fahip.fdot_minus_scale;
    
    %run gradient based peak detection
    fahip=find_peaks_gradient(fahip);
     
    %--------identify bends and bend types---------------------------
    
    %this is the bend recognition state machine
    md=bend_recognizeV1(md,fang,fahip);
     
           
    %----------this is test code not to be included in MCu---------------    
    save_peaks_test_5_20_15;
    %----------------end test code--------------------------------------        
           
    
    %-------count peaks and reset state machine flags--------------
        
    %for ax peak finding state machine
    if fax.preturn==1
        %reset preturn flag
        fax.preturn=0;
        %save count
        ax_count=ax_count+1;
    end
       
    %for knee angle peak finding state machine
    if fang.preturn==1
        %reset flags
        fang.preturn=0;
        fang.pflag=0;
        fang.ax1peak=0;
        fang.ax1mag=0;
        fang.ax1_angle=0;
        fang.ax2peak=0;
        fang.ax2mag=0;
        fang.ax2_angle=0;
        %count number of angle peaks
        ang_count=ang_count+1;
    end
    
    %for knee angle peak finding state machine
    if fang.peak2==1
        %reset flags
        fang.peak2=0;
        %and count
        ang_count2=ang_count2+1;
    end
    
    %for hip angle peak finding state machine
    if fahip.preturn==1
        %reset flags
        fahip.preturn=0;
        %and count peaks
        ahip_count=ahip_count+1;
        
    end 
    
    %for motion recognition state machine
    if md.preturn==1
        %reset flags
        md.state=0; %0/1-reset at end
        md.noahip=0; %0/1-reset at end
        md.preturn=0; %0/1-reset at end
        md.ang_ax1peak=0;
        md.ang_ax1mag=0;
        md.ang_ax1_angle=0;
        md.ang_ax2peak=0;
        md.ang_ax2mag=0;
        md.ang_ax2_angle=0;
        %and count recognized bends
        md_count=md_count+1;
    end
 
    %%%%%% This is the end of the MCU loop code%%%%%%%%%
   
    
end

%output counts
ax_count
ang_count
ahip_count
[md.count,md.count1,md.count2,md.count3,md.count4,md.count5,md.count6...
md.count7,md.count8,md.count9,md.count10,md.count11]

%plot recognized bends
plot(ta,ang,ta,ahip,mdtpeak,mdtype*10,'yo')

%and plot peak data
whitebg([0 0 0]);

figure
plot(ta,ang,'.-y',ang_tfmax_array,ang_fmax_array,'ro',ta,angmean,'-m');
hold all

plot(ta,angmean,'-m')
hold all
plot(ang_tfmax_array,ang_fmax_array,'ro','MarkerSize',5);
plot(ang_tstart_array,ang_fstart_array,'rs','MarkerSize',10);
plot(ang_tend_array,ang_fend_array,'rd','MarkerSize',5);

% plot(mdtpeak,mdadiff_end*10,'oc');
% plot(mdtpeak,mdadiff_start*10,'sc');

if exist('ang_tp2')
    plot(ang_tp2,ang_fp2,'go','MarkerSize',5);
    plot(ang_tend2,ang_fend2,'gd','MarkerSize',5);
end

plot(ta,ahip,'.-r',ahip_tfmax_array,ahip_fmax_array,'go',ta,ahipmean,'-w');
plot(ahip_tstart_array,ahip_fstart_array,'gs');
plot(ahip_tend_array,ahip_fend_array,'gd');

s=10;
if exist('ax_tfmax_array')
    plot(ta,ax*s,'.-b',ta,amean*s,'-c',ax_tfmax_array,ax_fmax_array*s,'mo');
end

%low loop through and plot bend data
% for m=1:length(bend_save)
%     %plot stuff
%     plot(bend_save{m}(13),bend_save{m}(6)*1,'c<','MarkerSize',7);
%     plot(bend_save{m}(13),bend_save{m}(7)*1,'g>','MarkerSize',10);
%     plot(bend_save{m}(13),bend_save{m}(11)*100,'ys','MarkerSize',10);
% end
%
% plot(tshape,shape*5000,'cs')
% plot(mdtpeak,mdtdelay*500,'.-')
% plot(ta,mdstate*10,'.-c')
% plot(ta,fahipstate*10,'.-m')
% plot(ta,fangstate*10,'.-g')
% plot(ta,mdax1*20,'.w');
% plot(ta,-mdax2*20,'.w');
% plot(ta,axpreturn*5,'.-c');
% plot(ta,fangpflag*10,'.-r');

