%This header file is where contants are defined and variables are
%initialized

%------------these values must be chosen/set-------------------------
%define calibration constants
arot=-45*pi/180; %double: angle to rotate about x-axis for correcting data
gravz_offset=-20; %double: hip angle offset

%set peak detection parameters for ax using simple peak SFM
fax.alpha=.01; %double: running exponential average parameter
fax.tmin=1; %double: minimum peak width after threshold detection (ms)
fax.tmax=250; %double: maximum peak width (ms)
fax.fdiff_min=.5; %double: minimum peak height from threshold
fax.fthresh=0; %double: threshold value
fax.fthresh_scale=1.25; % double: amount to scale running average as threshold

%set peak detection parameters for angle using 2nd peak gradient FSM
fang.alpha=.0075; %double: exponential average parameter
fang.tmin=20; %double: minimum peak detection width (ms)
fang.tmax=5000; %double: maximum peak detection width (ms)
fang.tdmin=100; %double: maximum time to 'wait out' a flat spot (ms)
fang.fdiff_min=15; %double: minimum peak height from threshold
fang.fdiff_min2=10; %double: minimum peak height for second peak
fang.fdot_plus=.002; %double: positive fdot threshold (deg/ms)
fang.fdot_minus=-.002; %double: negative fdot threshold (dec/ms)
fang.fdot_minus_scale=-.000065; %double: fdot scale factor
fang.fthresh=0; %double: threshold value
fang.fthresh2=2; %double: threshold value for 2nd peak
fang.fthresh_scale=1; %double: fthresh_scale value

%set peak detection parameters for hip angle using peak gradient FSM
fahip.alpha=.0075; %double: exponential average parameter
fahip.tmin=20; %double: minimum peak width after threshold detection (ms)
fahip.tmax=5000; %double: maximum peak width (ms)
fahip.tdmin=100; %double: time to 'wait out' flat spot (ms)
fahip.fdiff_min=10; %double: minimum peak height from threshold
fahip.fdot_plus=.002; %double: positive fdot threshold (deg/ms)
fahip.fdot_minus=-.002; %double: negative fdot threshold (dec/ms)
fahip.fdot_minus_scale=-.000065; %double: fdot scale factor
fahip.fthresh=20; %double: threshold value
fahip.fthresh_scale=1; %double: fthresh_scale value

%set motion recognition FSM parameters
md.ahip_diff=-.2; %double: threshold difference between knee and hip min divided by knee max to ID forward vs. vertical motion
md.ahip_low=10; %double: for hip angle to distinguish biking on first pass (deg)
md.ang_diff=10; %double: for knee angle to distinguish biking (deg)
md.walk_thresh=.175; %double: in deg/ms for hip angle
md.jog_thresh=.425; %double: in deg/ms for hip angle
md.tshift_min=400; %double: max difference in time between knee and hip bend (ms)

%------------these values are simply being initilized, typically to zero

