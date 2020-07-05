function CLUSTER_plot_slams_SC1(starttime, stoptime)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhia3 Tperphia1 Tperphia3 nhia1 nhia3 nhia4;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3;  


% Date in following format: [2001 01 01]

data_dir = 'E:\Data\Cluster\MAGNETIC HOLES';




%% PREPARE PLOTTING

% Font size:
FS1 = 15;    
FS2 = FS1*1.5;
% Line width
lw = 1;
% Colour:
Cg = [0 0.5 0];  % Cluster green
Cc = [0 0.6 0.6]; % Darker cyan
Cx = [0 0 0];
Cy = [1 0 0];
Cz = [0 0.5 0];
%Col_xyz = [0 0 0;0 0.6 0.6;1 0 1;];
Col_xyz = [0 0 0 ; 1 0 0 ; 0 0.5 0;];
Col_C = [0 0 0;1 0 0;0 0.5 0;0 0 1;0 0.6 0.6 ;1 0 1; 1 1 0];
%Prepare t interval
tint = [irf_time(starttime) irf_time(stoptime)];   
tintindexB = find((gseB1(:,1)>=tint(1)) & (gseB1(:,1)<=tint(2)));
%tintindexnehia = find((ne_efw1(:,1)>=tint(1)) & (ne_efw1(:,1)<=tint(2)));
tintindexnhia = find((nhia1(:,1)>=tint(1)) & (nhia1(:,1)<=tint(2)));
tintindexV = find((gseVhia1(:,1)>=tint(1)) & (gseVhia1(:,1)<=tint(2)));





%% MOVE TO CORRECT DIRECTORY (FOR ION SPECTROGRAM)
date = starttime(1:3);
old_dir = cd;
yr = int2str(date(1));
mo = date(2);
if mo < 10
    mo = ['0' int2str(mo)];
else
    mo = int2str(mo);
end;
da = date(3);
if da < 10
    da = ['0' int2str(da)];
else
    da = int2str(da);
end;

search_dir = [data_dir '\*' yr mo da '*']
date_dir = dir(search_dir)
date_dir = [data_dir '\' date_dir.name]
cd(date_dir)
        

%% PLOT
   
 N = 8;
 h=irf_plot(N); % N subplots
 grid off;

% Plot CIS HIA spectrogram
hca=irf_panel('CIS spectrogram');
irf_plot(hca,'flux__C1_CP_CIS_HIA_HS_1D_PEF','colorbarlabel',{'log_{10} dEF','keV/cm^2 s sr keV'},'fitcolorbarlabel');
caxis(hca,[2.9 7.1]);
set(hca,'yscale','log')
set(hca,'ytick',[1 1e1 1e2 1e3 1e4 1e5])
irf_zoom(hca,'y',[25 4e4]);
ylabel(hca,'E [eV]')
set(hca,'FontSize',FS1);
%irf_colormap('default');
colormap jet;

% Plot Abs B
yzoom = [0 max(gseB1(tintindexB,5),[],'all')];
hca=irf_panel('B1GSE_abs (nT)');
irf_plot(hca,[gseB1(:,1) gseB1(:,5)]);
ylabel(hca,{'|B|', '(nT)'},'FontSize',FS1);
grid(hca,'off');
set(hca,'FontSize',FS1);
irf_zoom(hca,'y',yzoom);

% Panel n
yzoom = [0 max(nhia1(tintindexnhia,2),[],'all')];
hca = irf_panel('ne efw (cm-3)');
irf_plot(hca,nhia1,'LineWidth',lw);
ylabel(hca,{'n_e', '(cm^{-3})'},'FontSize',FS1);
set(hca,'FontSize',FS1);
grid(hca,'off');
irf_zoom(hca,'y',[yzoom]);

% Plot B
yzoom = [min(gseB1(tintindexB,2:4),[],'all') max(gseB1(tintindexB,2:4),[],'all')];
hca=irf_panel('B1GSE');
irf_plot(hca,gseB1(:,1:4));
ylabel(hca,{'B_{GSE}','(nT)'},'FontSize',FS1);
irf_legend(hca,{'B_x','B_y','B_z'},[0.98 0.15])
grid(hca,'off');
set(hca,'FontSize',FS1);
irf_zoom(hca,'y',yzoom)

% Panel v
yzoom = [min(gseVhia1(tintindexV,2:4),[],'all') max(gseVhia1(tintindexV,2:4),[],'all')];
hca = irf_panel('vGSEhia (km/s)');
%irf_plot(hca,[gseVhia1(:,1),gseVhia1(:,5)]);    
irf_plot(hca,[gseVhia1(:,1),gseVhia1(:,2:4)]); 
%irf_plot(hca,gseVhia1);    
ylabel(hca, {'v_{GSE}', '(km/s)'},'FontSize',FS1);
%irf_legend(hca,{'v_x','v_y','v_z','|v|'},[0.98 0.15])
irf_legend(hca,{'v_x','v_y','v_z'},[0.98 0.15])
grid(hca,'off');
set(hca,'FontSize',FS1);
irf_zoom(hca,'y',[yzoom]);

% Panel temperature
yzoom = [0 max(Thia1(tintindexV,2),[],'all')];
hca = irf_panel('T');
irf_plot(hca,Tparhia1,'LineWidth',lw);
hold on;
irf_plot(hca,Tperphia1,'LineWidth',lw);
hold off;
ylabel(hca,{'T', '(MK)'},'FontSize',FS1);
set(hca,'FontSize',FS1);
grid(hca,'off');
irf_legend(hca,{'T_{par}','T_{perp}'},[0.98 0.15])
irf_zoom(hca,'y',[yzoom]);

%Plot S/C position
hca=irf_panel('R_{GSE} (RE)');
irf_plot(hca,gseRE1);
ylabel(hca,{'R_{GSE}', '(RE)'},'FontSize',FS1);
irf_legend(hca,{'x','y','z','r'},[0.98 0.1]);
set(hca,'FontSize',FS1);
grid(hca,'off');

% Plot CIS mode
yzoom = [0 11];
hca=irf_panel('mode');
irf_plot(hca,modecis1);
ylabel(hca,{'CIS',' mode'},'FontSize',FS1);
grid(hca,'off');
set(hca,'FontSize',FS1);
irf_zoom(hca,'y',yzoom);
    

% changes to all figure
irf_plot_axis_align
irf_zoom(h,'x',tint);
irf_timeaxis(h);
title(h(1),'Cluster 1','FontSize',FS2)

           
%% Clean up
disp('Cleaning up');
cd(old_dir);
fclose('all');
return;