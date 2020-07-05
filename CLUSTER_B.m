function[B, gseB, values, starttime1, stoptime1, starttime2, stoptime2, starttime3, stoptime3] = CLUSTER_B(solarwind, time)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3;

% Initial values
    starttime1 = [];
    stoptime1 = [];
    starttime2 = [];
    stoptime2 = [];
    starttime3 = [];
    stoptime3 = [];
    B = [];
    gseB = [];
    values = [];
    runs = 0;
    startstep = [];
    stopstep = 0;
    n = 100;

% Vector of 1 in the solarwind and NaN elsewhere
NaNvec = zeros(1, length(solarwind));
for i = 1: length(solarwind)
    if isnan(solarwind(i,1))
        NaNvec(1,i) = NaN;
    else
        NaNvec(1,i) = 1;
    end
end
sumNaNlim = 300;
sumNaN = sum(NaNvec, 'omitnan');

%% Loop of entries into the solar wind, max 3 entries
while sumNaN > sumNaNlim
    sumNaNlim = 1000;
    Bstep = 200;
    delta_t = 0;
    runs = runs + 1;
    while Bstep > 70 || delta_t < 3000 %check that the we are not in the magnetosphere and that the time span is long enough to count
        for i = stopstep+1:(length(solarwind)-n)
            if sum(NaNvec(i:i+n), 'omitnan')> 3.5*n/4
                startstep = i+30; %When one enters the solar wind
                break
            end
        end
        if isempty(startstep)
            break
        end
        stopstep_check = stopstep;

        for i = startstep+1:(length(solarwind)-n)
            if sum(NaNvec(i:i+n), 'omitnan')< 3*n/4
                stopstep = i; %When one exits the solar wind
                break
            else
                stopstep = i;
            end
        end

        % Select the magnetic field during solar wind
        starttime = time(startstep);
        stoptime = time(stopstep-1);
        delta_t = stoptime - starttime;

        values = find((gseB1(:,1)>=time(startstep)) & (gseB1(:,1)<=time(stopstep))); %start time to stop time
        B = gseB1(values,5); %during same time period as E
        Bstep = mean(B(:,1)); %check that the we are not in the magnetosphere
        sumNaN = sum(NaNvec(stopstep:end),'omitnan');

        if stopstep_check == stopstep
            break
        end

    end
    if ~isempty(startstep)
        if runs == 1 %first entry
            if stoptime-starttime > 1500 %don't pick areas shorter than 25min 
                starttime1 = starttime;
                stoptime1 = stoptime;
                B1 = B;
                values1 = values;
            else %too short stay
                starttime1 = [];
                stoptime1 = [];
              
            end
        elseif runs == 2 %second entry
            if starttime == starttime1
                starttime2 = [];
                stoptime2 = [];
                runs = 1; 
                break
            elseif stoptime-starttime > 1500 %don't pick areas shorter than 25min 
                starttime2 = starttime;
                stoptime2 = stoptime;
                B2 = B;
                values2 = values;
            else %too short stay
                starttime2 = [];
                stoptime2 = [];
                runs = 1; 
                break
            end
        elseif runs == 3 %third entry
            if stoptime-starttime > 1500 %don't pick areas shorter than 25min 
                starttime3 = starttime;
                stoptime3 = stoptime;
                B3 = B;
                values3 = values;
            else %too short stay
                starttime3 = [];
                stoptime3 = [];
                runs = 2;
                break
            end
        end
    end
    if runs == 4 %don't check for more than 3 entries
        break
    end
    if length(B)>= length(gseB1)
        break
    end
end
%% Create final output

if ~isempty(starttime1)
    if runs == 2 %if there is a second entry
        values = [values1; values2];
        B = [B1; B2];
    elseif runs > 2 %if there is a third entry
        values = [values1; values2; values3];
        B = [B1; B2; B3];
    else %only one entry
        values = values1;
        B = B1;
    end
    gseB = [gseB1(values, 1) B];
else %no entry into the solar wind
    starttime1 = [];
    stoptime1 = []; 
    starttime2 = []; 
    stoptime2 = [];
    starttime3 = []; 
    stoptime3 = [];
    B = [];
    gseB = [];
    values = [];
end
end