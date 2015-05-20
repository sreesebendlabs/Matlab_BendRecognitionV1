%This function computes the exponential running average for a data series 
%it takes as inputs alpha, which is the exponential scaling factor, the
%current function value and the past mean value.  It outputs the current
%running average

function f_mean=exp_running_average(f_current,f_mean_past,alpha)

f_mean= alpha*f_current+(1-alpha)*f_mean_past;