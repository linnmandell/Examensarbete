function CLUSTER_save_SLAMS_excel(SLAMS,date,n, time_solarwind, SLAMS_distance)

data_dir = '/Volumes/Kun_KTH/Linn/SLAMS_excel/';

%% MOVE TO CORRECT DIRECTORY
old_dir = cd;
yr = int2str(date(1));
mo = date(2);
if mo < 10
    mo = ['0' int2str(mo)];
else
    mo = int2str(mo);
end
da = date(3);
if da < 10
    da = ['0' int2str(da)];
else
    da = int2str(da);
end

da2 = date(3)+n-1;
if da2 < 10
    da2 = ['0' int2str(da2)];
else
    da2 = int2str(da2);
end

cd(data_dir)

T = table(SLAMS(:,1), SLAMS(:,2), SLAMS(:,3), SLAMS(:,4), SLAMS(:,5), SLAMS(:,6), SLAMS(:,7), SLAMS(:,8), SLAMS(:,9), SLAMS(:,10), SLAMS(:,11), SLAMS(:,12), SLAMS(:,13), SLAMS(:,14));
T.Properties.VariableNames  = {'SLAMS_start_UTC' 'SLAMS_stop_UTC' 'year_start' 'month_start' 'day_start' 'hour_start' 'minute_start' 'second_start' 'year_stop' 'month_stop' 'day_stop' 'hour_stop' 'minute_stop' 'second_stop'};

time = [1:1:length(time_solarwind)]';
K = table(time, time_solarwind);
K.Properties.VariableNames = {'Date' 'Time_in_solar_wind_in_min'};

H = table(SLAMS_distance(:,1), SLAMS_distance(:,2), SLAMS_distance(:,3), SLAMS_distance(:,4));
H.Properties.VariableNames = {'x_position' 'y_position' 'z_position' 'radius'};

writetable(T, ['SLAMS_' yr mo da '-' yr mo da2 '_12min.xlsx'], 'Sheet',1,'Range','A1')
writetable(K, ['SLAMS_' yr mo da '-' yr mo da2 '_12min.xlsx'], 'Sheet',2,'Range','A1')
writetable(H, ['SLAMS_' yr mo da '-' yr mo da2 '_12min.xlsx'], 'Sheet',3,'Range','A1')
end