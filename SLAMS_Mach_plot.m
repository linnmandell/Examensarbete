%% 
function SLAMS_Mach_plot(SLAMSt)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 
global gseBmean startsolarwind stopsolarwind startsolarwind2 stopsolarwind2 startsolarwind3 stopsolarwind3;
global gse_deltaB

my0 = 4*pi*10^(-7); % Permeability of free space [H/m]
mp = 1.67*10^(-27); % Proton massa [kg], assume 100% protons

if ~isempty(SLAMSt) % Only run if there are SLAMS in this data set
    for i = 1:length(SLAMSt(:,1))        
        if isempty(stopsolarwind2)
            val = find(ne_efw1(:,1)>= startsolarwind & ne_efw1(:,1)<= stopsolarwind);
        elseif isempty(stopsolarwind3)
            val1 = find(ne_efw1(:,1)>= startsolarwind & ne_efw1(:,1)<= stopsolarwind);
            val2 = find(ne_efw1(:,1)>= startsolarwind2 & ne_efw1(:,1)<= stopsolarwind2);
            val = [val1; val2];
        else
            val1 = find(ne_efw1(:,1)>= startsolarwind & ne_efw1(:,1)<= stopsolarwind);
            val2 = find(ne_efw1(:,1)>= startsolarwind2 & ne_efw1(:,1)<= stopsolarwind2);
            val3 = find(ne_efw1(:,1)>= startsolarwind3 & ne_efw1(:,1)<= stopsolarwind3);
            val = [val1; val2; val3];
        end     
        n_mean = mean(ne_efw1(val,2),'omitnan'); % Number density [cm^-3]

        valB = find(gseBmean(:,1) >= SLAMSt(i,1) & gseBmean(:,1) <= SLAMSt(i,2));
        B(i) = mean(gseBmean(valB,2),'omitnan')*10^(-9); % Background magnetic field [T]

        rho = mp*n_mean*10^6; % Density, 100% protons [kg/m^3]
        vA = (B(i)*10^(-3))/(sqrt(my0*rho)); % Alfvén velocity [km/s]

        valv = find(gseVhia1(:,1)>= (SLAMSt(i,1)-15) & gseVhia1(:,1)<= (SLAMSt(i,2)+15));
        valv = round(mean(valv));
        vsw = gseVhia1(valv,5); % Solar wind velocity[km/s]
        vsw_vec(i) = vsw;

        MA(i) = vsw/vA; % Mach number
        
        val_deltaB = find(gse_deltaB(:,1) >= SLAMSt(i,1) & gse_deltaB(:,1) <= SLAMSt(i,2));
        delta_B(i) = gse_deltaB(round(mean(val_deltaB)),2);
        
        val_B = find(gseB1(:,1) >= SLAMSt(i,1) & gseB1(:,1) <= SLAMSt(i,2));
        B_SLAMS(i) = mean(gseB1(val_B,5)); %[nT]
        
        val_r = find(gseR1(:,1) >= SLAMSt(i,1));
        SLAMS_rdist(i) = gseR1(val_r(1),5); % Radius to Earth [km]
        
    end

    dt = SLAMSt(:,2)-SLAMSt(:,1); % SLAMS size in sec
    for i = 1:length(dt)
        dx(i) = vsw_vec(i)*dt(i); % SLAMS size in km
    end
    
     

%% Plot SLAMS size as functions of Mach number
    figure(1)
    subplot(1,2,1)
    plot(MA, dt, 'ro')
    hold on
    set(gca,'FontSize',16)
    xlabel('Mach number')
    ylabel('SLAMS size, dt [s]')
    title('SLAMS size in time as a function of Mach number')

    subplot(1,2,2)
    plot(MA, dx, 'ro')
    hold on
    set(gca,'FontSize',16)
    xlabel('Mach number')
    ylabel('SLAMS size, dx [km]')
    title('SLAMS size in km as a function of Mach number')
    
%% Plot deltaB/B as a function of Mach number
    figure(4)
    subplot(1,2,1)
    plot(MA, delta_B, 'ro')
    hold on
    set(gca,'FontSize',16)
    xlabel('Mach number')
    ylabel('B/B_{BG}')
    title('SLAMS B/B_{BG} as a function of Mach number')
    
    subplot(1,2,2)
    plot(MA, B_SLAMS, 'ro')
    hold on
    set(gca,'FontSize',16)
    xlabel('Mach number')
    ylabel('B [nT]')
    title('SLAMS magnetic field amplitude as a function of Mach number')
end

end