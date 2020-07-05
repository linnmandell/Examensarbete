% Locate solar wind
function CLUSTER_locate_solar_wind(startdate)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 

flux = ifluxhia1.data; %E
time = itimeshia1.data; %time vector of E


%% Find solarwind
solarwind = [];
for i = 1:length(flux)
    if (flux(i,13)+flux(i,14)+flux(i,15))/3 >= 10^3
        if flux(i,24) == 0
            delta = ((flux(i,13)+flux(i,14)+flux(i,15))/3)/(1+flux(i,24));
        else
            delta = ((flux(i,13)+flux(i,14)+flux(i,15))/3)/flux(i,24);
        end
    
        if delta > 10^3
            solarwind = [solarwind; flux(i,:)];
        else
            solarwind = [solarwind; NaN*ones(1,31)];
        end
    else
        solarwind = [solarwind; NaN*ones(1,31)];
    end
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

NaNvec = [];
for i = 1:length(solarwind)
    if isnan(solarwind(i,1))
        NaNvec = [NaNvec; NaN];
    else
        NaNvec = [NaNvec; 1];
    end
end

%% 
%If one is not in the solar wind at the first data point
Bstep = 200;
startstep = 0;
while Bstep > 100 %check that the we are not in the magnetosphere
    for i = startstep+1:(length(solarwind)-5)
        if ~isnan(solarwind(i,1)) && ~isnan(solarwind(i+1,1)) && ~isnan(solarwind(i+2,1)) && ~isnan(solarwind(i+3,1)) && ~isnan(solarwind(i+4,1)) && ~isnan(solarwind(i+5,1))
            startstep = i;
            break
        end
    end

    %When one enters the solar wind
    for i = startstep:(length(solarwind)-7)
        if isnan(solarwind(i,1)) && isnan(solarwind(i+1,1)) && isnan(solarwind(i+2,1)) && isnan(solarwind(i+3,1)) && isnan(solarwind(i+4,1)) && isnan(solarwind(i+5,1)) && isnan(solarwind(i+6,1)) && isnan(solarwind(i+7,1))
            stopstep = i;
            break
        else
            stopstep = i;
        end
    end
    
    % Select the magnetic field during solar wind
    starttime = time(startstep);
    stoptime = time(stopstep);
    values = find((gseB1(:,1)>=time(startstep)) & (gseB1(:,1)<=time(stopstep))); %start time to stop time
    B = gseB1(values,5); %during same time period as E
    Bstep = B(1,1); %check that the we are not in the magnetosphere
end

figure(2)
plot(B)
%plot(solarwind)

%% Mean value of B
Bmean = [];
for i = 1:6
    mean = (B(i)+B(i+1)+B(i+2)+B(i+3)+B(i+4))/5;
    Bmean = [Bmean; mean];
end
for i = 7:(length(B)-9)
    mean = (B(i-6)+B(i-5)+B(i-4)+B(i-3)+B(i-2)+B(i-1)+B(i)+B(i+1)+B(i+2)+B(i+3)+B(i+4)+B(i+5)+B(i+6))/13;
    Bmean = [Bmean; mean];
end
for i = (length(B)-8):length(B)
    mean = (B(i-4)+B(i-3)+B(i-2)+B(i-1)+B(i))/5;
    Bmean = [Bmean; mean];
end

%Bmean = mean(B); % ?

%% Identify SLAMS
SLAMS = [];
for i = 1:length(B)
    if B(i)/Bmean(i) >= 2 %Def of SLAMS
        SLAMS = [SLAMS; 1];
    else
        SLAMS = [SLAMS; 0];
    end
end
amount_of_SLAMS = sum(SLAMS);
disp(['Amount of SLAMS in this data set: ', num2str(amount_of_SLAMS)])


if sum(SLAMS) > 0
    SLAMS_time = [];
    for i = 1:length(SLAMS)
        if SLAMS(i) == 1
            SLAMS_time = [SLAMS_time; gseB1(i,1)];
        end
    end
end



end