function SLAMS_load_data(startdate,enddate)

%Input in form [2002 01 01]

starttime = [startdate 00 00 00];
starttime = irf_time(starttime);
endtime = [enddate 23 59 59];
endtime = irf_time(endtime);

% Use double backslashes
%SLAMS_data_dir = 'E:\\Data\\Cluster\\SLAMS';
%SLAMS_data_dir = 'Users:\\linnmandell\\Documents\\Documents\\KTH\\Ex-jobb\\SLAMS';
%SLAMS_data_dir = '/Users/linnmandell/Documents/Documents/KTH/Ex-jobb/SLAMS/';
SLAMS_data_dir = '/Volumes/Kun_KTH/Linn/SLAMS/';

t1 = starttime;
 while t1 <= endtime 
     t2 = t1 + 24*60*60 - 1;
     load_CAA_SLAMS(t1,t2,SLAMS_data_dir);
     t1 = t1 + 24*60*60;
 end




