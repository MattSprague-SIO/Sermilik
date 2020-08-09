%% Script for mapping all SF deployments in 2011. 

clear

%% create 2011 map - nearly identical to 2008 

load Gridded_Sermilikmap.mat

    dim  = [65.30 66.44; -38.50 -37.40]; % full map dimensions 
    dim2 = [65+55/60 65+59/60; -37-48/60 -37-43/60]; % zoomed in map dimensions 
    k = find(mask==2);
    bed(k) = NaN;
    
    figure 
        
        subplot(121)
        hold on
        m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
        m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
        m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
        m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
        m_grid('box', 'fancy')
        title('2011 Sermilik Fjord Deployments')
        
        subplot(122)
        hold on 
        m_proj('mercator','long',[dim2(2,1) dim2(2,2)],'lat',[dim2(1,1) dim2(1,2)]);
        m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
        m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
        m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
        m_grid('box', 'fancy')
        title('2011 Sermilik Fjord Moorings (East Shore Closeup)')
        
        savefig('sermilik2011.fig')

%% define CTD points 

    SF11_CTD       = infocheck('SF2011ctd.mat')         ;
    SF11A_XCTD     = infocheck('XCTD_AUG2011_cal.mat')  ;
    
%% define mooring points 

T = readtable('All_Moorings_Plotting.xlsx'); % have this file in the same folder as this .m script (or add a filepath)

% read variables from table

    mooring = table2array(T(:,1));
    date = table2array(T(:,2));
    DR = table2array(T(:,3));
    lat = table2array(T(:,4)) + table2array(T(:,5))/60;
    lon = -table2array(T(:,6)) - table2array(T(:,7))/60;
    
% find index of points 

    ind_D_R  = find(contains(DR, 'Deployed R'  ) & contains(date, '2011'));
    ind_R    = find(contains(DR, 'Retrieved'   ) & contains(date, '2011')); 
    
%% plot all points 

openfig('sermilik2011.fig')

    subplot(121)
    m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
    hold on 
    p(1) = m_scatter(SF11_CTD.lon, SF11_CTD.lat, '^', 'black', 'fill');
    p(2) = m_scatter(SF11A_XCTD.lon, SF11A_XCTD.lat, '^', 'r', 'fill');
    p(3) = m_scatter(lon(ind_D_R), lat(ind_D_R), 'r', 'fill'); 
    p(4) = m_scatter(lon(ind_R), lat(ind_R), 'square', 'g', 'fill');
    
    legend(p(:), 'CTDs', 'XCTDs', '2011 Deployments (Recovered)', '2011 Recoveries', 'Location', 'NorthEastOutside', 'FontSize', 15)
    
    subplot(122)
    m_proj('mercator','long',[dim2(2,1) dim2(2,2)],'lat',[dim2(1,1) dim2(1,2)]);
    hold on 
    h(1) = m_scatter(SF11_CTD.lon, SF11_CTD.lat, '^', 'black', 'fill');
    h(2) = m_scatter(SF11A_XCTD.lon, SF11A_XCTD.lat, '^', 'r', 'fill');
    h(3) = m_scatter(lon(ind_D_R), lat(ind_D_R), 'r', 'fill'); 
    h(4) = m_scatter(lon(ind_R), lat(ind_R), 'square', 'g', 'fill');
    
    legend(p(:), 'CTDs', 'XCTDs', '2011 Deployments (Recovered)', '2011 Recoveries', 'FontSize', 15)
    
%% identify labels 

    m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
    m_usercoast('sermilik', 'patch', [.75 .75 .75])
    
    hold on 
    
        m_scatter(SF11_CTD.lon, SF11_CTD.lat, '^', 'black', 'fill');
        m_text(SF11_CTD.lon, SF11_CTD.lat-.001, string(linspace(1,length(SF11_CTD.lon), length(SF11_CTD.lon))'))
        
        m_scatter(SF11A_XCTD.lon, SF11A_XCTD.lat, '^', 'r', 'fill');
        m_text(SF11A_XCTD.lon, SF11A_XCTD.lat+.001, string(linspace(1,length(SF11A_XCTD.lon), length(SF11A_XCTD.lon))'))
        
        m_scatter(lon(ind_D_R), lat(ind_D_R), 'r', 'fill'); 
        m_text(lon(ind_D_R)-.001, lat(ind_D_R), mooring(ind_D_R))

        m_scatter(lon(ind_R), lat(ind_R), 'square', 'g', 'fill');
        m_text(lon(ind_R)+.001, lat(ind_R), mooring(ind_R))


    