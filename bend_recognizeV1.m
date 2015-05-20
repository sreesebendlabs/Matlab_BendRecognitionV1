%This is the FSM bend recognition function

function md=bend_recognizeV1(md,fang,fahip)

%---------------start state machine function--------------------------
%there are five states, use switch to choose between them
switch true
    case md.state==0
        %check to see if either ang or ahip are in state>0 using switch
        %case
        switch true
            case fang.state>0
                %get start point
                md.tstart=fang.tstart;
                %set state to 1
                md.state=1;
            case fahip.state>0
                %get start point
                md.tstart=fahip.tstart;
                %set state to 1
                md.state=2;
            case fang.state>0 && fahip.state>0
                %now check to make sure knee and ahip start points are
                %close enough to be same bend
                if abs(fang.tstart-fahip.tstart)<md.tshift_min
                    %get start point
                    md.tstart=fahip.tstart;
                    %set state to 3
                    md.state=3;
                end
             otherwise
                %we stay in state 0
        end
    %state 1 is when just the knee angle is active
    case md.state==1
        %now check to see if ahip is in active state, if so, switch
        %to state 3
        if fahip.state>0
            %switch states, but only if knee and ahip are from same
            %bend
            if abs(fang.tstart-fahip.tstart)<md.tshift_min
                md.state=3;
            end
        end
    %state 2 is when just the hip angle is active   
    case md.state==2
         %in this state, we just check to see if ang is active, if so,
         %switch to state 3
         if fang.state>0
             %switch states, but only if knee and ahip are from same
            %bend
            if abs(fang.tstart-fahip.tstart)<md.tshift_min
                md.state=3;
            end
         end
    %state 3 is where most time will be spent
    case md.state==3
        %check to see if ahip returns a bend, if so, go to state 4
        if fahip.preturn==1
            %change state
            md.state=4;
            %save ahip bend parameters
            md.ahip_tstart=fahip.tstart;
            md.ahip_fstart=fahip.fstart;
            md.ahip_tfmax=fahip.tfmax;
            md.ahip_fmax=fahip.fmax;
            md.ahip_tend=fahip.tend;
            md.ahip_fend=fahip.fend;
        end
        %check to see if ang returns a bend, if so, go to state 5
        if fang.preturn==1
            %change state
            md.state=5;
            %save knee ang bend parameters
            md.ang_tstart=fang.tstart;
            md.ang_fstart=fang.fstart;
            md.ang_tfmax=fang.tfmax;
            md.ang_fmax=fang.fmax;
            if fang.peak2==1 %make sure to save right end point
                md.ang_tend=fang.tend2;
                md.ang_fend=fang.fend2;
            else
                md.ang_tend=fang.tend;
                md.ang_fend=fang.fend;
            end
            md.ang_ax1peak=fang.ax1peak;
            md.ang_ax1mag=fang.ax1mag;
            md.ang_ax1_angle=fang.ax1_angle;
            md.ang_ax2peak=fang.ax2peak;
            md.ang_ax2mag=fang.ax2mag;
            md.ang_ax2_angle=fang.ax2_angle;

        end
        %check to see if both ang and ahip return a bend.  If so,
        %transition directly to state 6 and get end time
        if fang.preturn==1 && fahip.preturn==1
            %get time
            md.tend=fang.tend;
            %set state
            md.state=6;
             %save knee ang bend parameters
             %---start question mark code
            md.ang_tstart=fang.tstart;
            md.ang_fstart=fang.fstart;
            md.ang_tfmax=fang.tfmax;
            md.ang_fmax=fang.fmax;
            if fang.peak2==1 %make sure to save right end point
                md.ang_tend=fang.tend2;
                md.ang_fend=fang.fend2;
            else
                md.ang_tend=fang.tend;
                md.ang_fend=fang.fend;
            end
            md.ang_ax1peak=fang.ax1peak;
            md.ang_ax1mag=fang.ax1mag;
            md.ang_ax1_angle=fang.ax1_angle;
            md.ang_ax2peak=fang.ax2peak;
            md.ang_ax2mag=fang.ax2mag;
            md.ang_ax2_angle=fang.ax2_angle;
            %save ahip bend parameters
            md.ahip_tstart=fahip.tstart;
            md.ahip_fstart=fahip.fstart;
            md.ahip_tfmax=fahip.tfmax;
            md.ahip_fmax=fahip.fmax;
            md.ahip_tend=fahip.tend;
            md.ahip_fend=fahip.fend;
            %------end question mark code
        end

        %finally check to make sure ang state machine has not reverted
        %back to a 0 state. If so, revert md to zero state and restart
        %md.ax parameters
        if fang.state==0 && fang.preturn==0
            %reset
            md.state=0;
