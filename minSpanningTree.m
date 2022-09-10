%script para implementar a analise do minimum spanning tree dos canais
%escolhidos da analise de corr e significancia 

%% ------------------------------------------------
% S11D -  combinacao dos pares 

% %loading channels
% load('./Matrizes/ch_label_19.mat'); %Labels of 19 channels 
% load('./Matrizes/pairs_cmb.mat'); %Channels combination labels
% load('./Matrizes/pairs_cmb_idx.mat'); %Channels combination index
path_conn = 'D:/treinamentoCognitivo/GraphAnalysis/S11D/Connectivity_S11D/';
%Frequencies
freqbdw_label = {'alfa','beta','teta','alfa1'}%,'alfa2','beta1','beta2','gama1','gama2','gama','delta','mu','baixasFreq'};
freqbdw =       {'8:15','15:30','4:8','8:10'}%,'10:15'}%,'15:19'}%,'19:30','30:60','60:100','30:100','1:4','12:15','1:8'};


%Loading Connectivity Matrix per subject
load('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_freq_meansubj_rt.mat'); %RT 25 x 1 x 7{19 x 19}
load('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_rtPos.mat'); % Pos_RT 25 x 1 x 7{19 x 19}
load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_3i.mat'); %Bench_3i  25 x 1 x 7{19 x 19}
load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_3f.mat'); %Bench_3f  25 x 1 x 7{19 x 19}

%Mean of all subjects 
load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_meanfreq_meansubj_3i.mat');% 7 x 1 {19 x 19}
load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_meanfreq_meansubj_3f.mat');% 7 x 1 {19 x 19}

%Mean per group 
load([path_conn,'conn_matrix_meanfreq_meansubj_3i_e.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3i_b.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3i_r.mat']); % 7 x 1 {19 x 19}}

load([path_conn,'conn_matrix_meanfreq_meansubj_3f_e.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3f_b.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3f_r.mat']); % 7 x 1 {19 x 19}

% conn_matrix_freq_meansubj_3i_r = conn_matrix_meanfreq_meansubj_3i_r;
% save([path_conn,'conn_matrix_freq_meansubj_3i_r.mat','conn_matrix_freq_meansubj_3i_r');
% 
% conn_matrix_meanfreq_meansubj_3i_r = cellfun(@(x) mean(x,3),conn_matrix_meanfreq_meansubj_3i_r,'un',0); % 7 x 1 {19 x 19}
% save([path_conn,'conn_matrix_meanfreq_meansubj_3i_r.mat'],'conn_matrix_meanfreq_meansubj_3i_r');

% Arquivos RT e RTPos
% conn_matrix_meanfreq_meansubj_rt,
% conn_matrix_meanfreq_meansubj_rtPos
% 
% conn_matrix_meanfreq_meansubj_e_rt
% conn_matrix_meanfreq_meansubj_b_rt
% conn_matrix_meanfreq_meansubj_r_rt 
% 
% conn_matrix_meanfreq_meansubj_e_rtPos
% conn_matrix_meanfreq_meansubj_b_rtPos
% conn_matrix_meanfreq_meansubj_r_rtPos

%Arquivos Bench 
% conn_matrix_meanfreq_meansubj_3i,
% conn_matrix_meanfreq_meansubj_3f
%conn_matrix_meanfreq_meansubj_3i_e,
% conn_matrix_meanfreq_meansubj_3i_b,
% conn_matrix_meanfreq_meansubj_3i_r,
% conn_matrix_meanfreq_meansubj_3f_e,
% conn_matrix_meanfreq_meansubj_3f_b,
% conn_matrix_meanfreq_meansubj_3f_r

%  conn_matrix_meanfreq_meansubj_e_rt = cellfun(@(x) mean(x,3),conn_matrix_freq_meansubj_e,'un',0);
%  conn_matrix_meanfreq_meansubj_e_rtPos = cellfun(@(x) mean(x,3),conn_matrix_freq_meansubj_e,'un',0);

% save('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_meanfreq_meansubj_e_rt.mat','conn_matrix_meanfreq_meansubj_e_rt');
% save('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_meanfreq_meansubj_e_rtPos.mat','conn_matrix_meanfreq_meansubj_e_rtPos');

% %RT
% v_conn_data_graph_analysis_rt = {conn_matrix_meanfreq_meansubj_rt,...
% conn_matrix_meanfreq_meansubj_rtPos,...
% conn_matrix_meanfreq_meansubj_e_rt,...
% conn_matrix_meanfreq_meansubj_b_rt,...
% conn_matrix_meanfreq_meansubj_r_rt,...
% conn_matrix_meanfreq_meansubj_e_rtPos,...
% conn_matrix_meanfreq_meansubj_b_rtPos,...
% conn_matrix_meanfreq_meansubj_r_rtPos}; %1x8 cell
% 
% save('./S11D/Connectivity_S11D/v_conn_data_graph_analysis_rt.mat','v_conn_data_graph_analysis_rt');
%% Nova divisao de grupos 

%Loading original matrices without frequency distinction
%Mean of all subjects 
%Array without groups 
load([path_conn,'conn_matrix_meanfreq_meansubj_3i.mat']);% 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3f.mat']);% 7 x 1 {19 x 19}

%Mean per group 
load([path_conn,'conn_matrix_meanfreq_meansubj_3i_e.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3i_b.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3i_r.mat']); % 7 x 1 {19 x 19}}

