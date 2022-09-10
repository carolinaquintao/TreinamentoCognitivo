%% Aqui os canais selecionados (com corr > .7 e significativos entre os estados em RT e RT_pos e Bench31 e Bench3f)
% serao separados por grupo para analise do comportamento dos mesmos.

%% Carregando cells com valores de conn. organizados por frequencia e por sujeito 

% Indices das frequencias
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%Labels dos canais 
%ch_label

%Matrizes de conectividade de acordo com  tempo de 
% RT
% conn_matrix_freq_rt = matfile('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_freq.mat');%25 x 1 x 7
if exist('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_rt.mat') == 2 %Se existir
    load('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_rt.mat');
else
    load('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_freq.mat');
    %Taking mean in the frequency
    conn_matrix_rt = cellfun(@(x) mean(x,3),conn_matrix_freq,'un',0);
    save('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_rt.mat','conn_matrix_rt')
end

% conn_matrix_freq_rtPos = matfile('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_freq.mat');
% conn_matrix_freq_rtPos = load('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_freq.mat');

if exist('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_rtPos.mat') == 2
    load('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_rtPos.mat');
else   
    load('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_freq.mat');
    conn_matrix_rtPos = cellfun(@(x) mean(x,3),conn_matrix_freq,'un',0);

    save('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_rtPos.mat','conn_matrix_rtPos')

end
% Benchmarck
load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_Mean3i.mat');%25x1x7
load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_Mean3f.mat');

%A media na banda sera calculada para a selecao dos canais 

if exist('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_bench3i.mat') == 2
    load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_bench3i.mat');
    load('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_bench3f.mat');
else
    
    conn_matrix_bench3i = cellfun(@(x) mean(x,3),conn_matrix_Mean3i,'un',0);
    conn_matrix_bench3f = cellfun(@(x) mean(x,3),conn_matrix_Mean3f,'un',0);

    save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_bench3i.mat','conn_matrix_bench3i');
    save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_bench3f.mat','conn_matrix_bench3f');
end
%% Indices de sujeitos e frequencias 

%Carrega nomes
load('./Matrizes/namesSet18.mat');

%indices de sujeitos de um grupo 
idx_e = [2,5,6,7,13,16,18,19,20];
idx_b = [1,4,8,9,14,15,17,22,21,23,24,25];
idx_r = [3,11,12];
% idx_r = [3,10,11,12]; %Com FFS

%Vetor de sujeitos 
v_grupos_idx = {idx_e,idx_b,idx_r};

%construindo var com valores de conn por grupo
for i = 1:3
    conn_matrix_rt_groups{i} = conn_matrix_rt(v_grupos_idx{i},:,:);
    conn_matrix_rtPos_groups{i} = conn_matrix_rtPos(v_grupos_idx{i},:,:);
    conn_matrix_bench3i_groups{i} = conn_matrix_bench3i(v_grupos_idx{i},:,:);
    conn_matrix_bench3f_groups{i} = conn_matrix_bench3f(v_grupos_idx{i},:,:);
end

%vetor de frequencias analisadas
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%% Para  RT apenas os parietais em alpha tiveram valores significativos e

%% Aqui crio uma variavel artificial para conter apenas os canais, nas frequencias especificas que segundo a literatura 
% sao indicadores da fadiga mental 

%Para  RT apenas os parietais em alpha tiveram valores significativos e
%corr + (Pearson) com PSD
ch_selec_pos_rt_artificial = zeros(2,1);

ch_selec_pos_rt_artificial(1) = 1;%P3
ch_selec_pos_rt_artificial(2) = 7;%P4

freq_selec_pos_rt_artificial = zeros(2,1);

freq_selec_pos_rt_artificial(1) = 1;%alpha
freq_selec_pos_rt_artificial(2) = 1;%alpha

%Turning to cell (index) and cell of strings (labels)
v_ch_selec_label_rt_pos = cell(1,length(ch_selec_pos_rt_artificial));

if length(ch_selec_pos_rt_artificial) == 0
        v_ch_selec_label_rt_pos{i} = ['none'];
        v_ch_selec_rt_pos{i} = ['none'];
else
    for i = 1:length(ch_selec_pos_rt_artificial)
     v_ch_selec_label_rt_pos{i} = [ch_label{ch_selec_pos_rt_artificial(i)},'-',freqbdw_label{freq_selec_pos_rt_artificial(i)}];
     v_ch_selec_rt_pos{i} = [ch_selec_pos_rt_artificial(i) freq_selec_pos_rt_artificial(i)];
    end
end

%Para  Benchmark apenas F8-Theta e P3-alpha1 tiveram valores significativos e
%corr + (Pearson) com PSD
ch_selec_pos_bench_artificial = zeros(2,1);

