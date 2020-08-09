% Matt Sprague 6/25/2020
% Goal: plot all mooring locations in Sermilik
% This script uses the data from All_Moorings_Plotting.xlsx, as below,
% which contains manually inputted data for all the moorings from
% the mooring data reports.

clear

%% Load in data for mooring names, lat/lon, date recorded

T = readtable('All_Moorings_Plotting.xlsx'); % have this file in the same folder as this .m script (or add a filepath)

% read variables from table

    mooring = table2array(T(:,1));
    date = table2array(T(:,2));
    DR = table2array(T(:,3));
    lat = table2array(T(:,4)) + table2array(T(:,5))/60;
    lon = -table2array(T(:,6)) - table2array(T(:,7))/60;

% define lat/lon points of deployed (D)/recovered (R) moorings

    lat_D = lat(contains(DR, 'Deployed')); 
    lon_D = lon(contains(DR, 'Deployed'));
    lat_R = lat(contains(DR, 'Retrieved')); 
    lon_R = lon(contains(DR, 'Retrieved'));

%% Set map dimensions - giving 0.15 degree of margin from max values

m = .15;
dim =[min(lat)-m max(lat)+m; min(lon)-m max(lon)+m];
dx = 0.01; dy = 0.01;

    % generate map to be referenced below (saves time) 
    
    m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
    m_gshhs_h('save', 'sermilik');

%% Plot points on the Fjord - removed GP 1-3 moorings

figure
subplot(1,3,1) % first subplot - only deployments, colored in blue
hold on

    m_usercoast('sermilik', 'patch', [.75 .75 .75]);
    m_scatter(lon_D, lat_D, 30, 'blue', 'fill')
    m_grid('box', 'fancy')
    
    hold off

    b_D = num2str(find(contains(DR, 'Deployed'))); label_D = cellstr(b_D);
    m_text(lon_D+dx, lat_D+dy, label_D)

    xlabel('Longitude (W)'); ylabel('Latitude (N)')
    title('Deployed Moorings in Sermilik Fjord')

subplot(1,3,2) % second subplot - only retrievals, colored in red
hold on 

    m_usercoast('sermilik', 'patch', [.75 .75 .75]);
    m_scatter(lon_R, lat_R, 30, 'red', 'fill')
    m_grid('box', 'fancy')
    
    hold off 

    b_R = num2str(find(contains(DR, 'Retrieved'))); label_R = cellstr(b_R);
    m_text(lon_R+dx, lat_R+dy, label_R)

    xlabel('Longitude (W)'); ylabel('Latitude (N)')
    title('Retrieved Moorings in Sermilik Fjord')
    
% Show which numbers correspond to which mooring

number = linspace(1,length(mooring), length(mooring))';
disp('Date is in format MM-DD-YYYY.')
mooring_info = [table(number, mooring, DR, date, lat, lon)];
disp(mooring_info)

%% Now: script to create a map of deployments/retrievals for any given year.
% When mapping every mooring, numbers and points tend to overlap, becoming
% a bit difficult to read. The script below will prompt the user for a year
% of their choice, and it will only display maps and table readouts for
% the moorings of that year. This section uses a couple variables from the
% code above so that should still be run first. 

prompt = 'Input year in YYYY format (e.g. "2009"): ';
yr = input(prompt); yr_str = string(yr);

% find indices of points that satisfy the year requested & deployed/received

ind_D = find(contains(T.Date, yr_str) & contains(T.Deployed_Retrieved, 'Deployed'));
ind_R = find(contains(T.Date, yr_str) & contains(T.Deployed_Retrieved, 'Retrieved'));

% define lat/lon coordinates from each index 

lat_D_yr = lat(ind_D);
lon_D_yr = lon(ind_D);
lat_R_yr = lat(ind_R);
lon_R_yr = lon(ind_R);

    figure
    subplot(1,2,1) % first subplot - only deployments, colored in blue
    hold on

        m_usercoast('sermilik', 'patch', [.75 .75 .75]);
        m_scatter(lon_D_yr, lat_D_yr, 30, 'blue', 'fill')
        m_grid('box', 'fancy')

        hold off

        b_D_yr = num2str(ind_D); label_D_yr = cellstr(b_D_yr);
        % labels can either be only numbers, or mooring names, or both.
        % If the moorings are close together, numbers may be better to
        % allow for some level of clarity without zooming in. Leave
        % in/comment out the lines below to your liking. 
        m_text(lon_D_yr+dx, lat_D_yr+dy, label_D_yr) % number labels 
        m_text(lon_D_yr+7*dx, lat_D_yr+dy, mooring(ind_D)) % mooring names

        xlabel('Longitude (W)'); ylabel('Latitude (N)')
        title(['Deployed Moorings in Sermilik Fjord', yr_str])

    subplot(1,2,2) % second subplot - only retrievals
    hold on 

        m_usercoast('sermilik', 'patch', [.75 .75 .75]);
        m_scatter(lon_R_yr, lat_R_yr, 30, 'red', 'fill')
        m_grid('box', 'fancy')

        hold off 

        b_R_yr = num2str(ind_R); label_R_yr = cellstr(b_R_yr);
        m_text(lon_R_yr+dx, lat_R_yr+dy, label_R_yr)
        m_text(lon_R_yr+7*dx, lat_R_yr+dy, mooring(ind_R))

        xlabel('Longitude (W)'); ylabel('Latitude (N)')
        title(['Retrieved Moorings in Sermilik Fjord', yr_str])

% Show which numbers correspond to which moorings, as above

    % deployed moorings
    
    disp('________________________________________________________')
    disp(yr_str); disp('Deployed moorings (dates in YYYY format)')
    varnames = {'Number', 'Deployed_Mooring', 'Date', 'Latitude', 'Longitude'};
    mooring_info = table(ind_D, mooring(ind_D), date(ind_D), lat_D_yr, lon_D_yr, 'VariableNames', varnames);
    disp(mooring_info)

    % retrieved moorings
    
    disp(yr_str); disp('Retrieved moorings (dates in YYYY format)')
    varnames = {'Number', 'Retrieved_Mooring', 'Date', 'Latitude', 'Longitude'};
    mooring_info = table(ind_R, mooring(ind_R), date(ind_R), lat_R_yr, lon_R_yr, 'VariableNames', varnames);
    disp(mooring_info)