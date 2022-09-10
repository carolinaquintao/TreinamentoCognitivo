%script para implementar a analise do minimum spanning tree dos canais
%escolhidos da analise de corr e significancia 

%input >>>  undirected graph object
G = graph(1,2); % 1 aresta e 2 nos 

% returns the minimum spanning tree, T, for graph G.
T = minspantree(G);

%% -----------------------------------------------------------
% Create and plot a cube graph with weighted edges

s = [1 1 1 2 5 3 6 4 7 8 8 8]; %indices das combinacoes dos pares 
t = [2 3 4 5 3 6 4 7 2 6 7 5];

weights = [100 10 10 10 10 20 10 30 50 10 70 10]; %connectividade
G = graph(s,t,weights);
p = plot(G,'EdgeLabel',G.Edges.Weight);

%% ------------------------------------------------
% S11D -  combinacao dos pares 

%% Criando labels dos pares de connectividade 

%loading channels
load('./Matrizes/ch_label_19.mat'); 

pairs_cmb_names = nchoosek(ch_label,2); % store the 171 combination pairs
[~,pairs_cmb_idx]=ismember(pairs_cmb_names,ch_label); 

% Editing Ch_cmb to only one column
for i = 1:length(pairs_cmb_names)
    pairs_cmb_names(i,1) = strcat(pairs_cmb_names(i,1),'_',pairs_cmb_names(i,2));
end
pairs_cmb_names(:,2) = [];

save('./Matrizes/pairs_cmb.mat','pairs_cmb_names');
save('./Matrizes/pairs_cmb_idx.mat','pairs_cmb_idx');

%% Turning conn matrix to line matrix 
load('./S11D/Connectivity_S11D/Benchmarck/ARMP_36_20/freqAnalysis/wpli_debiased/conn_alfa.mat'); %cell 6 x 1 ( 3i e 3f)

%Custom position of EEG1020
load('./Matrizes/tx.mat');
load('./Matrizes/ty.mat');

p.XData = tx';
p.YData = ty';

a = conn_alfa{1};
a = mean(a,3); %Mean in frequency

a2 = nonzeros(tril(a)); %select values of lower triangle and remove zeros 

%turning to graph 
weights = a2; %connectividade
G = graph(pairs_cmb_idx(:,1),pairs_cmb_idx(:,2),weights);

% Line width with connectivity 
% G.Edges.LWidths = 7*G.Edges.Weight/max(G.Edges.Weight);
G.Edges.LWidths = 7*G.Edges.Weight/max(G.Edges.Weight);

% p2 = plot(G,'EdgeLabel',G.Edges.Weight,'NodeLabel',ch_label,'LineStyle','--');
figure;p = plot(G,'NodeLabel',ch_label,'LineWidth',abs(G.Edges.LWidths),'XData',tx,'YData',ty);

% returns the minimum spanning tree, T, for graph G.
T = minspantree(G);

% Line width with connectivity 
T.Edges.LWidths = 1*T.Edges.Weight/max(T.Edges.Weight);

%% plotting

figure('Position',[200,200,1000,500]);
subplot(1,2,1);
% plot(T,'NodeLabel',ch_label,'XData',tx,'YData',ty); %EEG1020 positions
plot(G,'NodeLabel',ch_label,'XData',tx,'YData',ty,'LineStyle',':');
hold on;
plot(T,'NodeLabel',ch_label,'XData',tx,'YData',ty,'EdgeColor','r','LineWidth',abs(T.Edges.LWidths));
subplot(1,2,2);
plot(T,'NodeLabel',ch_label); %Graph position 

%Plot com intensidade de connectividade e mst evidenciado 
%Todas as intensidades
figure;p = plot(G,'NodeLabel',ch_label,'XData',tx,'YData',ty,'LineWidth',abs(G.Edges.LWidths));
highlight(p,T,'LineStyle','-','EdgeColor','r');

%Apenas a do mst
figure;plot(G,'NodeLabel',ch_label,'XData',tx,'YData',ty,'LineStyle',':');
hold on;
plot(T,'NodeLabel',ch_label,'XData',tx,'YData',ty,'EdgeColor','r','LineWidth',abs(T.Edges.LWidths));

%Plot do grafo no layout de formato 
figure;plot(T,'NodeLabel',ch_label); %Graph position 

