%This peak finding function uses both the function value and derivative,
%along with a function threshold and an upper/lower derivative threshold.
%Note that the inputs/output arrays are slightly different than for the
%function threshold only peak detection algorithm

function fs=find_peaks_gradient(fs)

%-------------start function--------------------------------  
%check state using switch case
switch true
    %state s0 is idle state
    case fs.state==0
        %check to see if fdot>fdot_plus, if so change states
        %also, initiate peakfind variables
        if fs.fdot>fs.fdot_plus
            %change states
            fs.state=1;
            %initialize pfind variables
            %how this happens depends on if a remainder exists
            if fs.rflag==1
                %initialize pfind variables with remainder
                fs.tstart=fs.rt; fs.fstart=fs.rf;
                %initialize average and npt with remainder values
                %amag_av=ramag; rhx_av=rrhx; npt=rnpt;
            else
                %use previous time/function value
                fs.tstart=fs.tl; fs.fstart=fs.fl;
                %initialize averages and npt
                %amag_av=amag; rhx_av=rhx; 
                fs.npt=1;
            end
            fs.tfmax=fs.tc; fs.tend=fs.tc; 
            fs.fmax=fs.fc; fs.fend=fs.fc;
        else
            %set rflag to zero if it already isn't
            fs.rflag=0;
        end
    %state s1 is between fdot crosing fdot_thresh and f crossing fthresh
    case fs.state==1
        %check to make sure fdot>fdot_thresh
        if fs.fdot>fs.fdot_plus
            %if so, update pfind variables
            fs.fmax=fs.fc; fs.fend=fs.fc;
            fs.tfmax=fs.tc; fs.tend=fs.tc;
            %update npt and average values
            fs.npt=fs.npt+1;
            %now check to see if f>fthresh
            if fs.fc>fs.fthresh
                %change states
                fs.state=2;
                %save values at threshold
                fs.fthresh1=fs.fc; fs.tthresh1=fs.tc;
            end
        else
            %if fdot is not >fdot_plus, then change back to 0 state
            fs.state=0;
        end
    %state 2 is when f is above fthresh
    case fs.state==2
        %update pfind variables
        if fs.fc>fs.fmax %only update peaks if they are a peak
            fs.fmax=fs.fc;
            fs.tfmax=fs.tc;
        end
        fs.fend=fs.fc; fs.tend=fs.tc;
        %update npt and average values
        fs.npt=fs.npt+1;
        %now check to see if threshold is crossed
        if fs.fc<fs.fthresh
            %if so, change states
            fs.state=3;
            %and save values at threshold
            fs.fthresh2=fs.fc; fs.tthresh2=fs.tc;
        end
    %state 3 is looking for fdot to cross fdot_minus
    case fs.state==3
        %update pfind variables
        %use previous values
        %tend=tc; fend=fc;
        fs.tend=fs.tl; fs.fend=fs.fl;
        %update npt and average values
        fs.npt=fs.npt+1;
        %check to see if fdot>fdot_minus
        if fs.fdot>fs.fdot_minus
            %start time delay counter
            fs.t0=fs.tc;
            %switch states
            fs.state=4;
            %set remainder flag and save remainders
            fs.rflag=1;
            %use last values
            %rt=tc; rf=fc;
            fs.rt=fs.tl; fs.rf=fs.fl; 
            fs.rnpt=fs.npt-1; 
            %ramag=amag_av; rrhx=rhx_av;
        end
    %this state is waiting for tdelay>tdmin
    case fs.state==4
        %update pfind variables
        %fend=fc; tend=tc; %maybe don't do this
        %check to make sure fdot>fdot_minus
        if fs.fdot>fs.fdot_minus
            %check to see if (tc-t0)>tdmin, if so end algorithm
            if (fs.tc-fs.t0)>fs.tdmin
                %algorithm is done, set state back to 0
                fs.state=0;
                %get peak width and height
                fs.dtpeak=fs.tend-fs.tstart; fs.dfpeak=fs.fmax-(fs.fstart+fs.fend)/2;
                %now return values if width and height of peak is
                %within specified parameters
                if fs.dtpeak>fs.tmin && fs.dtpeak<=fs.tmax && fs.dfpeak>fs.fdiff_min
                    fs.preturn=1;
                else
                    fs.dtpeak=0; fs.dfpeak=0;
                end 
            end
        else
            %if fdot is not >fdot_minus, change back to state 3
            fs.state=3;
            %also set remainder flag bck to zero
            fs.rflag=0; %is this right?
        end
    otherwise
        %'WTF?'
        %fs.state
end             
%--------------end function------------------------------------------