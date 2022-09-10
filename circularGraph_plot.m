%% To simply make circular graph 
% From conn matrix itself 

%Need to reorganize pairs from the conn matrix in the order of ch_regions
%% Getting nonzero elements position 

A = [1,2,3]; B = [4,5];

%Get alll combinations from both arrays 
[m,n]=ndgrid(A,B); 
Z = [m(:),n(:)]

%This code is necessary, once the reorganization of channels in
%conn_matrix, change the rows order, but keep columns in the original
%order, so to get the new combination of pairs, 

%% Reordering nodes - grouping chanels per region 

%% Loading channels 

%%Loading chanels indexes from folder 
load('./Matrizes/Ocorrencia/v_regions_index.mat')
% v_regions_index = getNamesFromFolder('./Matrizes/index_chregions_s11d/','v_'); 

for i = 1:length(v_regions_index)
%     load(['./Matrizes/',v_regions_index{i}]);
      load([v_regions_index{2,i},'\',v_regions_index{1,i}]);
end

%Index of Z channels
load('./Matrizes/ch_label_19.mat');
v_zChannels = [4;8;19];

%Removendo os canais z dos indices de cada regiao
v_f = setdiff(v_f,v_zChannels);
v_c = setdiff(v_c,v_zChannels);
v_fp = setdiff(v_fp,v_zChannels);
v_o = setdiff(v_o,v_zChannels);
v_p = setdiff(v_p,v_zChannels);
v_t = setdiff(v_t,v_zChannels);

ch_label_select_idx = unique(G{1}.Edges.EndNodes);
ch_label_select = ch_label(ch_label_select_idx);


ch_regions = [v_fp;v_f;v_t;v_p;v_c;v_o;v_zChannels];
ch_regions_label = ch_label(ch_regions);
pairs_cmb_ch_regions = nchoosek(ch_regions,2); %combinacao de pares

order = ch_regions(ismember(ch_regions,ch_label_select_idx));
nchoosek(order,2); %combinacao de pares

save('./Matrizes/ch_regions.mat','ch_regions');
save('./Matrizes/ch_regions_label.mat','ch_regions_label');
save('./Matrizes/pairs_cmb_ch_regions.mat','pairs_cmb_ch_regions');

%% Reorganizing matrix in the ch_region order, which group channels from the
%same region
a = conn_matrix_meanfreq_meansubj_3f{1};
a = a([ch_regions'],:)

%%
% rng(0);
% x = rand(50);
% thresh = 0.93;
% x(x >  thresh) = 1;
% x(x <= thresh) = 0;
% 
% % Call CIRCULARGRAPH with only the adjacency matrix as an argument.
% circularGraph(x);

x = G{1};
thresh = 0.016;
x(x >  thresh) = 1;
x(x <= thresh) = 0;

% Call CIRCULARGRAPH with only the adjacency matrix as an argument.
figure;circularGraph(x,'Label',ch_regions_label);

% Create custom colormap
myColorMap = lines(length(x));

% figure;circularGraph(x,'Colormap',myColorMap,'Label',ch_regions_label);
% figure;circularGraph(x,'Colormap',myColorMap);