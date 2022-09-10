%Script para detectar ciclos nos grafos gerados com e sem threshold 

%%Loading chanels indexes from folder 
load('./Matrizes/Ocorrencia/v_regions_index.mat')
% v_regions_index = getNamesFromFolder('./Matrizes/index_chregions_s11d/','v_'); 

for i = 1:length(v_regions_index)
%     load(['./Matrizes/',v_regions_index{i}]);
      load([v_regions_index{2,i},'\',v_regions_index{1,i}]);
end

%% Criar cores para cada regiao 

%Fronto Polar -> verde
%Frontal -> vermelha
%Temporal -> laranja
%Parietal -> lilas
%Ociptal -> azul

%TODO -  Fazaer funcao que identifique os z-canais
%Removendo os canais z dos indices de cada regiao
v_f = [3,4,5,6];
v_c = [13,14];
v_fp = [1,2];
v_o = [15,16];
v_p = [11,12];
v_t = [7,8,9,10];
v_zChannels = [17;18;19];

ch_label_select_idx = unique(G{1}.Edges.EndNodes);
ch_label_select = ch_label(ch_label_select_idx);

%% Reordering nodes - grouping chanels per region 

ch_regions = [v_fp;v_f;v_t;v_p;v_c;v_o;v_zChannels];

order = ch_regions(ismember(ch_regions,ch_label_select_idx));
nchoosek(order,2); %combinacao de pares

% H = reordernodes(G{1},order);


%%
figure;
p=plot(G{1},'Layout','auto','NodeLabel',ch_regions_label);
% highlight(p,intersect(v_f,ch_label_select_idx),'NodeColor','r')
highlight(p,intersect(v_fp,ch_label_select_idx),'NodeColor','g')


%%
figure;
p=plot(G{1},'Layout','force','NodeLabel',ch_regions_label);
highlight(p,intersect(v_f,ch_label_select_idx),'NodeColor','r')
highlight(p,intersect(v_fp,[1:19]),'NodeColor','[0.4660 0.6740 0.1880]')
highlight(p,intersect(v_t,[1:19]),'NodeColor','[0.8500 0.3250 0.0980]')
highlight(p,intersect(v_p,[1:19]),'NodeColor','[0.4940 0.1840 0.5560]')
highlight(p,intersect(v_c,[1:19]),'NodeColor','[0.9290 0.6940 0.1250]')
highlight(p,intersect(v_o,[1:19]),'NodeColor','c')
highlight(p,intersect(v_zChannels,[1:19]),'NodeColor','k')

%%
figure;
p = plot(G{1},'Layout','layered','NodeLabel',ch_regions_label);


%%
figure;
p = plot(G{1},'Layout','subspace','NodeLabel',ch_regions_label);
highlight(p,intersect(v_f,[1:19]),'NodeColor','r')
highlight(p,intersect(v_fp,[1:19]),'NodeColor','[0.4660 0.6740 0.1880]')
highlight(p,intersect(v_t,[1:19]),'NodeColor','[0.8500 0.3250 0.0980]')
highlight(p,intersect(v_p,[1:19]),'NodeColor','[0.4940 0.1840 0.5560]')
highlight(p,intersect(v_c,[1:19]),'NodeColor','[0.9290 0.6940 0.1250]')
highlight(p,intersect(v_o,[1:19]),'NodeColor','c')
highlight(p,intersect(v_zChannels,[1:19]),'NodeColor','k')

%%
figure('Position',[100,100,450,450]);
% p = plot(G{1},'Layout','circle','NodeLabel',ch_label_select,'MarkerSize',8,'Marker','s');
p = plot(G{1},'Layout','circle','MarkerSize',8,'NodeLabel',ch_regions_label);

highlight(p,intersect(v_f,[1:19]),'NodeColor','r')
highlight(p,intersect(v_fp,[1:19]),'NodeColor','[0.4660 0.6740 0.1880]')
highlight(p,intersect(v_t,[1:19]),'NodeColor','[0.8500 0.3250 0.0980]')
highlight(p,intersect(v_p,[1:19]),'NodeColor','[0.4940 0.1840 0.5560]')
highlight(p,intersect(v_c,[1:19]),'NodeColor','[0.9290 0.6940 0.1250]')
highlight(p,intersect(v_o,[1:19]),'NodeColor','c')
highlight(p,intersect(v_zChannels,[1:19]),'NodeColor','k')


%% 
figure;
h = plot(G{1},'Layout','circle','NodeLabel',ch_regions_label); 

%%
figure;
h = plot(G{1},'Layout','auto','NodeLabel',ch_regions_label);