%% Script for mapping all SF deployments in 2009. 

% NOTE: the file Gridded_Sermilikmap.mat contains variables "lat" and "lon"
% as 2001x1001 arrays. The moorings are plotted with the same variable
% names. Therefore it's important to run each part of this script in order;
% if you generate the map then go straight to the plotting without loading
% info from All_Moorings_Plotting, the moorings won't show up.

clear 

%% create 2009 map 

load Gridded_Sermilikmap.mat

    dim  = [65.34 66.44; -38.50 -37.43]; % full map dimensions 
    k = find(mask==2);
    bed(k) = NaN;
    
    figure 
    
        hold on 
        m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
        m_contourf(lon,lat,mask,[0 0],'edgecolor','[0.6 0.8 1]','facecolor','[0.6 0.8 1]');
        m_contourf(lon,lat,mask,[1 1],'edgecolor','k','facecolor',[.7 .7 .7]);
        m_contour(lon,lat,bed,[-1000 -900 -808 -700 -600 -500 -400 -300 -200 -100],'linewidth',1);
        m_grid('box', 'fancy')
        title('2009 Sermilik Fjord Deployments')
        
        savefig('sermilik2009.fig')
        
%% define CTD points

SF09_CTD = infocheck('SF2009ctd.mat');


%% define mooring points 

T = readtable('All_Moorings_Plotting.xlsx'); % have this file in the same folder as this .m script (or add a filepath)

% read variables from table

    mooring = table2array(T(:,1));
    date = table2array(T(:,2));
    DR = table2array(T(:,3));
    lat = table2array(T(:,4)) + table2array(T(:,5))/60;
    lon = -table2array(T(:,6)) - table2array(T(:,7))/60;
    
% find index of points 

    ind_D_R  = find(contains(DR, 'Deployed R'  ) & contains(date, '2009'));
    ind_D_NR = find(contains(DR, 'Deployed NR' ) & contains(date, '2009'));
    ind_R    = find(contains(DR, 'Retrieved') & contains(date, '2009')); 
    
%% plot all points 

openfig('sermilik2009.fig')

    hold on 
    h(1) = m_scatter(SF09_CTD.lon , SF09_CTD.lat , 50, '^', 'black', 'fill')     ;  % CTD points
    h(2) = m_scatter(lon(ind_R)   , lat(ind_R)   , 80, 'g', 'square', 'fill')    ;  % recovered moorings
    h(3) = m_scatter(lon(ind_D_R) , lat(ind_D_R) , 50, 'r', 'fill')              ;  % deployed, recovered
    h(4) = m_scatter(lon(ind_D_NR), lat(ind_D_NR), 50, 'blue', 'diamond', 'fill');  % deployed, not recovered
    legend(h(:), 'CTDs', '2009 Recoveries', '2009 Deployments (Recovered)', '2009 Deployments (Not Recovered)', 'Location', 'NorthEastOutside')
    print('map200testagain', '-dpng')
    %saveas(1, '-r500', 'map2009test.bmp', 'bmp')
    
%% identify station numbers for CTD 
figure
hold on 
m_usercoast('sermilik', 'patch', [.75 .75 .75]);
station = num2cell(linspace(1, length(SF09_CTD.lon), length(SF09_CTD.lon))');
for i = 1:length(SF09_CTD.lon)
    hold on 
    m_scatter(SF09_CTD.lon(i), SF09_CTD.lat(i))
    m_text(SF09_CTD.lon(i)+.01, SF09_CTD.lat(i)+.01, station(i))
    disp(i)
    pause(.2)
end
    