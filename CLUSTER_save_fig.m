function CLUSTER_save_fig(date,i)

data_dir = '/Volumes/Kun_KTH/Linn/Potential_SLAMS/';

%% MOVE TO CORRECT DIRECTORY
old_dir = cd;
yr = int2str(date(1));
mo = date(2);
if mo < 10
    mo = ['0' int2str(mo)];
else
    mo = int2str(mo);
end
da = date(3);
if da < 10
    da = ['0' int2str(da)];
else
    da = int2str(da);
end

cd(data_dir)

hca = irf_panel('B1GSE_abs (nT)');
saveas(hca, ['SLAMS' yr mo da 'nr' num2str(i)], 'png') %save figure as png


end