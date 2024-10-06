% Plot Figure 3 panels

clear;clc

%% SWOT 

% Load SWOT data
load /Users/archer/Documents/SWOT/karin/matFiles/WSA.mat

time = datenum(2023,08,02,12,42,00);

%% AVISO
clear;clc;

afile = '/Users/archer/Documents/SWOT/AVISO/nrt_global_allsat_phy_l4_20230802_20230808.nc';
ncreadall(afile)

% Cut AVISO
indlo = find(longitude >= 10 & longitude <= 33);
indla = find(latitude >= -40 & latitude <= -30);
slac = sla(indlo,indla);

% Plot Main Figure
figure
m_proj('lambert','lon',([13 21]), 'lat',([-38 -31]));hold on;
h=m_pcolor(longitude(indlo),latitude(indla),slac'), shading flat
set(h,'FaceAlpha',0.75);
colormap(flipud(brewermap(64,'RdBu'))),hold on
m_coast('patch',[0.7 0.7 0.7],'edgecolor','k'); % Using gray color [0 175 0] 
m_grid('linest','none','linewidth',2,'yaxisloc','left','fontsize',20,'fontweight','bold');
set(gcf,'color','w'),
colorbar('Location','SouthOutside')
fontsize(40,40,40,40)

m_patch([15 15; 17 17; 15 17; 15 17],[-35 -32.5; -35 -32.5; -35 -35; -32.5 -32.5],'k','linewidth',3); % ...with hatching added.


%% Interpolate AVISO onto SWOT swath

clear;clc;

% load AVISO
afile = '/Users/archer/Documents/SWOT/AVISO/nrt_global_allsat_phy_l4_20230802_20230808.nc';
ncreadall(afile)

% Load SWOT
sfile = '/Users/archer/Documents/SWOT/AVISO_Karin_ComparisonWork/data_L3_21day_basic_Jinbo/SWOT_L3_LR_SSH_Basic_001_333_20230802T021413_20230802T030539_v1.0.nc';
lon = ncread(sfile,'longitude'); lon(lon > 180) = lon(lon > 180) - 360;
lat = ncread(sfile,'latitude');
%
karin = ncread(sfile,'ssha');

% Interpolate AVISO onto SWOT swath
Fa = griddedInterpolant({longitude,latitude},sla);
slai = Fa(lon,lat);
slaim = slai; slaim(isnan(karin))=NaN;

% Plot 1D across eddy
figure; 
alk = 12:35;
hc1 = cmocean('matter',length(alk));
hc2 = cmocean('algae',length(alk));
%
for k = 1:length(alk)
    hold on
    
    [e,n]=lonlat2km(lon(alk(k),3010),lat(alk(k),3010),lon(alk(k),3010:3040),lat(alk(k),3010:3040));
    xdist = sqrt(e.^2+n.^2);
    
    plot(xdist,karin(alk(k),3010:3040)*100,'lineWidth',4,'color',hc1(k,:))
    plot(xdist,slaim(alk(k),3010:3040)*100,'lineWidth',4,'color',hc2(k,:))
    
end
% set(gca, 'LooseInset', get(gca, 'TightInset') + [0.02, 0.02, 0.02, 0.02]); % Adjust the values as needed
set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
fontsize(20,20,20,20)

% Plot KARIN
figure
pcolor(ydist2,xdist2,karin(alk,alonglength)*100),shading flat,hold on
contour(ydist2,xdist2,karin(alk,alonglength)*100,25,'color',[.5 .5 .5])
xlim([0 50])
ylim([400 500])
caxis([18 38])
cmocean('balance')
set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
fontsize(20,20,20,20)

% Plot AVISO
figure;
hold on
pcolor(ydist2,xdist2,slaim(alk,alonglength)*100),shading flat,hold on
contour(ydist2,xdist2,slaim(alk,alonglength)*100,25,'color',[.5 .5 .5])
xlim([0 50])
ylim([400 500])
caxis([18 38])
cmocean('balance')
set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
fontsize(20,20,20,20)

% -------------------------------------  VELOCITY

% Compute 
latc = lat(alk,alonglength);
lonc = lon(alk,alonglength);
%
eta = karin(alk,alonglength);
avi = slaim(alk,alonglength);
f = gsw_f(latc);
g = 9.81*ones(size(f));

% >>>>>>>> First get along-track distance
[E,~] = lonlat2km(lonc(1:end-1,:),latc(1:end-1,:),lonc(2:end,:),latc(2:end,:));
[~,N] = lonlat2km(lonc(:,1:end-1),latc(:,1:end-1),lonc(:,2:end),latc(:,2:end));
DZ = cat(1,zeros(1,size(lonc,2)),cumsum(E,1)); % distance-zonal
DM = cat(2,zeros(1,size(lonc,1))',cumsum(N,2)); % distance-meridional

dx = vdiff(DZ,1).*1000;
dy = vdiff(DM,2).*1000;

% >>>>>>>> Get d(eta) in x and y
detax = vdiff(eta,1);
detay = vdiff(eta,2);

% >>>>>>>> Geostrophic velocity (cm/s)
vga = (g./f).*(detax./dx).*100;
uga = -(g./f).*(detay./dy).*100;

sp=2;
uga = smooth2a(uga,sp,sp);
vga = smooth2a(vga,sp,sp);

figure
pcolor(ydist2,xdist2,sqrt(uga.^2+vga.^2)),shading flat,hold on;%mi=18;ma=38;
quiver(ydist2,xdist2,uga,vga,.1,'k'),hold on
xlim([0 50])
ylim([400 500])
cmocean('balance')
set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
fontsize(20,20,20,20)

% -------------------------------------  VORTICITY

% >>>>>>>> Get d(eta) in x and y
dudx = vdiff(uga./100,1)./dx;
dvdx = vdiff(vga./100,1)./dx;
dudy = vdiff(uga./100,2)./dy;
dvdy = vdiff(vga./100,2)./dy;

vort = dvdx-dudy;
div = dudx+dvdy;
stn = dudx-dvdy;
sts = dvdx+dudy;

figure
pcolor(lonc,latc,vort./f),shading flat,hold on;%mi=.18;ma=.38;
%
xlim([15.7 16.4])
ylim([-34.2 -33.6])
caxis([-12 4])
cmocean('balance')
set(gcf,'color','w'),set(gca,'Layer','Top'), box on, grid on
fontsize(25,25,25,25);%fontsize(20,20,20,20)
Y=get(gca,'ylim');set(gca,'dataaspectratio',[1 cos((Y(2)+Y(1))/2/180*pi) 1])

%% SST and OC

% ------------------- AGULHAS SST coherent eddy
fileO = '/Users/archer/SNPP_VIIRS.20230802T124200.L2.SST.NRT.nc';

% Get Time
[~,fname,~] = fileparts(fileO);y = str2num(fname(12:15));m = str2num(fname(16:17));d = str2num(fname(18:19));
time = datenum(y,m,d); clear y m d
% Get Lon/Lat/Var (swath)
lonO = ncread(fileO,'/navigation_data/longitude');
latO = ncread(fileO,'/navigation_data/latitude');
SST = ncread(fileO,'/geophysical_data/sst'); SST_corr = SST;
SST_flag = ncread(fileO,'/geophysical_data/qual_sst'); 

% M_MAP
% Plot Main Figure
figure
m_proj('miller','lon',([15 17]), 'lat',([-35 -32.5]));hold on;
m_pcolor(lonO,latO,SST_corr);shading flat;hold on
caxis([14 17])
