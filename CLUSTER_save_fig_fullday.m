function CLUSTER_save_fig_fullday(date)

data_dir = '/Volumes/Kun_KTH/Linn/Full_days';

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
saveas(hca, [yr mo da], 'epsc') %save figure as eps in color


end