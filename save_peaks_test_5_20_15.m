%This script saves variables for test plotting

%now save ax peak data for test plotting
    if fax.preturn==1
        %unload arrays
%         if ax_type==1 %load into standard impact peak array
            ax_fmax_array(ax_count+1)=fax.fmax;
            ax_tfmax_array(ax_count+1)=fax.tfmax;
            ax_dtpeak_array(ax_count+1)=fax.dtpeak;
            ax_dfpeak_array(ax_count+1)=fax.dfpeak;
%         else
%             axD_fmax_array(axD_count+1)=fax.fmax;
%             axD_tfmax_array(axD_count+1)=fax.tfmax;
%             axD_dtpeak_array(axD_count+1)=fax.dtpeak;
%             axD_dfpeak_array(axD_count+1)=fax.dfpeak;
%         end
    end
    
    %and save ang peak data for test plotting
     %and save ang peak data for test plotting
    if fang.preturn==1

        ang_fstart_array(ang_count+1)=fang.fstart;
        ang_fmax_array(ang_count+1)=fang.fmax;
        ang_fend_array(ang_count+1)=fang.fend;
        
        ang_tstart_array(ang_count+1)=fang.tstart;
        ang_tfmax_array(ang_count+1)=fang.tfmax;
        ang_tend_array(ang_count+1)=fang.tend;
%         
%         ang_ft1_array(ang_count+1)=fang.ft1;
%         ang_ft2_array(ang_count+1)=fang.ft2;
%         
%         ang_tt1_array(ang_count+1)=fang.tt1;
%         ang_tt2_array(ang_count+1)=fang.tt2;

    end
    
    %save second peak for plotting
    if fang.peak2==1
        ang_tp2(ang_count2+1)=fang.tfmax2;
        ang_fp2(ang_count2+1)=fang.fmax2;
        
        ang_tend2(ang_count2+1)=fang.tend2;
        ang_fend2(ang_count2+1)=fang.fend2;
        
    end
    
    %and save ang peak data for test plotting
    if fahip.preturn==1
        
        ahip_fstart_array(ahip_count+1)=fahip.fstart;
        ahip_fmax_array(ahip_count+1)=fahip.fmax;
        ahip_fend_array(ahip_count+1)=fahip.fend;
        
        ahip_tstart_array(ahip_count+1)=fahip.tstart;
        ahip_tfmax_array(ahip_count+1)=fahip.tfmax;
        ahip_tend_array(ahip_count+1)=fahip.tend;
        
        ahip_ft1_array(ahip_count+1)=fahip.fthresh1;
        ahip_ft2_array(ahip_count+1)=fahip.fthresh2;
        
        ahip_tt1_array(ahip_count+1)=fahip.tthresh1;
        ahip_tt2_array(ahip_count+1)=fahip.tthresh2;
    end
    
    %now count motions recognized and reset md state machine
    if md.preturn==1
        
        mdhip(md_count+1)=md.hip;
        mdtype(md_count+1)=md.type;
        mdwidth(md_count+1)=md.width;
        mdangreturn(md_count+1)=fang.preturn;
        mdahipreturn(md_count+1)=fahip.preturn;
        mdang_tend(md_count+1)=md.ang_tend;
        mdang_tstart(md_count+1)=md.ang_tstart;
        mdahip_tend(md_count+1)=md.ahip_fend;
        mdahip_tstart(md_count+1)=md.ahip_fstart;
        mdtpeak(md_count+1)=md.ang_tfmax;
        mdahipdot(md_count+1)=md.ahipdot;
        mdadiff_start(md_count+1)=md.adiff_start;
        mdadiff_end(md_count+1)=md.adiff_end;
        mdtdelay(md_count+1)=md.tdelay;
        mdtdelay2(md_count+1)=md.tdelay2;

        %save all the bends for testing
        bend_save{md_count+1}=md.bend_data;
        
        
        
    end
    
    %save some other test stuff
    mdstate(m)=md.state;
    fahipstate(m)=fahip.state;
    fangstate(m)=fang.state;
    axpreturn(m)=fax.preturn;
    fangpflag(m)=fang.pflag;
    mdax1(m)=md.ax1peak;
    mdax2(m)=md.ax2peak;
    
    %and save ax_mean*scale from running average for plotting
    amean(m)=fax.fthresh;
    angmean(m)=fang.fthresh;
    ahipmean(m)=fahip.fthresh;
    state(m)=fang.state;
    pflag(m)=fang.pflag;
    ahip(m)=fahip.fc;