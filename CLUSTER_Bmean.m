function [Bmean, Bmean2, gseBmean, gseBmean2] = CLUSTER_Bmean(B, values)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhi3 Tperphia1 Tperphia3;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3; 

Bmean = [];
Bmedian = [];
%n = 300; %steps, 1min in each direction
%n = 600; %steps, 2min in each direction
%n = 1200; %steps, 4min in each direction
n = 1800; %steps, 6min in each direction
%n = 2400; %steps, 8min in each direction
%n = 3000; %steps, 10min in each direction
%n = 3600; %steps, 12min in each direction
%n = 4200; %steps, 14min in each direction
%n = 4800; %steps, 16min in each direction
xyz = 0; %mean of x, y, z components 1=yes
xyz_mean = 0; %mean of mean of x, y, z components 1=yes
if length(B) > n
%% mean
    for i = 1:n
        meanval = sum(B(i:i+(n/2)))/(n/2+1);
        medianval = median(B(i:i+(n/2)));
        Bmean = [Bmean; meanval];
        Bmedian = [Bmedian; medianval];
    end
    for i = (n+1):(length(B)-n-1)
        meanval = sum(B(i-n:i+n))/(2*n+1);
        medianval = median(B(i-n:i+n));
        Bmean = [Bmean; meanval];
        Bmedian = [Bmedian; medianval];
    end
    for i = (length(B)-n):length(B)
        meanval = sum(B((i-(n/2)):i))/(n/2+1);
        medianval = median(B((i-(n/2)):i));
        Bmean = [Bmean; meanval];
        Bmedian = [Bmedian; medianval];
    end

    gseBmean = [gseB1(values, 1) Bmean]; %using the mean value

%% tot mean
     Bmean2 = mean(B);
%      Bmean = Bmean2*ones(length(gseB1(values,1)),1);
%      gseBmean = [gseB1(values, 1) Bmean]; %using the total mean value
%% median
%     Bmean = Bmedian;
%     gseBmean = [gseB1(values, 1) Bmedian]; %Using the median value
    
    gseBmean2 = [gseB1(values, 1) Bmean2*ones(length(gseB1(values, 1)),1)];
    
%% mean of x, y, z components
    if xyz == 1 || xyz_mean == 1
        Bx = gseB1(values, 2); %magnetic field in x-direction
        By = gseB1(values, 3); %magnetic field in x-direction
        Bz = gseB1(values, 4); %magnetic field in x-direction

        Bmeanx = [];
        Bmeany = [];
        Bmeanz = [];
        Bmean_mean_xyz = [];

        for i = 1:n
            meanvalx = sum(Bx(i:i+(n/2)))/(n/2+1);
            meanvaly = sum(By(i:i+(n/2)))/(n/2+1);
            meanvalz = sum(Bz(i:i+(n/2)))/(n/2+1);

            Bmeanx = [Bmeanx; meanvalx];
            Bmeany = [Bmeany; meanvaly];
            Bmeanz = [Bmeanz; meanvalz];

        end
        for i = (n+1):(length(B)-n-1)
            meanvalx = sum(Bx(i-n:i+n))/(2*n+1);
            meanvaly = sum(By(i-n:i+n))/(2*n+1);
            meanvalz = sum(Bz(i-n:i+n))/(2*n+1);

            Bmeanx = [Bmeanx; meanvalx];
            Bmeany = [Bmeany; meanvaly];
            Bmeanz = [Bmeanz; meanvalz];

        end
        for i = (length(B)-n):length(B)
            meanvalx = sum(Bx((i-(n/2)):i))/(n/2+1);
            meanvaly = sum(By((i-(n/2)):i))/(n/2+1);
            meanvalz = sum(Bz((i-(n/2)):i))/(n/2+1);

            Bmeanx = [Bmeanx; meanvalx];
            Bmeany = [Bmeany; meanvaly];
            Bmeanz = [Bmeanz; meanvalz];

        end
        Bmean_xyz = sqrt(Bmeanx.^2+Bmeany.^2+Bmeanz.^2);
        Bmean = Bmean_xyz;
        gseBmean = [gseB1(values, 1) Bmean_xyz]; %using the mean value of the x, y and z components

        if xyz_mean == 1 %mean of the absolut value of the mean components
            for i = 1:n
                meanvalmean_xyz = sum(Bmean_xyz(i:i+(n/2)))/(n/2+1);
                Bmean_mean_xyz = [Bmean_mean_xyz; meanvalmean_xyz];
            end
            for i = (n+1):(length(Bmean_xyz)-n-1)
                meanvalmean_xyz = sum(Bmean_xyz(i-n:i+n))/(2*n+1);
                Bmean_mean_xyz = [Bmean_mean_xyz; meanvalmean_xyz];
            end
            for i = (length(Bmean_xyz)-n):length(Bmean_xyz)
                meanval = sum(Bmean_xyz((i-(n/2)):i))/(n/2+1);
                Bmean_mean_xyz = [Bmean_mean_xyz; meanvalmean_xyz];
            end
            Bmean = Bmean_mean_xyz;
            gseBmean = [gseB1(values, 1) Bmean_mean_xyz]; %using the mean value of the x, y and z components and then the mean of that
        end
    end
else
    Bmean = []; 
    Bmean2 = []; 
    gseBmean = []; 
    gseBmean2 = [];
end

end