
function fs=peak_subpeak_findV2(fs,fax)

%note, this was modified on 5/14/15 to incluce logging of ax peaks and
%values.  This needs to be updated on the state machine diagram.

%%%%%--------------start of function code---------------------------
%this finite state machine has five states, which are contained within a
%switch case statement.  It will identify peaks within the input signal and
%will also identify the second, smaller peak associated with the knee angle
%while walking/jogging.  Finally, it logs the presence of an accelerometer
%(ax) peak either before and/or after the angle peak, and records the value
%of the acceleration as well as the knee angle at these points.  It
%requires the knee ang peak finding structure (fang) as well as the ax peak
%finding structure (fax) as inputes and ouputs the updates fang structure.
%Refer to the flow chart for specifics of its function

%check state using switch case
switch true
    %state s0 is idle state
    case fs.state==0
        %check to see if fdot>fdot_plus, if so change states
        %also, initiate peakfind variables
        if fs.fdot>fs.fdot_plus
            %change states
            fs.state=1;
            %initialize ax1 parameters by first checking for a
            %fax.preturn, then initialize to zero
            if fax.preturn==1
                fs.ax1peak=1;
                fs.ax1mag=fax.fmax;
                fs.ax1_angle=fs.fc;
            else
                fs.ax1peak=0;
                fs.ax1mag=0;
                fs.ax1_angle=0;
            end
            %and initialize ax2 parameters to zero
            fs.ax2peak=0;
            fs.ax2mag=0;
            fs.ax2_angle=0;
            %initialize pfind variables
            %how this happens depends on if a remainder exists
            if fs.rflag==1
                %initialize pfind variables with remainder
                fs.tstart=fs.rt; fs.fstart=fs.rf;
                %initialize average and npt with remainder values
                fs.npt=fs.rnpt;
                %initialize ax1 parameters with remainder if larger
                %than existing ax1mag
                if fs.axrmag>fs.ax1mag
                    fs.ax1peak=fs.axrpeak;
                    fs.ax1mag=fs.axrmag;
                    fs.ax1_angle=fs.axr_angle;
                end
                %reset remainder
                rflag=0;
                fs.axrpeak=0;
                fs.axrmag=0;
                fs.axr_angle=0;
            else
                %use previous time/function value
                fs.tstart=fs.tl; fs.fstart=fs.fl;
                %initialize averages and npt
                fs.npt=1;
            end
            %and initialize starting/ending values
            fs.tfmax=fs.tc; fs.tend=fs.tc; 
            fs.fmax=fs.fc; fs.fend=fs.fc;
        else
            %set rflag to zero if it already isn't
            fs.rflag=0;
            fs.axrpeak=0;
            fs.axrmag=0;
            fs.axr_angle=0;
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
            %update ax parameters
            if fax.preturn==1
                %update ax1 parameters only if amag is larger than last value
                if fax.fmax>fs.ax1mag
                    fs.ax1peak=1;
                    fs.ax1mag=fax.fmax;
                    fs.ax1_angle=fs.fc;
                end
            end
            %now check to see if f>fthresh
            if fs.fc>fs.fthresh
                %change states
                fs.state=2;
                %save values at threshold
                fc.f1=fs.fc; fc.tt1=fs.tc;
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
            fs.pflag=0; %keep pflag=0
        else
            %at this point, set pflag because peak has occured
            fs.pflag=1;
        end
        %update end point values
        fs.fend=fs.fc; fs.tend=fs.tc;
        %update npt and average values
        fs.npt=fs.npt+1;
        %update ax parameters
        if fax.preturn==1
            %check for pflag and update ax parameters appropriately
            if fs.pflag==0
                %update ax1 parameters only if amag is larger than last
                if fax.fmax>fs.ax1mag
                    fs.ax1peak=1;
                    fs.ax1mag=fax.fmax;
                    fs.ax1_angle=fs.fc;
                end
            else
                %update ax2 parameters only if amag is larger than last
                if fax.fmax>fs.ax2mag
                    fs.ax2peak=1;
                    fs.ax2mag=fax.fmax;
                    fs.ax2_angle=fs.fc;
                end
            end
        end
        %now check to see if threshold is crossed
        if fs.fc<fs.fthresh
            %if so, change states
            fs.state=3;
            %and save values at threshold
            fs.ft2=fs.fc; fs.tt2=fs.tc;
        end
    %state 3 is looking for fdot to cross fdot_minus
    case fs.state==3
        %update pfind variables
        %use previous values
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
            fs.rt=fs.tl; fs.rf=fs.fl; 
            fs.rnpt=1;
            %initialize fmax2 and tfmax2
            fs.tfmax2=fs.tc; fs.fmax2=fs.fc;
        end
        %update ax parameters
        if fax.preturn==1
            %update ax2 parameters only if amag is larger than last
            if fax.fmax>fs.ax2mag
                fs.ax2peak=1;
                fs.ax2mag=fax.fmax;
                fs.ax2_angle=fs.fc;
            end
        end
    %this state is waiting for tdelay>tdmin and saves everthing to the
    %remainder, which will then be transfered either to this bend or
    %next bend depending on conditions
    case fs.state==4
        %check to make sure fdot>fdot_minus
        if fs.fdot>fs.fdot_minus
            %update ax parameters as a remainder, but only if larger
            %than previous axrmag
            if fax.preturn==1
                if fax.fmax>fs.axrmag
                    fs.axrpeak=1;
                    fs.axrmag=fax.fmax;
                    fs.axr_angle=fs.fc;
                end
            end
            %get peak width and height
            fs.dtpeak=fs.tend-fs.tstart; fs.dfpeak=fs.fmax-(fs.fstart+fs.fend)/2;
            %check to see if peak meeets filter criterea
            if fs.dtpeak>fs.tmin && fs.dtpeak<=fs.tmax && fs.dfpeak>fs.fdiff_min 
                %now check to see if (tc-t0)>tdmin, if so end algorithm
                if (fs.tc-fs.t0)>fs.tdmin
                    %algorithm is done, set state back to 0
                    fs.state=0;
                    %a peak gets returned
                    fs.preturn=1;
                else
                    %move to state5 if fc-fend is greater than fthresh2
                    if (fs.fc-fs.fend)>fs.fthresh2
                        %change to state 5
                        fs.state=5;
                    end
                end
            else
                %if peak is not within filter criteria, return no peak
                %and return to state 0
                fs.dtpeak=0; fs.dfpeak=0;
                fs.peak2=0;
                fs.state=0;
            end     
        else
            %if fdot is not >fdot_minus, change back to state 3
            fs.state=3;
            %also set remainders flag and values back to zero
            fs.rflag=0;
            fs.axrpeak=0;
            fs.axrmag=0;
            fs.axr_angle=0;
            %and transfer ax remainder to ax2peak if a ax remainder
            %exists and if it's larger than current ax2mag
            if fs.axrpeak==1
                if fs.axrmag>fs.ax2mag
                    fs.ax2peak=1;
                    fs.ax2mag=fs.axrmag;
                    fs.ax2_angle=fs.axr_angle;
                end
            end
        end
    case fs.state==5
        %update ax parameters as a remainder
        if fax.preturn==1
            %update ax remainders parameters only if amag is larger than last
            if fax.fmax>fs.axrmag
                fs.axrpeak=1;
                fs.axrmag=fax.fmax;
                fs.axr_angle=fs.fc;
            end
        end
        %check to see if fc is greater than fthresh
        if fs.fc>fs.fthresh
            %if this is true, exit algorithm and return peak
            fs.state=0;
            fs.preturn=1;
        else
            %if not, check for fmax2 udpate
            if fs.fc>fs.fmax2
                fs.fmax2=fs.fc;
                fs.tfmax2=fs.tc;
            else
                %if past the peak, now check for final exit condition
                if fs.fdot>fs.fdot_plus && fs.fc<((fs.fmax2-(fs.fmax2-fs.fend)/3))
                    %exit algorithm and set to state 0 and set peak2
                    %flag and preturn flag
                    fs.state=0;
                    fs.preturn=1;
                    fs.peak2=1;
                    %return tend2 and fend2
                    fs.tend2=fs.tc; fs.fend2=fs.fc;
                    %return 2nd peak width/height
                    fs.dtpeak2=fs.tend2-fs.tend;
                    fs.dfpeak2=fs.fmax2-fs.fend;
                    %transfer the remainder for ax to ax2 if larger
                    %than existing ax2mag
                    if fs.axrmag>fs.ax2mag
                        fs.ax2peak=1;
                        fs.ax2mag=fs.axrmag;
                        fs.ax2_angle=fs.axr_angle;
                    end
                    %don't use a remainder in this case
                    fs.rflag=0;
                    fs.axrpeak=0;
                    fs.axrmag=0;
                    fs.axr_angle=0;
                    %and return modified peak width/height using 2nd
                    %peak
                    fs.dtpeak=fs.tend2-fs.tstart;
                    fs.dfpeak=fs.fmax-(fs.fstart+fs.fmax2)/2;
                end
            end
        end   
    otherwise
        %'WTF?'
        %state
end
%-------------end function code--------------------------------