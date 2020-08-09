%% Matt Sprague 7/2/2020
% Goal: to generate pressure vs time graphs for individual moorings and
% grouped moorings (i.e. CM 0-6, SF 1-5, offshore east/west groups). 

% This script loads data from the Excel spreadsheet Microcat_Filenames.xlsx.
% Most of the .mat files therein are in roughly the same format, so this
% script plots pressure vs time for multiple moorings at once, using the
% pres_plot function defined at the bottom. 

clear

% create indices for mooring names and locations

    T = readtable('Microcat_Filenames.xlsx');
    filename = char(table2array(T(:,1)));

% create mooring name vector and lat/lon position vectors
    
    mooring = strings(length(filename), 1, 1);
    poss    = NaN(length(filename), 4);
    for i = 1:length(filename)
        load(filename(i,:))
        mooring(i) = setup.mooringID; 
        poss(i, :) = setup.poss; 
    end

    lat = poss(:,1) + poss(:,2)/60;
    lon = poss(:,3) + poss(:,4)/60;
        
% matrix of RGB triplets used for lines on pressure plots, to prevent
% multiple lines of identical color 

    randcolor = [    
    0.9098    0.0745    0.0745; 0.8784    0.4431    0.0627; 0.9294    0.6941    0.1255; 0.4941    0.1843    0.5569;
    0.4667    0.6745    0.1882; 0.3020    0.7451    0.9333; 0.6353    0.0784    0.1843; 1.0000    1.0000    0.0667;
    0.0745    0.6235    1.0000; 1.0000    0.4118    0.1608; 0.3922    0.8314    0.0745; 0.7176    0.2745    1.0000; 
    0.0588    1.0000    1.0000; 1.0000    0.0745    0.6510; 0.5020    0.5020    0.5020; 1.0000    0.0000    0.0000;
    1.0000    0.0000    1.0000; 0.0000    1.0000    0.0000; 0.0000    0.0000    1.0000; 0.5961    0.6196    0.2549;
    0.1882    0.7373    0.8196; 0.1333    0.7020    0.4745; 0.1137    0.9608    0.6235; 0.3686    0.0588    0.3490;
    0.7569    0.4941    0.9294; 0.8902    0.5961    0.5961; 0.6353    0.8627    0.9216; 0.0000    1.0000    0.2000;
    0.6314    0.3961    0.3961; 0.5608    0.7882    0.5608; 0.6392    0.1804    0.3333; 0.8588    0.8118    0.1137;
    0.5608    0.3412    0.5294; 0.4314    0.0157    0.3490; 0.6196    0.0510    0.0510; 1.0000    0.7882    0.7882;
    0.8314    0.9804    0.8431; 0.8157    0.6431    0.8784; 0.0471    0.8118    0.9294; 0.0039    0.3529    0.4784;
    0.7882    0.7725    0.7725; 0.5020    0.4000    0.4000; 1.0000    1.0000    0.7294; 0.5529    0.6314    0.0392;
    0.2902    0.1098    0.2902; 0.0157    0.2039    0.4902; 0.6000    0.7882    1.0000; 0.5490    0.8588    0.6314;
    0.2275    0.8784    0.2275; 0.8196    0.2549    0.2549; 0.3529    0.5020    0.3137; 0.8902    0.5373    0.2314;
    0.9412    0.7765    0.1216; 0.7216    0.3451    0.3451; 0.7804    0.2196    0.7804; 0.8000    0.9686    0.3294;
    0.2392    0.3686    0.5608; 0.5804    0.0471    0.0471; 0.0314    0.5098    0.2235; 0.0431    0.6196    0.2353];

%% generate sermilik map to be referenced below (saves time) 

    dim = [65.3339   66.4361; -38.5004  -37.4270]; % map dimensions
    m_proj('mercator','long',[dim(2,1) dim(2,2)],'lat',[dim(1,1) dim(1,2)]);
    m_gshhs_h('save', 'sermilik');
        
%% User selection of mooring name/name convention, plotting

    disp('To plot a particular mooring, type its name (e.g. "SF4")')
    disp('To plot a group of moorings, type the letter prefix (e.g. "CM")')
    name = input('Enter mooring name/convention here: ', 's');

    ind = find(contains(mooring, name)); % creates index for chosen name

    % Plot chosen functions 

    pres_plot(ind, name, filename, lat, lon, mooring, randcolor)

%% Plotting pre-determined mooring groups 
% The following sections of this script use pre-determined groups of
% moorings. They plot several groups that are close to each other
% geographically:

    % the CM0-2 moorings(mid fjord, east shore), 
    % SF4 mid-fjord moorings, 
    % offshore east, 
    % offshore west

% method - same as code above, but use indices unique to the groupings
% instead of the user's name selection 

    %% mid-fjord, east shore - CM0, CM1, CM2, CM3, MS-M1, MD-M1, CM1SF5, CM2SF6
          
        ind = find(lat > 65.8 & lat < 66 & lon > -37.85 & lon < -37.6);
        pres_plot(ind, 'Mid-Fjord East Shore', filename, lat, lon, mooring, randcolor)


    %% mid-fjord - SF4 (but not all SF4 deployments), P1 

        ind = find(lat > 65.8 & lat < 66.0 & lon > -38 & lon < -37.8);
        pres_plot(ind, 'Mid-Fjord Offshore', filename, lat, lon, mooring, randcolor)

    %% offshore west - SF1, OW1 

        ind = find(lon < -38.2); 
        pres_plot(ind, 'Offshore West', filename, lat, lon, mooring, randcolor)

    %% offshore east - CM5, CM6 

        ind = unique(sort([
              find(contains(mooring, 'CM5'));   find(contains(mooring, 'CM6'))]));  
        ind = find(lat > 65.4 & lat < 65.6 & lon > -38.1 & lon < -37.9);
        pres_plot(ind, 'Offshore East', filename, lat, lon, mooring, randcolor)

%% pressure plotting function (with lat/lon locations) 

function[plt] = pres_plot(ind, name, filename, lat, lon, mooring, randcolor)      
figure

% plot pressure vs time for each mooring 

    subplot('Position',[.05 .1 .7 .8])
    hold on 
    for i = ind'
        load(filename(i,:));
        plt = plot(mc.dtnum, mc.pressure, 'Color', randcolor(i,:), 'Linewidth', 2, 'DisplayName', filename(i,:));
        datetick('x', 'yyyy')
        set(gca, 'ydir', 'reverse')
    end 
    hold off 
    title(['Pressure vs Time: ' name ' Moorings'])
    legend('Interpreter', 'none', 'Location','NorthEastOutside')
    xlabel('Date (Month-Year)'); ylabel('Pressure (db)');

% create lat/lon map of chosen moorings (mainly to confirm that they are
% clustered together) 

    subplot('Position', [.77 .1 .2 .8])
    hold on
    m_usercoast('sermilik', 'patch', [.75 .75 .75]);
    m_grid('box', 'fancy')
    m_scatter(lon(ind), lat(ind), 30, 'red', 'fill')
    m_text(lon(ind)+.01, lat(ind)+.01, mooring(ind))
    hold off 
    title('Mooring Locations')
    
end