%initialize ax peak detection structure
fax.pflag=0; %int: peak detection flag
fax.preturn=0; %int: peak return flag
fax.fc=0; %double: ax value at iteration m (g's)
fax.fl=0; %double: ax value at iteration m-1 (g's)
fax.fl2=0; %double: ax value at iteration m-2 (g's)
fax.fl3=0; %double: ax value at  iteration m-3 (g's)
fax.tc=0; %double: time at iteration m
fax.tl=0; %double: time at iteration m-1
fax.fmax=0; %double: ax peak value (g's)
fax.tfmax=0; %double: time at peak value (ms)
fax.tstart=0; %double: time at peak start (ms)
fax.tend=0;  %double: time at  peak end
fax.dtpeak=0; %double: peak width (ms)
fax.dfpeak=0; %double: peak height (g's)
fax.mean=fax.fthresh; %double: exponential mean value
fax.mean_last=fax.fthresh; %double: previous exponential mean value
ax_count=0; %int: count of ax peaks

%initialize fang peak detection structure
fang.npt=0; %int: number of points in peak
fang.rnpt=0; %int: number of points in remainder
fang.state=0; %int: state of peak detection FSM
fang.preturn=0; %int: peak return flag
fang.rflag=0;  %int: remainder presence flag
fang.peak2=0;  %int: second peak detection flag
fang.pflag=0;  %int: flag for post peak dection
fang.ax1peak=0; %int: ax1 detection flag
fang.ax2peak=0; %int: ax2 detection flag
fang.axrpeak=0; %int: ax remainder detection flag
fang.ax_preturn=0; %int: ax_preturn flag
fang.fc=0; %double: angle value at iteration m
fang.fl=0; %double: angle value at iteration m-1
fang.fl2=0; %double: angle value at iteration m-2
fang.fl3=0; %double: angle value at iteration m-3
fang.tc=0; %double: time value at iteration m
fang.tl=0; %double: time value at iteration m-1
fang.fdot=0; %double: da/dt at iteration m
fang.fdot2=0; %double: da/dt at iteration m-1
fang.t0=0; %double: time delay starting value
fang.tstart=0; %double: time value at peak start
fang.fstart=0; %double: angle value at peak start
fang.tfmax=0; %double: time at peak
fang.fmax=0; %double: angle peak value
fang.tend=0; %double: time at peak end
fang.fend=0; %double: angle at peak end
fang.tfmax2=0; %double: time at second peak
fang.fmax2=0; %double: angle max at second peak
fang.tend2=0; %double: time at end of second peak
fang.fend2=0; %double: angle at end of second peak
fang.rt=0; %double: remainder time
fang.rf=0; %double: remainder angle
%fang.av=0; 
fang.dtpeak=0; %double: peak width 
fang.dfpeak=0; %double: peak height
fang.dtpeak2=0; %double: 2nd peak width
fang.dfpeak2=0; %double: 2nd peak magnitude
% fang.ft1=0; 
% fang.tt1=0;
% fang.ft2=0; 
% fang.tt2=0; 
fang.ax1mag=0; %double: mag of ax1 value
fang.ax2mag=0; %double: mag of ax2 value
fang.ax1_angle=0; %double: angle at ax1 value
fang.ax2_angle=0; %double: angle at ax2 value
fang.axrmag=0; %double: remainder ax value
fang.axr_angle=0; %double: remainder angle at ax value
fang.mean=fang.fthresh; %double: exp. running average value
fang.mean_last=fang.fthresh; %double: previous iteration running av. value
ang_count=0; %int: count of angle peaks
ang_count2=0; %int: count of second angle peaks

%initialize fahip hip angle peak detection structure
fahip.state=0; %int: state of FSM peak detection 
fahip.preturn=0; %int: return flag for FSM
fahip.rflag=0; %int: flag for remainder
fahip.npt=0; %int: number of points in peak
fahip.rnpt=0; %int: number of points in remainder
fahip.fc=0; %double: angle value at iteration m
fahip.fl=0; %double: angle value at iteration m-1
fahip.fl2=0; %double: angle value at iteration m-2
fahip.fl3=0; %double: angle value at iteration m-3
fahip.tc=0; %double: time value at iteration m
fahip.tl=0; %double: time value at iteration m-1
fahip.rt=0; %double: remainder time
fahip.rf=0; %double: remainder angle
fahip.fstart=0; %double: angle at peak start
fahip.fmax=0; %double: angle at peak max
fahip.fend=0; %double: angle at peak end
fahip.tstart=0; %double: time at peak start
fahip.tfmax=0; %double: time at peak max
fahip.tend=0; %double: time at peak end
fahip.dtpeak=0; %double: peak width time (ms)
fahip.dfpeak=0; %double: peak height
% fahip.fthresh1=0; 
% fahip.fthresh2=0; 
% fahip.tthresh1=0; 
% fahip.tthresh2=0; 
fahip.t0=0; %double: time start for wait period
fahip.mean=fahip.fthresh; %double: running exp. mean
fahip.mean_last=fahip.fthresh; %double: previous iteration running exp. mean
ahip_count=0; %int: count for hip angle peaks



%initialize motion recognition state machine structure
md.state=0; %int: FSM state
md.ax1peak=0; %int: ax1 peak flag
md.ax2peak=0; %int: ax2 peak flag
md.noahip=0; %int: no ahip flag
md.preturn=0; %int: bend detected return flag
md.hip=0; %int: hip deteced value, ranges from 1-4
md.ang_ax1peak=0; %int: ax1 peak flag
md.ang_ax2peak=0; %int: ax2 peak flag
md.type=0; %bend type value, ranges from 1-11 (currently)
md.tstart=0; %double: time of bend start
md.tend=0; %double: time of bend end
md.ang_tstart=0; %double: time of knee angle start
md.ang_fstart=0; %double: knee angle bend start value
md.ang_tfmax=0; %double: time at max knee angle
md.ang_fmax=0; %double: max knee angle
md.ang_tend=0; %double: time at end of knee angle bend
md.ang_fend=0; %double: angle at end of knee angel bend
md.ahip_tstart=0; %double: time at hip bend start
md.ahip_fstart=0; %double: angle at hip bend start
md.ahip_tfmax=0; %double: time at hip angle max
md.ahip_fmax=0; %double: angle at hip bend max
md.ahip_tend=0; %double: time at hip bend end
md.ahip_fend=0; %double: angle at hip bend end
md.width=0;  %double: time width of bend, in ms
md.adiff_start=0; %double: adiff start value
md.adiff_end=0; %double: adiff end value
md.ahipdot=0; %double: ahip derivitive
md.tdelay=0; %double: time delay start
md.tdelay2=0; %double: time delay end
md.ang_ax1mag=0; %double: ax1 mag
md.ang_ax1_angle=0; %double: angle at ax1 peak
md.ang_ax2mag=0;  %double: ax2 mag
md.ang_ax2_angle=0; %double: angle at ax2 peak
md.bend_data=[0,0,0,0,0,0,0,0,0,0,0,0,0]; %bend data array
md.count=0; %int: total bend counts
md.count_temp=0; %int: temp count value
md.count1=0; %int: count for bend type 1
md.count2=0; %int: count for bend type 2
md.count3=0; %int: count for bend type 3
md.count4=0; %int: count for bend type 4
md.count5=0; %int: count for bend type 5
md.count6=0; %int: count for bend type 6
md.count7=0; %int: count for bend type 7
md.count8=0; %int: count for bend type 8
md.count9=0; %int: count for bend type 9
md.count10=0; %int: count for bend type 10
md.count11=0;%int: count for bend type 11
md_count=0; %int: count for total bends

%initialize other variables
gravx=0; %gravity vector values from quaternions
gravy=0; 
gravz=0; 
mgrav=0; 
grav_angz=0; 
tahip=0; %temp hip angle value
tc=0; %time values for iterations m to m-3
tl=0;
tl2=0;
tl3=0;