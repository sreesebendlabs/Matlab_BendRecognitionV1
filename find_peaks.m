    %This function performs peak detection
function fs=find_peaks(fs)
    
%%%%start algorithm%%%
    %initialize variables
    slope=0; b=0;
    %check to see if pflag from last iteration is true
    if fs.pflag==1
        %if pflag is true for last iteration, check to see if it's true for
        %the current iteration, if so, continue algorithm
        if fs.fc>fs.fthresh
            %update fmax and tfmax
            if fs.fc>fs.fmax
                fs.fmax=fs.fc;
                fs.tfmax=fs.tc;
            end
            %update tend
            fs.tend=fs.tc;
        else %if fc~>fthresh, end algorithm by computing dtpeak and dfpeak
            %set pflag=0
            fs.pflag=0;
            %but only compute values if greater than min time width, also
            %set preturn=1 to signify a peak has been counted
            %also find slope of line and compute time for thresh crossing
            %if (tend-tstart)>tmin
            if (fs.fmax-fs.fthresh)>fs.fdiff_min && (fs.tend-fs.tstart)<fs.tmax
                fs.preturn=1;
                %first get slope and intercept from current and last values
                slope=(fs.fc-fs.fl)/(fs.tc-fs.tl);
                b=fs.fc-slope*fs.tc;
                %and find time when the function crosses thresh
                fs.tc=(fs.fthresh-b)/slope;
                %and set tend=tc
                fs.tend=fs.tc;
                %compute width and height of peak
                fs.dtpeak=fs.tend-fs.tstart;
                fs.dfpeak=fs.fmax-fs.fthresh;
            else %set preturn=0 so it's skipped
                fs.preturn=0;
            end
        end   
    else
        %if pflag is not true for last iteration, check to see if it's true
        %for current iteration, if so, start algorithm
        if fs.fc>fs.fthresh
            %set flag variables
            fs.pflag=1; fs.preturn=0;
            %now get threshold point since our sampling is low
            %first get slope and intercept from current and last values
            slope=(fs.fc-fs.fl)/(fs.tc-fs.tl);
            b=fs.fc-slope*fs.tc;
            %and find time when the function crosses thresh and set as last
            %time point, also set thresh as last point
            fs.tl=(fs.fthresh-b)/slope;
            fs.fl=fs.fthresh;
            %initialize working variables
            fs.tstart=fs.tl; fs.tend=fs.tc;
            fs.fmax=fs.fc; fs.tfmax=fs.tc;        
        end
    end
    %
    %end algorithm

    