%% Bow shock plot
clc, clear all%, close all

RE = 6371;
K = 25*RE;
epsilon = 0.8;

R = @(theta) K./(1+epsilon*cos(theta));
t = linspace(0,2*pi,55); 
z = linspace(0,pi,55); 
[T,U] = meshgrid(t,z); 
X = R(U).*sin(U).*cos(T); 
Y = R(U).*sin(U).*sin(T); 
Z = R(U).*cos(U);

% Take away values on the negativ x-axis
for i = 1:length(Z)
    for j = 1:length(Z)
        if Z(i,j) < -4*10^4
            Z(i,j) = NaN;
        end
    end
end

%figure
surf(Z,Y,X,X.^2+Y.^2+Z.^2,'FaceAlpha','interp', 'EdgeAlpha', 'interp','AlphaDataMapping','scaled','AlphaData',gradient(Z), 'FaceColor','green')
shading interp
colormap(copper)
hold on
%axis equal
title('Bow shock', 'FontSize', 18)
xlabel('x')
ylabel('y')
zlabel('z')


[x, y, z] = sphere(15);
r = RE;
X2 = x * r;
Y2 = y * r;
Z2 = z * r;