load([path_conn,'conn_matrix_meanfreq_meansubj_3f_e.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3f_b.mat']); % 7 x 1 {19 x 19}
load([path_conn,'conn_matrix_meanfreq_meansubj_3f_r.mat']); % 7 x 1 {19 x 19}
        
%% Criando vetor de Bench
v_conn_data_graph_analysis_bench = {conn_matrix_meanfreq_meansubj_3i,conn_matrix_meanfreq_meansubj_3f,...
    conn_matrix_meanfreq_meansubj_3i_e,conn_matrix_meanfreq_meansubj_3i_b,conn_matrix_meanfreq_meansubj_3i_r,...
        conn_matrix_meanfreq_meansubj_3f_e,conn_matrix_meanfreq_meansubj_3f_b,conn_matrix_meanfreq_meansubj_3f_r}; %1x8 cell
    
% Obtendo a media dos maiores valores de conn ao longo das frequencias 
for i = 1:length(freqbdw)
    max_values3i{i} = max(max(max(conn_matrix_meanfreq_meansubj_3i{i}))); 
    max_values3f{i} = max(max(max(conn_matrix_meanfreq_meansubj_3f{i}))); 
end

mean_max_values_3i = mean(cell2mat(max_values3i)); %0.022 -> thld (0.012 - 0.022 - 0.032)
mean_max_values_3f = mean(cell2mat(max_values3f)); %0.028 -> thld (0.018 - 0.028 - 0.038)
    
v_conn_data_graph_analysis_rt_labels = {'conn_matrix_meanfreq_meansubj_rt','conn_matrix_meanfreq_meansubj_rtPos',...
'conn_matrix_meanfreq_meansubj_e_rt','conn_matrix_meanfreq_meansubj_b_rt','conn_matrix_meanfreq_meansubj_r_rt',...
'conn_matrix_meanfreq_meansubj_e_rtPos','conn_matrix_meanfreq_meansubj_b_rtPos','conn_matrix_meanfreq_meansubj_r_rtPos'}; %1x8 cell

%% Bench
v_conn_data_graph_analysis_bench = {conn_matrix_meanfreq_meansubj_3i,conn_matrix_meanfreq_meansubj_3f,...
    conn_matrix_meanfreq_meansubj_3i_e,conn_matrix_meanfreq_meansubj_3i_b,conn_matrix_meanfreq_meansubj_3i_r,...
        conn_matrix_meanfreq_meansubj_3f_e,conn_matrix_meanfreq_meansubj_3f_b,conn_matrix_meanfreq_meansubj_3f_r}; %1x8 cell
    
v_conn_data_graph_analysis_bench_label = {'conn_matrix_meanfreq_meansubj_3i','conn_matrix_meanfreq_meansubj_3f',...
    'conn_matrix_meanfreq_meansubj_3i_e','conn_matrix_meanfreq_meansubj_3i_b','conn_matrix_meanfreq_meansubj_3i_r',...
        'conn_matrix_meanfreq_meansubj_3f_e','conn_matrix_meanfreq_meansubj_3f_b','conn_matrix_meanfreq_meansubj_3f_r'};
%% A media nas frequencias pode ser feita com uma cellfun

%Custom positions of EEG1020 (plotting)
load('tx.mat');
load('ty.mat');

%% Turning conn matrix to line matrix 

% v_conn_data_graph_analysis 7 x 1 {19 x 19}

%Criando pasta para a anlise de grafos 
mkdir('./S11D/Graph_analysis_MST_NewGroups_Division/');

%Fazer função que receba os elementos do vetor e retorne os plots e
%variaveis guardadas em uma pasta de grafos 

%% Definição de threshold individual dos grupos pela mediana de cada grupo 


%% Analise de GRAFOS de conectividade 
%computacao da mediana
thrd_values = cell(v_conn_data_graph_analysis_rt_labels); 
%% RT
% % cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_rt,v_conn_data_graph_analysis_rt_labels);
% cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_rt(4),v_conn_data_graph_analysis_rt_labels(4));
% 
% disp('Fim');
% delete('./S11D/Connectivity_S11D/prompt.mat');
% delete('./S11D/Connectivity_S11D/thrd.mat');
%% Bench
cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_bench,v_conn_data_graph_analysis_bench_label);
disp('Fim');
delete('./S11D/Connectivity_S11D/prompt.mat');
delete('./S11D/Connectivity_S11D/thrd.mat');

