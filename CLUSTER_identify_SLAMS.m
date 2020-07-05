function [SLAMS_lim, SLAMS_limvec2, SLAMSt] = CLUSTER_identify_SLAMS(B, Bmean, Bmean2, gseBmean, values, startdate)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 
global gse_deltaB

SLAMS = [];
lim = 2.5; %SLAMS limit lim*Bmean
deltaB = [];
t = [];

for i = 1:length(B)
    if B(i)/Bmean(i) >= lim %Def of SLAMS
        SLAMS = [SLAMS; 1];
        deltaB = [deltaB; B(i)/Bmean(i)];
        t = [t; gseBmean(i,1)];
        
    else
        SLAMS = [SLAMS; 0];
    end
end
gse_deltaB = [t deltaB];

time = gseB1(values,1);

if sum(SLAMS) > 0
        SLAMS_starttime = [];
        SLAMS_stoptime = [];
        i = 0;
        while i < length(SLAMS)
            i= i+1;
            if SLAMS(i) == 1
                SLAMS_starttime = [SLAMS_starttime; time(i,1)];
                while SLAMS(i) == 1 && i ~= length(SLAMS)
                    i = i+1;
                end
                if SLAMS(i) == 0 && SLAMS(i+1) == 1
                    i = i+1;
                    while SLAMS(i) == 1 && i ~= length(SLAMS)
                    i = i+1;
                    end
                end
                SLAMS_stoptime = [SLAMS_stoptime; time(i,1)];
            end
        end
% Put smal SLAMS together
%     if length(SLAMS_starttime) > 2
%         i = 1;
%         n = length(SLAMS_starttime)-1;
%         while i < n
%             delta = SLAMS_starttime(i+1)-SLAMS_stoptime(i); 
%             if delta < 10
%                 SLAMS_stoptime(i) = SLAMS_stoptime(i+1);
%                 SLAMS_starttime(i+1) = [];
%                 SLAMS_stoptime(i+1) = [];
%                 i = i-1;
%             end
%             i = i+1;
%             if i == length(SLAMS_starttime)
%                 break
%             end
%         end
%     end
    SLAMS_time = [SLAMS_starttime SLAMS_stoptime]; %epoch format
end

if sum(SLAMS) > 0
    disp(['Amount of SLAMS on ', num2str(startdate(1)), '-', num2str(startdate(2)), '-', num2str(startdate(3)) ': ', num2str(length(SLAMS_starttime))])
else
    disp(['Amount of SLAMS on ', num2str(startdate(1)), '-', num2str(startdate(2)), '-', num2str(startdate(3)) ': 0'])
end


%% Time vectors

    SLAMS_lim = [gseBmean(:,1) lim*gseBmean(:,2)];
    SLAMS_lim2 = Bmean2*lim;
    SLAMS_limvec2 = [gseB1(values, 1) SLAMS_lim2*ones(length(gseB1(values, 1)),1)];
    
if sum(SLAMS) > 0
    %UTC format
    SLAMS_start_utc=irf_time(SLAMS_time(:,1),'utc');
    SLAMS_stop_utc=irf_time(SLAMS_time(:,2),'utc');

    %Vector format
    SLAMS_start_vec=irf_time(SLAMS_time(:,1),'vector');
    SLAMS_stop_vec=irf_time(SLAMS_time(:,2),'vector');

    SLAMS_time_utc = [SLAMS_start_utc, SLAMS_stop_utc]; %UTC format
    SLAMS_time_vec = [SLAMS_start_vec, SLAMS_stop_vec]; %vector format

    SLAMSt = [SLAMS_time SLAMS_time_vec];
else
    SLAMSt = [];
end 

end