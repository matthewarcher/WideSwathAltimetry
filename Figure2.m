% Plot Figure 2

clear;clc

load coastlines % default matlab coastline data

pathdir = '/Users/archer/Documents/SWOT/AVISO_Karin_ComparisonWork/karinHP_binned/';
files = dir([pathdir '*.mat']);	

bindnum=[];
for i = 1:length(files)
    
    % Build filename path
    fname = [files(i).folder '/' files(i).name];
    
    % Load data
    load(fname)
    
    % Save to workspace as new variable
    eval(['diffbin' num2str(i) '= karinbin;'])
    
    clear diffbin bindnum bindnumf
    
end

% STD of Difference
for ii = 1:size(diffbin1,1)
    for jj = 1:size(diffbin1,2)

        difflist=[];
        for kk = 1:length(files)
            eval(['difflist = [difflist diffbin' num2str(kk) '{ii,jj}];']);
        end

        % STD 
        data(ii,jj) = nanstd(difflist(:));

    end
end

% Plot Figure
figure
m_proj('robinson','lon',([-180 180]), 'lat',([-90 90]));hold on;
m_pcolor(lonb2,latb2,data),shading flat,hold on
caxis([0 .1])
cmocean('-deep')
[CS,CH]=m_etopo2('contour',10,'edgecolor',[.55 .55 .55]);
m_coast('patch',[0.7 0.7 0.7],'edgecolor','k'); % Using gray color [0 175 0] 
m_grid('linest','none','linewidth',2,'yaxisloc','left','fontsize',20,'fontweight','bold');
set(gcf,'color','w'),
colorbar('Location','SouthOutside')
fontsize(20,20,20,20)
