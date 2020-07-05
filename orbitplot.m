%% 3D plot
function orbitplot(startdate, SLAMSt)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 
global startsolarwind stopsolarwind startsolarwind2 stopsolarwind2 startsolarwind3 stopsolarwind3;


figure
plot3(gseR1(:,2), gseR1(:,3), gseR1(:,4), 'b') %orbit
hold on
% Plot the solar wind
    if ~isempty(startsolarwind)
        VAL = find(gseR1(:,1)>= startsolarwind & gseR1(:,1)<=stopsolarwind);

        plot3(gseR1(VAL,2), gseR1(VAL,3), gseR1(VAL,4), '.y') %,'markersize',2
    end
    if ~isempty(stopsolarwind2)
        VAL = find(gseR1(:,1)>= startsolarwind2 & gseR1(:,1)<=stopsolarwind2);

        plot3(gseR1(VAL,2), gseR1(VAL,3), gseR1(VAL,4), '.y') %,'markersize',2
    end
    if ~isempty(stopsolarwind3)
        VAL = find(gseR1(:,1)>= startsolarwind3 & gseR1(:,1)<=stopsolarwind3);

        plot3(gseR1(VAL,2), gseR1(VAL,3), gseR1(VAL,4), '.y') %,'markersize',2
    end

plot3(0,0,0, 'og') %position of Earth

if ~isempty(SLAMSt)
    val = [];
    for i = 1:length(SLAMSt(:,1))
        VAL = find(gseR1(:,1)>=SLAMSt(i,1));
        val = [val; VAL(1)];
    end
    plot3(gseR1(val,2), gseR1(val,3), gseR1(val,4), 'xr','markersize',10) %mark SLAMS
end

hold off
xlabel('x')
ylabel('y')
zlabel('z')
title(num2str(startdate))
end