function [solarwind, time] = CLUSTER_find_solarwind

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 


flux = ifluxhia1.data; %E
time2 = itimeshia1.data; %time vector of E

val = find((modecis1(:,1)>=time2(1)) & (modecis1(:,1)<=time2(end))); %find the modes for the times E is defined
modecis_vec = modecis1(val,2); %pick out the modes for the times E is defined

%% Find solar wind
% Only pick values for positive x values
    time_Rval = find((gseRE1(:,2)>=0)); %find all times x>0
    time_R = gseRE1(time_Rval,1); %pick out the times x>0
    t = find((time2>=time_R(1)) & (time2<=time_R(end))); %find these times in E

    flux = flux(t,:); %E only with positive x
    time = time2(t,:); %times with only positive x
    
solarwind = [];
for i = 2:length(flux)-2
    val2 = find((modecis1(:,1)>=time(i-1)) & (modecis1(:,1)<=time(i+2)));
    modecis = modecis1(val2,2);
    if isempty(modecis) || modecis(1) >= 6  %not in the solar wind mode
        maxval = max([flux(i,10) flux(i,11) flux(i,12) flux(i,13) flux(i,14) flux(i,15)]);
        if  maxval >= 10^3
            %The fraction between medium energy flux and low energy flux 
            delta = max([flux(i,10) flux(i,11) flux(i,12) flux(i,13) flux(i,14) flux(i,15)])/(1+flux(i,20));

            %Solar wind or not
            if delta > 10^3 %solarwind
                solarwind = [solarwind; flux(i,:)];
            else %not in the solarwind
                solarwind = [solarwind; NaN*ones(1,31)];
            end
        else %not in the solar wind
            solarwind = [solarwind; NaN*ones(1,31)];
        end
    elseif modecis(1) <= 5 && flux(i,22) > 10^2 %in the solar wind mode but the energy flux is high
        maxval = max([flux(i,10) flux(i,11) flux(i,12) flux(i,13) flux(i,14) flux(i,15)]);
        if  maxval >= 10^3
            %The fraction between medium energy flux and low energy flux 
            delta = max([flux(i,10) flux(i,11) flux(i,12) flux(i,13) flux(i,14) flux(i,15)])/(1+min([flux(i,22) flux(i,21) flux(i,20)]));

            %Solar wind or not
            if delta > 10^3 %solarwind
                solarwind = [solarwind; flux(i,:)];
            else %not in the solarwind
                solarwind = [solarwind; NaN*ones(1,31)];
            end
        else %not in the solar wind
            solarwind = [solarwind; NaN*ones(1,31)];
        end
    else %in the solar wind mode and the energy flux is low
        solarwind = [solarwind; flux(i,:)];
    end
end

if ~isempty(solarwind)
% Compensate for lost rows
    % Last rows
    if isnan(solarwind(end,1)) && isnan(solarwind(end-1,1))
        solarwind = [solarwind; NaN*ones(1,31); NaN*ones(1,31)];
    else
        solarwind = [solarwind; flux(end-1,:); flux(end,:)];
    end
    %First rows
    if isnan(solarwind(1,1)) && isnan(solarwind(2,1))
        solarwind = [NaN*ones(1,31); solarwind];
    else
        solarwind = [flux(1,:); solarwind];
    end

%If only one is/is not NaN change that one
    for i = 3:(length(flux)-2)
        if ~isnan(solarwind(i-1,1)) && ~isnan(solarwind(i+1,1)) && isnan(solarwind(i,1))
            solarwind(i,:) = flux(i,:);
        end
        if isnan(solarwind(i-1,1)) && isnan(solarwind(i+1,1)) && ~isnan(solarwind(i,1))
            solarwind(i,:) = NaN*ones(1,31);
        end

    end
end



end