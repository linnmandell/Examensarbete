
function [SLAMSt, time_solarwind, SLAMS_dist] = CLUSTER_SLAMS(startdate)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4 gseB;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 
global gseBmean SLAMS_lim B startsolarwind stopsolarwind startsolarwind2 stopsolarwind2 startsolarwind3 stopsolarwind3;

%% Find solar wind
[solarwind, time] = CLUSTER_find_solarwind;

tf = ~isnan(solarwind);

if ~isempty(solarwind) && sum(sum(tf)) > 310
    % Magnetic field
    [B, gseB, values, startsolarwind, stopsolarwind, startsolarwind2, stopsolarwind2, startsolarwind3, stopsolarwind3] = CLUSTER_B(solarwind, time);
    
    %Compute total time in the solar wind
    if isempty(startsolarwind)
        time_solarwind = 0;
    elseif isempty(stopsolarwind2)
        time_solarwind = stopsolarwind-startsolarwind;
    elseif isempty(stopsolarwind3)
        time_solarwind = stopsolarwind-startsolarwind+stopsolarwind2-startsolarwind2;
    else
        time_solarwind = stopsolarwind-startsolarwind+stopsolarwind2-startsolarwind2+stopsolarwind3-startsolarwind3;
    end
    
    % Mean value of B
    [Bmean, Bmean2, gseBmean, gseBmean2] = CLUSTER_Bmean(B, values);
    
    SLAMS_dist = [];
  if ~isempty(Bmean)
    % Identify SLAMS
    [SLAMS_lim, SLAMS_limvec2, SLAMSt] = CLUSTER_identify_SLAMS(B, Bmean, Bmean2, gseBmean, values, startdate);
    if ~isempty(SLAMSt)
        
        for i = 1:length(SLAMSt(:,1))
            v = find(gseR1(:,1)>=SLAMSt(i,1));
            dist = gseR1(v(1),2:5);
            SLAMS_dist = [SLAMS_dist; dist];
        end
    end
    
  else
        disp(['Not in the solarwind on: ' num2str(startdate(1)), '-', num2str(startdate(2)), '-', num2str(startdate(3))])
        SLAMSt = [];
        time_solarwind = 0;
  end
    
else
    disp(['Not in the solarwind or not enough data on: ' num2str(startdate(1)), '-', num2str(startdate(2)), '-', num2str(startdate(3))])
    SLAMSt = [];
    SLAMS_dist = [];
    startsolarwind = [];
    stopsolarwind = [];  
    startsolarwind2 = [];
    stopsolarwind2 = [];
    B = [];
    gseB = [];
    gseBmean = [];
    time_solarwind = 0;
end

end