ch_selec_pos_bench_artificial(1) = 1;%P3
ch_selec_pos_bench_artificial(2) = 16;%F8

freq_selec_pos_rt_artificial = zeros(2,1);

freq_selec_pos_bench_artificial(1) = 4;%alpha1
freq_selec_pos_bench_artificial(2) = 3;%tetha

%Turning to cell (index) and cell of strings (labels)
v_ch_selec_label_bench_pos = cell(1,length(ch_selec_pos_rt_artificial));

if length(ch_selec_pos_rt_artificial) == 0
        v_ch_selec_label_bench_pos{i} = ['none'];
        v_ch_selec_bench_pos{i} = ['none'];
else
    for i = 1:length(ch_selec_pos_bench_artificial)
     v_ch_selec_label_bench_pos{i} = [ch_label{ch_selec_pos_bench_artificial(i)},'-',freqbdw_label{freq_selec_pos_bench_artificial(i)}];
     v_ch_selec_bench_pos{i} = [ch_selec_pos_bench_artificial(i) freq_selec_pos_bench_artificial(i)];
    end
end

%% Obtendo variacao da conectividade para todos os pares dos canais
% selecionados 
% varia_conn_rt_pos_selec = cell(3,19,19);

for i = 1:3 % 3 groups
    for k = 1:size(conn_matrix_rt_groups{i},1) %Quantidade de sujeitos por grupo
        for l = 1:length(ch_selec_pos_rt_artificial) %Pares selecionados
            for j =1:19 %All pairs combinations
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_rtPos_rt_selec{i}{k,l,j} = conn_matrix_rtPos_groups{i}{k,1,v_ch_selec_rt_pos{l}(2)}(v_ch_selec_rt_pos{l}(1),j) ./ conn_matrix_rt_groups{i}{k,1,v_ch_selec_rt_pos{l}(2)}(v_ch_selec_rt_pos{l}(1),j);
            varia_conn_bench3f_bench3i_selec{i}{k,l,j} = conn_matrix_bench3f_groups{i}{k,1,v_ch_selec_bench_pos{l}(2)}(v_ch_selec_bench_pos{l}(1),j) ./ conn_matrix_bench3i_groups{i}{k,1,v_ch_selec_bench_pos{l}(2)}(v_ch_selec_bench_pos{l}(1),j);
            end
        end
    end
end

save('./S11D/Ocorrencia/varia_conn_rtPos_rt_selec.mat','varia_conn_rtPos_rt_selec');
save('./S11D/Ocorrencia/varia_conn_bench3f_bench3i_selec.mat','varia_conn_bench3f_bench3i_selec');

%% Media dos sujeitos por grupo de desempenho

for i = 1:3
    varia_conn_rt_selec_meanSubj{i} = permute(mean(cell2mat(varia_conn_rtPos_rt_selec{i}),1),[2,3,1]);
    varia_conn_bench_selec_meanSubj{i} = permute(mean(cell2mat(varia_conn_bench3f_bench3i_selec{i}),1),[2,3,1]);
end

save('./S11D/Ocorrencia/varia_conn_rt_selec_meanSubj.mat','varia_conn_rt_selec_meanSubj');
save('./S11D/Ocorrencia/varia_conn_bench_selec_meanSubj.mat','varia_conn_bench_selec_meanSubj');

%% Todo2 - se der tempo, verificar os canais do Benchmarck

%%

if length(ch_selec_pos_rt_artificial) == 0
        v_ch_selec_label_rt_pos{i} = ['none'];
        v_ch_selec_rt_pos{i} = ['none'];
else
    for i = 1:length(ch_selec_pos_rt_artificial)
    v_ch_selec_label_rt_pos{i} = [ch_label{ch_selec_pos_rt_artificial(i)},'-',freqbdw_label{freq_selec_pos_rt_artificial(i)}];
    v_ch_selec_rt_pos{i} = [ch_selec_pos_rt_artificial(i) freq_selec_pos_rt_artificial(i)];
    end
end

% Obtendo variacao da conectividade para todos os pares dos canais
% selecionados 
varia_conn_rt_pos = zeros(length(v_ch_selec_label_rt_pos),19);

for i = 1:length(v_ch_selec_label_rt_pos) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
    for j = 1:19 %Para todas as combinacoes de canal
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_rt_pos(i,j) = MeanC_3f{1,v_ch_selec_rt_pos{i}(2)}(v_ch_selec_rt_pos{i}(1),j) / MeanC_3i{1,v_ch_selec_rt_pos{i}(2)}(v_ch_selec_rt_pos{i}(1),j);
    end
end