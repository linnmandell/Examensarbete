%% distance to the bow shock
function dist_bowshock = CLUSTER_distbowshock(SLAMSt)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 
global startsolarwind stopsolarwind startsolarwind2 stopsolarwind2 startsolarwind3 stopsolarwind3;
global gse_deltaB

K = 25 * 6371; %[km]
epsi = 0.8;

if ~isempty(SLAMSt)
    SLAMS_xdist = zeros(length(SLAMSt(:,1)),1);
    SLAMS_ydist = zeros(length(SLAMSt(:,1)),1);
    SLAMS_zdist = zeros(length(SLAMSt(:,1)),1);
    SLAMS_rdist = zeros(length(SLAMSt(:,1)),1);
    for i = 1:length(SLAMSt(:,1))
        val = find(gseR1(:,1) >= SLAMSt(i,1)); % & gseR1(:,1) <= SLAMSt(i,2)
        SLAMS_xdist(i) = gseR1(val(1),2);
        SLAMS_ydist(i) = gseR1(val(1),3);
        SLAMS_zdist(i) = gseR1(val(1),4);
        SLAMS_rdist(i) = gseR1(val(1),5);
    end
    
    dist_bowshock = zeros(length(SLAMSt(:,1)),1);
    rdist_bowshock = zeros(length(SLAMSt(:,1)),1);
    x = [1; 0; 0];
    for i = 1:length(SLAMSt(:,1))
        SLAMS = [SLAMS_xdist(i); SLAMS_ydist(i); SLAMS_zdist(i)];
        c_theta = dot(x,SLAMS)/norm(SLAMS); %cos(theta)
        R = K/(1+epsi*c_theta);
        rdist_bowshock(i) = SLAMS_rdist(i)-R;
        rdist = rdist_bowshock(i);
        xdist_bowshock = 0;
        delta = 10^5;
        j = 0;
        xdist = 10^5;
        while delta > 10^3
            if j < 50
                xdist_check = xdist;
                xdist = rdist*c_theta;
                SLAMS = [SLAMS_xdist(i)-xdist; SLAMS_ydist(i); SLAMS_zdist(i)];
                c_theta = dot(x,SLAMS)/norm(SLAMS); %cos(theta)
                R = K/(1+epsi*c_theta);
                rdist =  SLAMS_rdist(i)-R;
                delta = abs(xdist_check) - abs(xdist);
                xdist_bowshock = xdist_bowshock + xdist;
                j = j+1;
            else
                break
            end
        end 
        dist_bowshock(i) = xdist_bowshock;
    end
    yz = sqrt(SLAMS_ydist.^2+SLAMS_zdist.^2); %rho [km]
    
    
    strength = zeros(length(SLAMSt(:,1)),1);
    for i = 1:length(SLAMSt(:,1))
        val = find(gseB1(:,1) >= SLAMSt(i,1) & gseB1(:,1) <= SLAMSt(i,2));
        strength(i) = max(gseB1(val,5));
    end
    
%     subplot(1,2,1)
%     plot(dist_bowshock, yz, 'go')
%     hold on
%     plot([0 0], [0 14*10^4], 'k--')
%     xlabel('Distance to bow shock [km]', 'FontSize', 15)
%     ylabel('\rho [km]', 'FontSize', 15)
%     title(num2str(SLAMSt(1,3)), 'FontSize', 15)
%     
%     subplot(1,2,2)
%     plot(dist_bowshock, strength, 'go')
%     hold on
%     plot([0 0], [0 100], 'k--')
%     xlabel('Distance to bow shock [km]', 'FontSize', 15)
%     ylabel('Magnetic field amplitude [nT]', 'FontSize', 15)
%     title(num2str(SLAMSt(1,3)), 'FontSize', 15)

    for i = 1:length(SLAMSt(:,1))
        figure(1)
        subplot(1,2,1)
        set(gca,'FontSize',16)
        if strength(i) < 10
            plot(dist_bowshock(i), yz(i), 'mo')
            hold on
        elseif strength(i) >= 10 && strength(i) < 20
            plot(dist_bowshock(i), yz(i), 'co')
            hold on
        elseif strength(i) >= 20 && strength(i) < 30
            plot(dist_bowshock(i), yz(i), 'yo')
            hold on
        elseif strength(i) >= 30 && strength(i) < 40
            plot(dist_bowshock(i), yz(i), 'ro')
            hold on
        elseif strength(i) >= 40 && strength(i) < 50
            plot(dist_bowshock(i), yz(i), 'bo')
            hold on
        elseif strength(i) >= 50
            plot(dist_bowshock(i), yz(i), 'go')
            hold on
        end
    end  
    plot([0 0], [0 14*10^4], 'k--')
    xlabel('Distance to bow shock [km]', 'FontSize', 15)
    ylabel('\rho [km]', 'FontSize', 15)
    title(num2str(SLAMSt(1,3)), 'FontSize', 15)
    
    
    for i = 1:length(SLAMSt(:,1))
        subplot(1,2,2)
        set(gca,'FontSize',16)
        if strength(i) < 10
            plot(dist_bowshock(i), strength(i), 'mo')
            hold on
        elseif strength(i) >= 10 && strength(i) < 20
            plot(dist_bowshock(i), strength(i), 'co')
            hold on
        elseif strength(i) >= 20 && strength(i) < 30
            plot(dist_bowshock(i), strength(i), 'yo')
            hold on
        elseif strength(i) >= 30 && strength(i) < 40
            plot(dist_bowshock(i), strength(i), 'ro')
            hold on
        elseif strength(i) >= 40 && strength(i) < 50
            plot(dist_bowshock(i), strength(i), 'bo')
            hold on
        elseif strength(i) >= 50
            plot(dist_bowshock(i), strength(i), 'go')
            hold on
        end
    end
    plot([0 0], [0 100], 'k--')
    xlabel('Distance to bow shock [km]', 'FontSize', 15)
    ylabel('Magnetic field amplitude [nT]', 'FontSize', 15)
    title(num2str(SLAMSt(1,3)), 'FontSize', 15)
    
%% rho as a function of x-position
theta = [0:0.001:pi/2];
R = K./(1+epsi.*cos(theta));
x_vec = R.*cos(theta);
y_vec = R.*sin(theta);
    figure(2)
    plot(SLAMS_xdist,yz, 'ro')
    hold on
    plot(0, 0, 'ko')
    plot(x_vec,y_vec, 'k-')
    set(gca,'FontSize',16)
    xlabel('SLAMS x-position [km]')
    ylabel('\rho [km]')
    title(num2str(SLAMSt(1,3)))
    
%% delta_B vs x_dist
for i = 1:length(SLAMSt(:,1))
    val_deltaB = find(gse_deltaB(:,1) >= SLAMSt(i,1) & gse_deltaB(:,1) <= SLAMSt(i,2));
    delta_B(i) = gse_deltaB(round(mean(val_deltaB)),2);
end
    
    figure(3)
    plot(dist_bowshock, delta_B, 'ro')
    hold on
    set(gca,'FontSize',16)
    xlabel('Distance to bow shock [km]')
    ylabel('B/B_{BG}')
    title('SLAMS B/B_{BG} as a function of distance to bow shock')
else
    dist_bowshock = [];
end
end