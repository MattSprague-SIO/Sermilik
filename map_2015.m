%% Script for mapping all SF deployments in 2015. 

clear

%% create 2015 map

load Gridded_Sermilikmap.mat

    dim  = [65.34 66.44; -38.50 -37.43];             % full map dimensions
    dim2 = [65+57/60 65+58/60; -37-47/60 -37-43/60]; % east shore 
    dim3 = [65+52/60 65+55/60; -37-58/60 -37-48/60]; % offshore southeast
    
    k = find(mask==2);
    bed(k) = NaN;
    
    figure
    
        % full size map 
        
            subplot('Position', [.1 .1 .3 .8])
            hold on
            m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
            m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
            m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
            m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
            m_grid('box', 'fancy')
            title('2015 Sermilik Fjord Deployments')
        
        % east shore zoom-in 
        
            subplot('Position', [.5 .6 .3 .3])
            hold on 
            m_proj('mercator','long',[dim2(2,1) dim2(2,2)],'lat',[dim2(1,1) dim2(1,2)]);
            m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
            m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
            m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
            m_grid('box', 'fancy')
            title('2015 Sermilik Fjord Deployments (East Shore Closeup)')
       
        % offshore south zoom-in 
        
            subplot('Position', [.5 .15 .3 .3])
            hold on 
            m_proj('mercator','long',[dim3(2,1) dim3(2,2)],'lat',[dim3(1,1) dim3(1,2)]);
            m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
            m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
            m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
            m_grid('box', 'fancy')
            title('2015 Sermilik Fjord Deployments (Mid Fjord Closeup)')
            
        savefig('sermilik2015.fig')
    
%% define CTD points

    SF15_CTD  = infocheck('SF2015CTD.mat')  ;
    SF15_XCTD = infocheck('SF2015_XCTD.mat');
    
%% define mooring points 

T = readtable('All_Moorings_Plotting.xlsx'); % have this file in the same folder as this .m script (or add a filepath)

% read variables from table

    mooring = table2array(T(:,1));
    date = table2array(T(:,2));
    DR = table2array(T(:,3));
    lat = table2array(T(:,4)) + table2array(T(:,5))/60;
    lon = -table2array(T(:,6)) - table2array(T(:,7))/60;
    
% find index of points 

    ind_D_R  = find(contains(DR, 'Deployed R' ) & contains(date, '2015'));
    ind_D_NR = find(contains(DR, 'Deployed NR') & contains(date, '2015'));
    ind_R    = find(contains(DR, 'Retrieved'  ) & contains(date, '2015'));
    
%% plot all points 

openfig('sermilik2015.fig') 

    % full size map 
    
        subplot('Position', [.1 .1 .3 .8])
        hold on
        m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);

        h(1) = m_scatter(SF15_CTD.lon,  SF15_CTD.lat,   '^',      'black', 'fill'); % CTDs
        h(2) = m_scatter(SF15_XCTD.lon, SF15_XCTD.lat,  '^',      'r',     'fill'); % XCTDs
        h(3) = m_scatter(lon(ind_D_R),  lat(ind_D_R),             'r',     'fill'); % Deployed and retrieved
        h(4) = m_scatter(lon(ind_D_NR), lat(ind_D_NR), 'diamond', 'b',     'fill'); % Deployed (not retrieved)
        h(5) = m_scatter(lon(ind_R),    lat(ind_R),    'square',  'g',     'fill'); % Retrieved

        legend(h(:), 'CTDs', 'XCTDs', '2015 Deployments (Recovered)', '2015 Deployments (Not Recovered)', '2015 Recoveries', 'Location', 'NorthEastOutside')
    
    % east shore zoom-in 
    
        subplot('Position', [.5 .6 .3 .3])
        hold on 
        m_proj('mercator','long',[dim2(2,1) dim2(2,2)],'lat',[dim2(1,1) dim2(1,2)]);
        
        h(1) = m_scatter(SF15_CTD.lon,  SF15_CTD.lat,   '^',      'black', 'fill'); % CTDs
        h(2) = m_scatter(SF15_XCTD.lon, SF15_XCTD.lat,  '^',      'r',     'fill'); % XCTDs
        h(3) = m_scatter(lon(ind_D_R),  lat(ind_D_R),             'r',     'fill'); % Deployed and retrieved
        h(4) = m_scatter(lon(ind_D_NR), lat(ind_D_NR), 'diamond', 'b',     'fill'); % Deployed (not retrieved)
        h(5) = m_scatter(lon(ind_R),    lat(ind_R),    'square',  'g',     'fill'); % Retrieved
    
    % mid-fjord zoom-in
    
        subplot('Position', [.5 .15 .3 .3])
        hold on 
        m_proj('mercator','long',[dim3(2,1) dim3(2,2)],'lat',[dim3(1,1) dim3(1,2)]);
        
        h(1) = m_scatter(SF15_CTD.lon,  SF15_CTD.lat,   '^',      'black', 'fill'); % CTDs
        h(2) = m_scatter(SF15_XCTD.lon, SF15_XCTD.lat,  '^',      'r',     'fill'); % XCTDs
        h(3) = m_scatter(lon(ind_D_R),  lat(ind_D_R),             'r',     'fill'); % Deployed and retrieved
        h(4) = m_scatter(lon(ind_D_NR), lat(ind_D_NR), 'diamond', 'b',     'fill'); % Deployed (not retrieved)
        h(5) = m_scatter(lon(ind_R),    lat(ind_R),    'square',  'g',     'fill'); % Retrieved
    
    
%% identify labels - remember to label recovered moorings with the year deployed 

figure
hold on 
m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
m_usercoast('sermilik', 'patch', [.75 .75 .75]);
    
    m_scatter(SF15_CTD.lon,  SF15_CTD.lat,   '^',      'black', 'fill'); % CTDs
    m_text(SF15_CTD.lon,  SF15_CTD.lat+.001, string(linspace(1, length(SF15_CTD.lon), length(SF15_CTD.lon))'))
    
    m_scatter(SF15_XCTD.lon, SF15_XCTD.lat,  '^',      'r',     'fill'); % XCTDs
    m_text(SF15_XCTD.lon, SF15_XCTD.lat-.001, string([1; 2; 3; 4; 5]))
    
    m_scatter(lon(ind_D_R),  lat(ind_D_R),             'r',     'fill'); % Deployed and retrieved
    m_text(lon(ind_D_R)+.001,  lat(ind_D_R), mooring(ind_D_R))
    
    m_scatter(lon(ind_D_NR), lat(ind_D_NR), 'diamond', 'b',     'fill'); % Deployed (not retrieved)
    m_text(lon(ind_D_NR)+.001, lat(ind_D_NR), mooring(ind_D_NR))
    
    m_scatter(lon(ind_R),    lat(ind_R),    'square',  'g',     'fill'); % Retrieved
    m_text(lon(ind_R)-.001, lat(ind_R), mooring(ind_R))
    
    
    
    
    
    
    
    
    
    
    