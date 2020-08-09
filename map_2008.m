%% Script for mapping all SF deployments in 2008. 

clear

%% generate sermilik map 

load Gridded_Sermilikmap.mat

    dim  = [65.34 66.44; -38.50 -37.43]; % full map dimensions 
    dim2 = [65+57/60 65+59/60; -37-48/60 -37-43/60]; % zoomed in map dimensions 
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
        title('2008 Sermilik Fjord Deployments')
        
        subplot(122)
        hold on 
        m_proj('mercator','long',[dim2(2,1) dim2(2,2)],'lat',[dim2(1,1) dim2(1,2)]);
        m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
        m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
        m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
        m_grid('box', 'fancy')
        title('2008 Sermilik Fjord Moorings (East Shore Closeup)')
        
        savefig('sermilik2008.fig')

%% define CTD points - CTD data requires some organizing (mat file is a little different than usual)

    SF08_CTD = infocheck('SF08_stations.mat');
    
    % CTD variables are KnudsenJuly, leg1, offshore, section2, section3
    % Number these CTDs as KJ 1-5, L1 1-13, OF 1-7, S2 1-3, S3 
    % Labels will be added manually, but create labels here so you can plot
    % them later and use as a reference while drawing them on. 
    
        KJ_labels = ["KJ 1"; "KJ 2"; "KJ 3"; "KJ 4"; "KJ 5";];
        L1_labels = ["L1 1"; "L1 2"; "L1 3"; "L1 4"; "L1 5"; 
                     "L1 6"; "L1 7"; "L1 8"; "L1 9"; "L1 10"; 
                     "L1 11"; "L1 12"; "L1 13"];
        OF_labels = ["OF 1"; "OF 2"; "OF 3"; "OF 4"; "OF 5";
                     "OF 6"; "OF 7"];
        S2_labels = ["S2 1"; "S2 2"; "S2 3"];
        S3_label  = "S3";
        
    % Organize lat/lon data and labels 
    
        labels = [KJ_labels; L1_labels; OF_labels; S2_labels; S3_label];
        latlon = [SF08_CTD.KnudsenJuly(:,2:3); SF08_CTD.leg1(:,2:3); 
                  SF08_CTD.offshore(:,2:3);    SF08_CTD.section2(:,2:3); 
                  SF08_CTD.section3(:,2:3)];
        lat_CTD = latlon(:,1); 
        lon_CTD = latlon(:,2);
        

%% define mooring points 

T = readtable('All_Moorings_Plotting.xlsx'); % have this file in the same folder as this .m script (or add a filepath)

% read variables from table

    mooring = table2array(T(:,1));
    date = table2array(T(:,2));
    DR = table2array(T(:,3));
    lat = table2array(T(:,4)) + table2array(T(:,5))/60;
    lon = -table2array(T(:,6)) - table2array(T(:,7))/60;
    
% find index of points 

    ind_D_R  = find(contains(DR, 'Deployed R' ) & contains(date, '2008'));
    ind_R    = find(contains(DR, 'Retrieved'  ) & contains(date, '2008'));
    
    % all moorings deployed in 2008 were successfully recovered. This plot
    % need not include "Deployed, Not Recovered" points, although it will
    % be good to include the month that moorings were deployed/recovered,
    % since the short-term moorings will appear on the graph. 
    
%% plot all points 

    openfig('sermilik2008.fig')
    
    subplot(121)
    hold on
    m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
    m(1) = m_scatter(lon_CTD,      lat_CTD,  'black', '^', 'fill');
    m(2) = m_scatter(lon(ind_D_R), lat(ind_D_R), 'r',      'fill');
    m(3) = m_scatter(lon(ind_R)  , lat(ind_R),   'g',      'fill');
    legend(m(:), 'CTDs', '2008 Deployments (Recovered)', '2008 Recoveries', 'Location', 'NorthEastOutside', 'FontSize', 15)
    
    subplot(122)
    hold on
    m_proj('mercator','long',[dim2(2,1) dim2(2,2)],'lat',[dim2(1,1) dim2(1,2)]);
    h(1) = m_scatter(lon(ind_D_R), lat(ind_D_R), 'r', 'fill');
    h(2) = m_scatter(lon(ind_R)  , lat(ind_R),   'g', 'fill');
    legend(h(:), '2008 Deployments (Recovered)', '2008 Recoveries', 'FontSize', 15)
    
%% identify CTD labels 

figure
hold on 
m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
m_usercoast('sermilik', 'patch', [.75 .75 .75]);
for i = 1:length(lat_CTD)
    hold on 
    m_scatter(lon_CTD(i), lat_CTD(i))
    m_text(lon_CTD(i)+.01, lat_CTD(i)+.01, labels(i))
    disp(i)
    pause(.2)
end