%% Analise dos valores de connectividade com boxplot

%rt
% [ conn_perfreq_perch_boxplot,conn_perfreq_boxplot ] = cellfun(@conn_boxplot_per_group,v_conn_data_graph_analysis_rt,v_conn_data_graph_analysis_rt_labels,'un',0);
% disp('Fim');

%% Bench
[ conn_perfreq_perch_boxplot_bench,conn_perfreq_boxplot_bench ] = cellfun(@conn_boxplot_per_group,v_conn_data_graph_analysis_bench,v_conn_data_graph_analysis_bench_label,'un',0);
disp('Fim');

%% BoxPlot de conectividade por grupo
% Plot para todos os pares de cada canal
xtick_label_rt = {'Rt','Posrt','Rt_E','Rt_B','Rt_R','Posrt_E','Posrt_B','Posrt_R'};
xtick_label_bench = {'3i','3f','3i_E','3i_B','3i_R','3f_E','3f_B','3f_R'};

%Frequencies
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%Reorganizing values
conn_perfreq_boxplot_array = cellfun(@(x) cell2mat(x),conn_perfreq_boxplot,'un',0);% 8 times 171 x 7
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/conn_perfreq_boxplot_array_rt.mat','conn_perfreq_boxplot_array');

conn_perfreq_boxplot_array_bench = cellfun(@(x) cell2mat(x),conn_perfreq_boxplot_bench,'un',0);
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/conn_perfreq_boxplot_array_bench.mat','conn_perfreq_boxplot_array_bench');

%%
for i = 1:length(freqbdw_label)
    for j = 1:length(xtick_label_rt)
        
        conn_perfreq_boxplot_array_freqpercoletas{i}(:,j) = conn_perfreq_boxplot_array{j}(:,i);
        conn_perfreq_boxplot_array_freqpercoletas_bench{i}(:,j) = conn_perfreq_boxplot_array_bench{j}(:,i);
         
    end
    
    %RT
    figure('Position',[100,100,850,500]);
    boxplot(conn_perfreq_boxplot_array_freqpercoletas{i})
%     boxplot(conn_perfreq_boxplot_array_freqpercoletas_bench{i})
    set(gca,'XTick',[1:length(xtick_label_rt)],'XTickLabel',xtick_label_rt);
    xlabel('Coletas','fontweight','bold');
    ylabel('Conectividade','fontweight','bold');
%     title(['Variacao de Conectividade por banda de frequencia para cada coleta ',freqbdw_label{i}])
    
    saveas(gcf,['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/boxplot_coletas_',freqbdw_label{i},'.fig']);
    saveas(gcf,['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/boxplot_coletas_',freqbdw_label{i},'.png']);
    close;
    
    %bench
    figure('Position',[100,100,850,500]);
    boxplot(conn_perfreq_boxplot_array_freqpercoletas_bench{i})
%     boxplot(conn_perfreq_boxplot_array_freqpercoletas_bench{i})
    set(gca,'XTick',[1:length(xtick_label_bench)],'XTickLabel',xtick_label_bench);
    xlabel('Coletas','fontweight','bold');
    ylabel('Conectividade','fontweight','bold');
%     title(['Variacao de Conectividade por banda de frequencia para cada coleta ',freqbdw_label{i}])
    
    saveas(gcf,['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/boxplot_coletas_bench_',freqbdw_label{i},'.fig']);
    saveas(gcf,['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/boxplot_coletas_bench_',freqbdw_label{i},'.png']);
    close;
    
end
 
save('./S11D/Graph_analysis_NewGroups_Division/Boxplot/conn_perfreq_boxplot_array_freqpercoletas.mat','conn_perfreq_boxplot_array_freqpercoletas');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/conn_perfreq_boxplot_array_freqpercoletas_bench.mat','conn_perfreq_boxplot_array_freqpercoletas_bench');
%%
for j = 1:length(xtick_label)
    % boxplot de cada grupamento em todas as bandas de frequencia
    figure
    boxplot(conn_perfreq_boxplot_array{j});
    set(gca,'XTick',[1:length(freqbdw_label)],'XTickLabel',freqbdw_label);
    xlabel('Canais')
    ylabel(['Banda de frequencia',xtick_label{j}])
    title(['Variacao de Conectividade por banda de frequencia'])
    
    saveas(gcf,['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/boxplot/boxplot_perfreq',freqbdw_label{i},'.fig']);
    saveas(gcf,['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/boxplot/boxplot_perfreq',freqbdw_label{i},'.png']);
    close;
end

%% Analise de Centralidade