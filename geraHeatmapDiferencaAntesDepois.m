load('heatmap_Antes_5iAntes.mat')
load('heatmap_Depois_5iDepois.mat')
parameters_heatmap = [{'AlignVertexCenters','on','FaceColor','interp'};{'EdgeColor', 'none','AlignVertexCenters','on'}];
load('position.mat')
load('position_label.mat')
for i=1:8
    antes = heatmap_Antes_5i{i};
    depois = heatmap_Depois_5i{i};
    diff = zeros(171,99);
    diff(depois<antes) = 1;
%     diff = antes-depois;
    
    
    
    p1 = figure('Position',[1,30,1540,750]);
    ax1 = axes('Parent',p1);
    per = {'Antes','Depois'};
    k = 1
    pc = pcolor(diff');
%     colormap('jet');
    set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap
    set(pc,'LineStyle','none');
    set(findall(p1,'Type','Text'),'FontSize',24)
    set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',position_label,'YTick',[1:99],'YTickLabel',[1:99],...
        'FontSize',8,'Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
        'TickLabelInterpreter','none');
    ylabel('Frequency (Hz)');
    xlabel('Pairs of Channels');
    h = colorbar;
%     caxis([min(min_value_all) max(max_value_all(j))]);
    annotation(p1,'line',[0.171575332259342 0.171575332259342],[0.0823333333333333 0.96509009009009],'Color',[1 1 1],'LineWidth',2);
    annotation(p1,'line',[0.300552474801661 0.300552474801661],[0.0812072072072072 0.96509009009009],'Color',[1 1 1],'LineWidth',2);
    annotation(p1,'line',[0.315512097746243 0.315512097746243],[0.0811954767267268 0.967330611861862],'Color',[1 1 1],'LineWidth',2);
    annotation(p1,'line',[0.445477786808174 0.445477786808174],[0.0811954767267269 0.967330611861862],'Color',[1 1 1],'LineWidth',2);
    annotation(p1,'line',[0.594659633335007 0.594659633335007],[0.078954954954955 0.966216216216216],'Color',[1 1 1],'LineWidth',2);
end