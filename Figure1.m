% Plot Figure 1

% Create background image, then use 'firstLook_unsmoothed_SWOT_Mascarene.m'
% to plot the 250-m resolution SWOT SSH

clear;clc

% Time
timeplot = datenum(2023,5,8);

% SWOT data
load swot_L2_Mascarene.mat

% --------------------------------> Find AVISO image to match
avisopath = '/Users/archer/Documents/SWOT/AVISO/';
afilen = ['nrt_global_allsat_phy_l4_' datestr(timeplot,'YYYYmmDD')];

afilenl = dir([avisopath '/' afilen '*']);
afile = [afilenl.folder '/' afilenl.name];

% Load AVISO
ncreadall(afile)

% Cut AVISO
indlo = find(longitude >= 58 & longitude <= 67);
indla = find(latitude >= -20 & latitude <= -5);
slac = sla(indlo,indla);
slacdt = detrend(slac')';

% ----------------------------------------------------------------------- %    
% Plot Main Figure
figure
h=pcolor(longitude(indlo),latitude(indla),slacdt'), shading flat
set(h,'FaceAlpha',0.75);
colormap(flipud(brewermap(64,'RdBu'))),hold on
set(gcf,'color','w'),
fontsize(20,20,20,20)
Y=get(gca,'ylim');set(gca,'dataaspectratio',[1 cos((Y(2)+Y(1))/2/180*pi) 1])

xlim([59 65])
ylim([-18 -8])

hold on
    contour(lonb,latb,-depthb,[-3000 -2000 -1000 -500 -100],'k'),hold on  
    %
    pcolor(lonl,latl,sshlf),shading flat,hold on
    pcolor(lonr,latr,sshrf),shading flat,hold on

    caxis([-.35 .35])
    
    plot(lonl(5,:),latl(5,:),'k','linewidth',1),hold on
    plot(lonl(end-5,:),latl(end-5,:),'k','linewidth',1),hold on
    plot(lonr(5,:),latr(5,:),'k','linewidth',1),hold on
    plot(lonr(end-5,:),latr(end-5,:),'k','linewidth',1),hold on
% ----------------------------------------------------------------------- %
% ZOOM
ylim([-15 -14.2])
xlim([63.3 63.85])
caxis([-.3 .3])
% ----------------------------------------------------------------------- %
