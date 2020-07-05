function load_CAA_SLAMS(t1,t2,SLAMS_data_dir)

%%% This function is called by SLAMS_load_data.m


%% TIME INTERVAL TO LOAD:

dir_string = [SLAMS_data_dir,'/CAA__%4d%02d%02d_%02d_%02d_%02d__%4d%02d%02d_%02d_%02d_%02d'];
dir_name = sprintf(dir_string, irf_time(t1,'epoch>vector'), irf_time(t2,'epoch>vector'))



% remove CAA log file and previous directories to be able to reload data:
delete '.caa'


exist(dir_name)
if exist(dir_name) == 7
    ls(dir_name);
else
    mkdir(dir_name);
end
tint=[t1 t2]; % time interval
cd (dir_name);





%% LOAD DATA:

disp('MH: Loading CAA data');
% FGM:
 caa_download(tint,'C?_CP_FGM_5VPS') ;    % FGM, 5 samples/sec
 caa_download(tint,'C?_CP_FGM_SPIN');      % FGM, Spin resolution
 
% CIS:
caa_download(tint,'C?_CP_CIS_HIA_ONBOARD_MOMENTS'); % HIA
caa_download(tint,'C?_CP_CIS_HIA_HS_1D_PEF');       % HIA, PEF=particle energy distribution
caa_download(tint,'C?_CP_CIS_CODIF_HS_H1_MOMENTS'); % CODIF, HS=HighSensitivity, H1=H+
caa_download(tint,'C?_CP_CIS_CODIF_HS_O1_MOMENTS'); % CODIF, HS=HighSensitivity, O1=O+
caa_download(tint,'C?_CP_CIS_CODIF_HS_1D_PEF');     % CODIF, PEF=particle energy distribution
caa_download(tint,'C?_CP_CIS_MODES');               % CIS modes

% EFW:
% caa_download(tint,'C?_CP_EFW_L3_E3D_INERT');         % EFW, 4s resolution, E.B=0, VxB removed, DSI
 caa_download(tint,'C?_CP_EFW_L3_E3D_GSE');            % EFW, 4s resolution, E.B=0, VxB removed, GSE,
 caa_download(tint,'C?_CP_EFW_L3_P');                  % satellite potential, 4s resolution
 caa_download(tint,'C?_CP_EFW_L2_E');                  % ISR2, 25 or 450 Hz resolution, 2D


% RAPID:
%%%%caa_download(tint,'C?_CP_RAP_ESPCT6');                      % RAPID, adaptive particle imaging detectors

% PEACE:
%%%%caa_download(tint,'C?_CP_PEA_PITCH_SPIN_DEFlux'); % PEACE

% STAFF:
%%%%caa_download(tint,'C?_CP_STA_PSD'); % STAFF

% WHISPER:
%%% ...

% POSITION
caa_download(tint,'C?_CP_AUX_POSGSE_1M');  % position & velocity for each sc
caa_download(tint,'CL_SP_AUX');            % position,attitude.. for all sc
%caa_download(tint,'C?_JP_PMP');           % invariant latitude, MLT, L shell.
caa_download(tint,'C?_JP_AUX_PMP');        % invariant latitude, MLT, L shell.


%% Check that data loaded OK

download_status=caa_download; % repeat until all data are downloaded
if download_status==0 % some data are still in queue
  disp('___________!!!!_____________')
  disp('Some data where put in queue!')
  disp('To see when they are ready and to download execute "caa_download".');
  return
end

end




