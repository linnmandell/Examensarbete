function CLUSTER_closeup(SLAMS,i)

start_SLAMS = SLAMS(1,3:7);
stop_SLAMS  = SLAMS(1,9:13);

start = SLAMS(1)-60; %1min before start of SLAMS in epoch
stop = SLAMS(2)+60; %1min after end of SLAMS in epoch

startplot = irf_time(start, 'vector'); %1min before start of SLAMS in utc
stopplot = irf_time(stop, 'vector'); %1min after end of SLAMS in utc

startplot = [startplot(1:5) floor(startplot(6))]; %round seconds down to not get problem with 60s
stopplot = [stopplot(1:5) floor(stopplot(6))]; %round seconds down to not get problem with 60s

CLUSTER_plot_slams_SC1(startplot, stopplot) %plot only the SLAMS +-1min
CLUSTER_mark_SLAMS(SLAMS(1,:)) %mark the SLAMS
CLUSTER_save_fig(start_SLAMS,i) %save figure as date of SLAMS and the sequence of the SLAMS for that day
close %close the figure

end