%                 fang.ax1peak=0;
%                 fang.ax1mag=0;
%                 fang.ax1_angle=0;
%                 fang.ax2peak=0;
%                 fang.ax2mag=0;
%                 fang.ax2_angle=0;
            md.ang_ax1peak=0;
            md.ang_ax1mag=0;
            md.ang_ax1_angle=0;
            md.ang_ax2peak=0;
            md.ang_ax2mag=0;
            md.ang_ax2_angle=0;
        end
    %state 4 is when ahip has returned a bend and we are waiting for
    %knee ang to return a bend. During this time, we need to keep
    %updating the ang.ax parameters
    case md.state==4
        %now check to see if knee ang returns a bend, if so, move to
        %state 6 and get end time and save knee ang parameters
        if fang.preturn==1
            %get time
            md.tend=fang.tend;
            %set state
            md.state=6;
            %save knee ang bend parameters
            md.ang_tstart=fang.tstart;
            md.ang_fstart=fang.fstart;
            md.ang_tfmax=fang.tfmax;
            md.ang_fmax=fang.fmax;
            if fang.peak2==1 %make sure to save right end point
                md.ang_tend=fang.tend2;
                md.ang_fend=fang.fend2;
            else
                md.ang_tend=fang.tend;
                md.ang_fend=fang.fend;
            end
            md.ang_ax1peak=fang.ax1peak;
            md.ang_ax1mag=fang.ax1mag;
            md.ang_ax1_angle=fang.ax1_angle;
            md.ang_ax2peak=fang.ax2peak;
            md.ang_ax2mag=fang.ax2mag;
            md.ang_ax2_angle=fang.ax2_angle;
        elseif fang.state==0
            %if this happens, return to state 0
            md.state=0;
        end
    %state 5 is when knee ang returns a bend and we are waiting on ahip
    %to return a bend.  We need to be sure to check to see if ahip
    %state machine is still active, if not, we'll move to state 6 and
    %trigger a flag that says we have no ahip bend for this bend
    case md.state==5
        %check to see if hip bend is complete, if so, move to state
        %6, then get end time and save knee ang parameters
        if fahip.preturn==1
            %change state
            md.state=6;
            %get end time
            md.tend=fahip.tend;
            %save ahip bend parameters
            md.ahip_tstart=fahip.tstart;
            md.ahip_fstart=fahip.fstart;
            md.ahip_tfmax=fahip.tfmax;
            md.ahip_fmax=fahip.fmax;
            md.ahip_tend=fahip.tend;
            md.ahip_fend=fahip.fend;
        end
        %first check to see if ahip state machine is active, if not,
        %set noahip flag and move to state 6, then get end time and
        %knee ang parameters
%------------------------------------------------------------------
        if fahip.state==0 && fahip.preturn==0
            %update md.noahip
            md.noahip=1;
            %move to state 6
            md.state=6;
            %get end time
            md.tend=fang.tend;
        else
            md.noahip=0;
        end
