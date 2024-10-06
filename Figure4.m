% Plot unsmoothed with better QC

clear;clc

% >>>>>>>>>>>>>>>>>>>>>>>>>>>> Andaman <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< best: cycles 3,10
load /Users/archer/Documents/SWOT/karin/science_unsmoothed/Andaman/SWOT_UnsmoothedL2_Andaman_cycle10.mat
load coastlines
ln = 18; ls = 3; le = 100; lw = 92; % Andaman

%% Pick a pass and QC it 

% Cycle time bookends
datestr(nanmean(time{1}))
datestr(nanmean(time{end}))

% k = 1
% datestr(nanmean(time{k}))

for k = 1:length(time)
    timem(k) = (nanmean(time{k}));
end
datestr(timem)

%% Plot ascending 

figure('Position',[408 370 676 967])
for k = 1:length(time) % 51 and 55 on cycle 2 of GS

% Get Pass
dataL = sl{k};
lonlk = lonl{k};
latlk = latl{k};
dataR = sr{k};
lonrk = lonr{k};
latrk = latr{k};

% Detrend
n = 3;

% LEFT-HAND
dataL(dataL > n | dataL < -n) = NaN;

% RIGHT-HAND
dataR(dataR > n | dataR < -n) = NaN;

if latr{k}(5,1) < latr{k}(5,end)

    % PLOTTING
    % figure
    plot(coastlon,coastlat,'k','linewidth',3),hold on
    xlim([lw le]); ylim([ls ln])
    %
    pcolor(lonlk,latlk,dataL-nanmedian(dataL,2)),shading flat,hold on
    pcolor(lonrk,latrk,dataR-nanmedian(dataR,2)),shading flat,hold on
    
    text(lonr{k}(5,end),latr{k}(5,end),num2str(k))

    Y=get(gca,'ylim');set(gca,'dataaspectratio',[1 cos((Y(2)+Y(1))/2/180*pi) 1])
    cmocean('balance')
    set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
    fontsize(20,20,20,20)
    caxis([-.4 .4])
    colorbar('Location','SouthOutside')
    set(gca, 'LooseInset', get(gca, 'TightInset') + [0.02, 0.02, 0.02, 0.02]); % Adjust the values as needed
    
end

% pause
% clf

end
colormap(flipud(slanCM('RdBu')))

%% Add AVISO map

afile = '/Users/archer/Documents/SWOT/AVISO/nrt_global_allsat_phy_l4_20240201_20240204.nc';
ncreadall(afile)

figure
pcolor(longitude,latitude,sla'),shading flat
hold on
plot(coastlon,coastlat,'k','linewidth',3),hold on
Y=get(gca,'ylim');set(gca,'dataaspectratio',[1 cos((Y(2)+Y(1))/2/180*pi) 1])
set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
fontsize(20,20,20,20)
caxis([-.3 .3])
colormap(flipud(slanCM('RdBu')))

%M_Map

figure('Position',[235 423 1196 856])
%
m_proj('robinson','lon',([92 99]), 'lat',([4 17]));hold on;
m_grid('linest','none','linewidth',2,'yaxisloc','left','fontsize',20,'fontweight','bold');
set(gcf,'color','w')
%
m_pcolor(longitude,latitude,sla'),shading flat
colormap(flipud(slanCM('RdBu')))

m_gshhs_h('patch',[0.7 0.7 0.7],'edgecolor','k')
