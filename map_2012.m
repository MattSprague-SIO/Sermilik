%% Script for mapping all SF deployments in 2012. 

clear

%% create 2012 map 

load Gridded_Sermilikmap.mat

    dim  = [65.34 66.44; -38.50 -37.43]; % full map dimensions 
%     dim2 = [65+57/60 65+59/60; -37-48/60 -37-43/60]; % zoomed in map dimensions 
    k = find(mask==2);
    bed(k) = NaN;
    
        hold on
        m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
        m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
        m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
        m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
        m_grid('box', 'fancy')
        title('2012 Sermilik Fjord Deployments')
        
        savefig('sermilik2012.fig')
        
%% define CTD points 

    SF12_CTD  = infocheck('SF2012ctd.mat')         ;
    SF12_XCTD = infocheck('XCTD_AUG2012_raw.mat')  ;
    
%% define mooring points 

T = readtable('All_Moorings_Plotting.xlsx'); % have this file in the same folder as this .m script (or add a filepath)

% read variables from table

    mooring = table2array(T(:,1));
    date = table2array(T(:,2));
    DR = table2array(T(:,3));
    lat = table2array(T(:,4)) + table2array(T(:,5))/60;
    lon = -table2array(T(:,6)) - table2array(T(:,7))/60;
    
% find index of points 

    ind_D_R  = find(contains(DR, 'Deployed R' ) & contains(date, '2012'));   

    % seems like it's only deployed moorings recovered successfully. Will
    % add in other moorings if more data is found. 
    
%% plot all points 

    openfig('sermilik2012.fig')
    
    hold on 
    m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
    h(1) = m_scatter(SF12_CTD.lon , SF12_CTD.lat , '^', 'black', 'fill');
    h(2) = m_scatter(SF12_XCTD.lon, SF12_XCTD.lat, '^', 'r',     'fill'); 
    h(3) = m_scatter(lon(ind_D_R) , lat(ind_D_R) ,      'r',     'fill');

    legend(h(:), 'CTDs', 'XCTDs', '2012 Deployments (Recovered)', 'Location', 'NorthEastOutside')
    
%% identify labels 

figure
hold on 
m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
m_usercoast('sermilik', 'patch', [.75 .75 .75]);

for i = 1:length(SF12_CTD.lon) 
    hold on 
    m_scatter(SF12_CTD.lon(i), SF12_CTD.lat(i), '^', 'black', 'fill');
    m_text(SF12_CTD.lon(i), SF12_CTD.lat(i)+.01, string(i))
end

for i = 1:length(SF12_XCTD.lon)
    hold on 
    m_scatter(SF12_XCTD.lon(i), SF12_XCTD.lat(i), '^', 'r',     'fill'); 
    m_text(SF12_XCTD.lon(i), SF12_XCTD.lat(i)+.01, string(i))
end

    m_scatter(lon(ind_D_R), lat(ind_D_R), 'r', 'fill');
    m_text(lon(ind_D_R)+.001, lat(ind_D_R), mooring(ind_D_R))
    
    
    
    
    
    
    