%-------------------------------------------------

    %state 6 lasts a single iteration and does final bend recognition
    %and returns all values and then resets md state to 0
    case md.state==6
        %reset bend data
        md.bend_data=[0,0,0,0,0,0,0,0,0,0,0,0,0];
        %'bend recognized'
        %update bend count
        md.count=md.count+1;
        %return flag
        md.preturn=1;
        %move back to zero state
        md.state=0;
        %output test data
        %[md.ax1peak,md.ax2peak,md.noahip,md.hip,md.type]
        %compute the difference in min values between knee ang and ahip
        %for start and end points
        md.adiff_start=(md.ahip_fstart-md.ang_fstart)/md.ang_fmax;
        md.adiff_end=(md.ahip_fend-md.ang_fend)/md.ang_fmax;
        %[md.adiff_start,md.adiff_end]

        %compute time delay between hip and knee peaks
        %optional, not used as of 5/16/15
        %{
        if md.noahip==1
            %in this case, there is no time delay
            md.tdelay=0;
            %'test'
        else
            md.tdelay=md.ang_tfmax-md.ahip_tfmax;
            md.tdelay2=(md.ang_tfmax-md.ahip_tfmax)/(md.ang_tend-md.ang_tstart);
        end
        %}

        %now determine what type of hip angle you have using a case
        %switch
        switch true
            %no ahip bend case
            case md.noahip==1
                md.hip=1;
                %'test1'
            %for forward motion, where start/end point are both much
            %lower for the hip than the knee angle points, also this
            %happens in biking, where there is a threshold difference
            case md.adiff_start<=md.ahip_diff && md.adiff_end<=md.ahip_diff
                md.hip=2;
                %'test2'
            %this is for a stopping motion, where the start point of
            %the hip angle is lower than the knee angle but not for the
            %end point, where there is a threshold difference
            case md.adiff_start<=md.ahip_diff && md.adiff_end>(md.ahip_diff/4)
                md.hip=3;
                %'test3'
            %this is for when the start and end points are greater than
            %the threshold value for the hip than the knee
            case md.adiff_start>md.ahip_diff && md.adiff_end>md.ahip_diff
                md.hip=4;
                %'test4'
            otherwise
                %'wtf in switch case for hip type selection'
                %md.hip=1;

        end
        %[md.ax1peak,md.ax2peak,md.noahip,md.hip,md.type]
        %now determine bend type with switch
        switch true
            %this is for "none"
            case md.hip==1
                %this bend type is unclassified
                md.type=1;
                md.count1=md.count1+1;
                md.count_temp=md.count1;
            %this if for forward motion (walk/jog/run) and biking
            %first check to see if it's biking, where the min hip
            %angles are greater than a threshold
            case md.hip==2
                %first see if it's a bikind bend by seeing if min hip
                %values are greater than md.ahip_low.  Just use start
                %point for now
                if md.ahip_fstart>md.ahip_low
                    %this is biking
                    md.type=6;
                    md.count6=md.count6+1;
                    md.count_temp=md.count6;
                else
                    %if not, then this is a walk type bend
                    %first get peak width
                    md.width=md.ang_tend-md.ang_tstart;
                    md.ahipdot=2*(md.ahip_fmax-md.ahip_fstart)/md.width;
                    %switch case
                    switch true
                        case md.ahipdot<=md.walk_thresh
                            md.type=2; %walk
                            md.count2=md.count2+1;
                            md.count_temp=md.count2;
                        case md.ahipdot>md.walk_thresh && md.ahipdot<=md.jog_thresh
                            md.type=3; %jog
                            md.count3=md.count3+1;
                            md.count_temp=md.count3;
                        case md.ahipdot>md.jog_thresh
                            md.type=4; %run
                            md.count4=md.count4+1;
                            md.count_temp=md.count4;
                    end
                end
            %this one is for breaking, or forward cut/stop
            case md.hip==3
                %cut
                md.type=5; 
                md.count5=md.count5+1;
                md.count_temp=md.count5;
            %this one is for jumping and its variants.  Use case switch
            %to determine which jump
            case md.hip==4
%                     'start'
%                     ang_count
%                     [md.ax1peak,md.ax2peak]
                % [md.ang_ax1peak,md.ang_ax2peak]
%                     'end'
                switch true
                    %this is a squat motion
                    case md.ang_ax1peak==0 && md.ang_ax2peak==0
                        %use min knee angle to check for biking, also
                        %use diff betwen knee an dhip
                        if md.ang_fstart>md.ang_diff && (md.ang_fstart-md.ahip_fstart)>md.ang_diff
                            md.type=6;
                            md.count6=md.count6+1;
                            md.count_temp=md.count6;
                        else
                            md.type=7; %squat
                            md.count7=md.count7+1;
                            md.count_temp=md.count7;
                        end
                    %this one is for landing
                    case md.ang_ax1peak==1 && md.ang_ax2peak==0
                        md.type=8; %landing
                        md.count8=md.count8+1;
                        md.count_temp=md.count8;
                    %this one is a jump from stop
                    case md.ang_ax1peak==0 && md.ang_ax2peak==1
                        md.type=9; %jump from stop
                        md.count9=md.count9+1;
                        md.count_temp=md.count9;
                    %this is a land/jump
                    case md.ang_ax1peak==1 && md.ang_ax2peak==1
                        md.type=10; %land/jump
                        md.count10=md.count10+1;
                        md.count_temp=md.count10;
                    otherwise
                        %'wtf in hip4 switch'
                end
            otherwise
                %missed bends
                md.type=11;
                md.count11=md.count11+1;
                md.count_temp=md.count11;
                md.hip
        end
        %return final data for bend
        %bend_data=[Rtflag,type,ax1mag,ax2mag,power,minROM,maxROM,accAngle,impactAngle,count,bendDuration,tbd2,time];
        md.bend_data=[1,md.type,md.ang_ax1mag,md.ang_ax2mag,0,(md.ang_fstart+md.ang_fend)/2,...
        md.ang_fmax,md.ang_ax1_angle,md.ang_ax2_angle,md.count_temp,(md.ang_tend-md.ang_tstart),0,md.ang_tfmax];
        %optinoal print out of bend data
        %md.bend_data
    otherwise
        %'WTF in main switch of bend recoginition state machine'
end
    