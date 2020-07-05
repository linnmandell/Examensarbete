function CLUSTER_read_data(date)

global gseR1 gseR2 gseR3 gseR4 gsmR1 gsmR2 gsmR3 gsmR4;
global gseRE1 gseRE2 gseRE3 gseRE4 gsmRE1 gsmRE2 gsmRE3 gsmRE4;
global gseB1 gseB2 gseB3 gseB4 gsmB1 gsmB2 gsmB3 gsmB4;
global gseVhia1 gseVhia3 gsmVhia1 gsmVhia3;
global Thia1 Thia3 Tparhia1 Tparhia3 Tperphia1 Tperphia3 nhia1 nhia3 nhia4;
global ifluxhia1 itimeshia1 ienergytablehia1;
global modehia1 modehia3 modecis1 modecis3 modecis4;
global ne_efw1 ne_efw3 ne_efw4;   


% Date in following format: [2001 01 01]

data_dir = 'E:\Data\Cluster\MAGNETIC HOLES';
%data_dir = 'E:\Data\Cluster\CROSSCORR';


%% FIX INPUT TIMES (TO EPOCH FORMAT)
starttime = irf_time([date 00 00 00]);
stoptime = irf_time([date 00 00 00]);
tint = [starttime stoptime];   

     
%% MOVE TO CORRECT DIRECTORY
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
   

%% PREPARE READING DATA  
 
% Relevant spacecraft:
SC_cod = [1 3 4];
SC_hia = [1 3];
SC_efw = [1 2 3 4];
SC_fgm = [1 2 3 4];
SC_all = [1 2 3 4];
   
% Physical units:
Units = irf_units();
   

%% READ/CALCULATE EPHIMERIS
   
% Rxyz [km -> RE]
c_eval('[~,~,gseR?] = c_caa_var_get(''sc_r_xyz_gse__C?_CP_AUX_POSGSE_1M'');', SC_all);  % km
c_eval('gseR?=irf_abs(gseR?);', SC_all);
c_eval('gseRE? = [gseR?(:,1), gseR?(:,2:end) / Units.RE*1000];');
%c_eval('gsmR?=irf_gse2gsm(gseR?);', SC_all);
%c_eval('gsmR?=irf_abs(gsmR?);', SC_all); % With total value in last column,
%c_eval('gsmRE? = [gsmR?(:,1), gsmR?(:,2:end) / Units.RE*1000];'); 
    
    
%% READ/CALCULATE FGM: B, dB, PB
    
%c_eval('[~,~,gseB?] = c_caa_var_get(''B_vec_xyz_gse__C?_CP_FGM_SPIN'');', SC_fgm);
c_eval('[~,~,gseB?] = c_caa_var_get(''B_vec_xyz_gse__C?_CP_FGM_5VPS'');', SC_fgm);
c_eval('gseB?=irf_abs(gseB?);', SC_fgm);
%c_eval('gsmB?=irf_gse2gsm(gseB?);', SC_fgm);
%c_eval('gsmB?=irf_abs(gsmB?);', SC_fgm); % With total value in last column,
    

%% READ/CALCULATE CIS
   
c_eval('[~,~,gseVhia?]=c_caa_var_get(''velocity_gse__C?_CP_CIS_HIA_ONBOARD_MOMENTS'');', SC_hia);
c_eval('[~,~,Thia?]=c_caa_var_get(''temperature__C?_CP_CIS_HIA_ONBOARD_MOMENTS'');', SC_hia);
c_eval('[~,~,nhia?]=c_caa_var_get(''density__C?_CP_CIS_HIA_ONBOARD_MOMENTS'');', SC_hia);
c_eval('[~,~,Tparhia?]=c_caa_var_get(''temp_par__C?_CP_CIS_HIA_ONBOARD_MOMENTS'');', SC_hia);
c_eval('[~,~,Tperphia?]=c_caa_var_get(''temp_perp__C?_CP_CIS_HIA_ONBOARD_MOMENTS'');', SC_hia);
c_eval('[~,~,modehia?]=c_caa_var_get(''hia_operational__C?_CP_CIS_MODES'');', SC_hia);
c_eval('[~,~,modecis?]=c_caa_var_get(''cis_mode__C?_CP_CIS_MODES'');', SC_cod);
c_eval('gsmVhia?=irf_gse2gsm(gseVhia?);', SC_hia);
c_eval('gsmVhia?=irf_abs(gsmVhia?);',SC_hia);
c_eval('gseVhia?=irf_abs(gseVhia?);',SC_hia);

% To be able to check fluxes for MSh identification
ifluxhia1 = c_caa_var_get('flux__C1_CP_CIS_HIA_HS_1D_PEF');
itimeshia1 = c_caa_var_get('time_tags__C1_CP_CIS-HIA_HS_1D_PEF');
ienergytablehia1 = c_caa_var_get('energy_table__C1_CP_CIS-HIA_HS_1D_PEF');
idt =  c_caa_var_get('duration__C1_CP_CIS-HIA_HS_1D_PEF');
global ifluxhia1 itimeshia1 ienergytablehia1 idt;

%% READ/CALCULATE EFW
c_eval('[~,~,Vps?]=c_caa_var_get(''Spacecraft_potential__C?_CP_EFW_L3_P'');');
ne_efw1 = c_efw_scp2ne(Vps1); % Use default conversion
ne_efw3 = c_efw_scp2ne(Vps3); % Use default conversion
ne_efw4 = c_efw_scp2ne(Vps4); % Use default conversion
%global fitparam; % If manual calibration is used
%ne_efw1 = vps2ne_TK(Vps1,fitparam);

    
%% CLEAN UP
disp('Cleaning up');
cd(old_dir);
fclose('all');
return;