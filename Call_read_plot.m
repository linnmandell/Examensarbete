%% Plot data
clc, clear all 
%close all
tic
start_date = [2001 12 01]; 
enddate = [2001 12 31]; 

SLAMS_load_data(start_date,enddate)

 %% Locate the solar wind and SLAMS, plot and save full days and SLAMS
SLAMS = [];
SLAMS_distance = [];
time_solarwind = [];
dist_bowshock = [];
n = (enddate(1,3) - start_date(1,3))+1;

for i = 1:n %amount of days gone through
  try
        startdate = start_date + [0 0 (i-1)];
        CLUSTER_read_data(startdate)
        [SLAMSt , time_solarwindt, SLAMS_dist] = CLUSTER_SLAMS(startdate);
        SLAMS = [SLAMS ; SLAMSt];
        SLAMS_distance = [SLAMS_distance; SLAMS_dist];
        time_solarwind = [time_solarwind; time_solarwindt];
        orbitplot(startdate, SLAMSt)
        dist_bowshockt = CLUSTER_distbowshock(SLAMSt);
        dist_bowshock = [dist_bowshock; dist_bowshockt];
        SLAMS_Mach_plot(SLAMSt)
        CLUSTER_plot_slams_SC1(startdate, startdate + [0 0 1])
        CLUSTER_plot_slams_SC1([startdate 06 05 00], [startdate 06 14 00])
        CLUSTER_save_fig_fullday(startdate) %save full day plots
        if ~isempty(SLAMSt)
           CLUSTER_mark_SLAMS(SLAMSt) %Mark SLAMS
           
           %Plot close up of SLAMS and save figures
           for j = 1:length(SLAMSt(:,1))
                CLUSTER_closeup(SLAMSt(j,:),j)
           end
        end 
  catch
      disp(['Error on ', num2str(startdate(1)), '-', num2str(startdate(2)), '-', num2str(startdate(3))])
      time_solarwind = [time_solarwind; 0];
  end
end


%% Time in the solarwind
time_solarwind = time_solarwind/60; %[min]

%% Amount of SLAMS and saving SLAMS as xlsx
if ~isempty(SLAMS)
    disp(['Total amount of SLAMS in this data: ' num2str(length(SLAMS(:,1)))])
    
    prompt = 'Do you want to save SLAMS times as excel file? (y/n) ';
    str = input(prompt, 's');
    if str == 'y'
        CLUSTER_save_SLAMS_excel(SLAMS,start_date, n, time_solarwind, SLAMS_distance) %save SLAMS times as excel
    end
else
    disp('Total amount of SLAMS in this data: 0')
end
toc

