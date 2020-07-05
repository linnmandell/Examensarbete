function CLUSTER_mark_SLAMS(SLAMSt)

    hca = irf_panel('B1GSE_abs (nT)');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('ne hia (cm-3)');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('B1GSE');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('vGSEhia (km/s)');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('T');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('R_{GSE} (RE)');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('mode');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
    hca = irf_panel('B solarwind');
    irf_pl_mark(hca, [SLAMSt(:,1) SLAMSt(:,2)], 'r')
    
end