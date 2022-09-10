% Script para artigo de detecao de biomarcadores de fadiga mental  pela
% corr do PSD e 3 metricas de connectividade (coh, plv e dwpli)

% Este script parte do pressuposto que as matrizes de connectividade e os
% valores de PSD ja foram anteriormente gerados 

%% Etapa 1 - Plot do PSD dos sujeitos analisados 

%Adding functions folder to path 
addpath('./utils');
%Como se quer plotar os valores para ambos os hemisferios, e para cada um
%dos hemisferios, o psd deve ser calculado novamente 

%% Para Plotar todas as regioes em ambos os hemisferios 

% [ Posteriormente removido, as regioes sao calculadas com  o emprego do
% pow_value, fazendo referencia ao canais

path_regions = './Matrizes/psd/regions/';

% %Usando funcao
% psd_regions = getNamesFromFolder(path_regions,'_t_t');
%% Loading specific path 

% path_psd = ('./S11D/PSD_S11D/RT/');
% path_psd = ('./S11D/PSD_S11D/RT_posBench/');
% path_psd = ('./S11D/PSD_S11D/Benchmark/');

% path_conn = ('./Matrizes/Conn_ChinperMinof5min/');%Chinesa
% path_conn = ('./S11D/Connectivity_S11D/RT_OA_raw/'); %S11D
% path_conn = ('./S11D/Connectivity_S11D/PosBench_raw/'); %S11D
% path_conn = ('./S11D/Connectivity_S11D/Benchmarck/'); %S11D

%Usando funcao
var_subjects_psd = getNamesFromFolder(path_psd,'*');
var_subjects_conn = getNamesFromFolder(path_conn,'*');

%% Organizing psd values 
%in psd_matrix{12,2,7}{30,5}

%To organize psd data in frequencies per subjects per mental state
organize_psd(var_subjects_psd,path_psd);

%% Organizing Conn values 
%in conn_matrix{12,2,7}{30,5}
[mental_states] = organize_conn(var_subjects_conn,path_conn);

%% Frequencias %%%%rodar aqui para gerar correlacao sem gerar matriz e psd!!
%Seguindo a mesma ordem que no PSD 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%S11D
mental_states = {'NoLabeledStates'};

% ------------------------------------------------------------------------------------------------------------------
% Loading regions vector 
%Chanding path here is important to calculate ocurrencies for each type of
%files (RT,RTPos or Bench)

v_ch = load_regions(path_psd);

% ------------------------------------------------------------------------------------------------------------------
% Calculando ocorrencia de correlacao entre o psd e a conn e connectividade
%Empregando psd_matrix e conn_matrix

if contains(path_conn,'S11D')
    load('./Matrizes/ch_label_19.mat');
else
    load('./Matrizes/ch_label.mat');%Chinesa
end

%type of correlation 
type_corr = 'Pearson';
% type_corr = 'Spearman';

[tabela_ocorr_pos, tabela_ocorr_neg,...
    tabela_ocorr_soma_pos,tabela_ocorr_soma_neg,...
    tabela_ocorr_semsoma_pos,tabela_ocorr_semsoma_neg,v_ch_mat] = calculando_ocorrencia(path_conn,path_psd,type_corr,v_ch,mental_states);



% -----------------------------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------------------------
%% Taking the mean of subjects from conn_matrix
%When all files of ocurrencies and conn were calculated by
%calculando_ocorrencia, execute folowing lines ...

%Aqui o processamento anterior de ocorrencias deve ser separado 
if contains(path_conn,'RT') || contains(path_conn,'Pos')
    
    %RT
    load([path_conn(1:25),'RT_OA_raw/conn_matrix.mat']);
    for i = 1:length(mental_states) %estados mentais
        for j = 1:7 %bandas de frequencias
            % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
            MeanC_3i{i,j} = mean(cat(3, conn_matrix{:,i,j}),3); %Mean of all subjects in all  minutes
            MeanC_cat_3i{i,j} = cat(3, conn_matrix{:,i,j}); 

            %Taking max and min values
            minmaxValue_MeanC{i,j} = [min(min(min(MeanC_3i{i,j}))) max(max(MeanC_3i{i,j}))]; %Max &min of the mean 
            minmaxValue_MeanCAll{i,j} = [min(min(min(MeanC_cat_3i{i,j}))) max(max(max(MeanC_cat_3i{i,j})))]; %Max &min of all values

        end
    end

    save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/MeanC_3i.mat'],'MeanC_3i');

    %RT_pos = PosBench
    load([path_conn(1:25),'PosBench_raw/conn_matrix.mat']);
    for i = 1:length(mental_states) %estados mentais
        for j = 1:7 %bandas de frequencias
            % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
            MeanC_3f{i,j} = mean(cat(3, conn_matrix{:,i,j}),3); %Mean of all subjects in all  minutes
            MeanC_cat_3f{i,j} = cat(3, conn_matrix{:,i,j}); 

            %Taking max and min values
            minmaxValue_MeanC{i,j} = [min(min(min(MeanC_3f{i,j}))) max(max(MeanC_3f{i,j}))]; %Max &min of the mean 
            minmaxValue_MeanCAll{i,j} = [min(min(min(MeanC_cat_3f{i,j}))) max(max(max(MeanC_cat_3f{i,j})))]; %Max &min of all values

        end
    end

    save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/MeanC_3f.mat'],'MeanC_3f');
else

    % -----------------------------------------------------------------------------------------------------------------
    % -----------------------------------------------------------------------------------------------------------------
    % -----------------------------------------------------------------------------------------------------------------
    % -----------------------------------------------------------------------------------------------------------------
    %Benchmarck 
    load([path_conn(1:25),'Benchmarck/conn_matrix_freq_permin.mat']);
    
    %Em conn_matrix do benchmarck, temos os 6 intervalos de tempo
    %correspondentes aos 3 min iniciais e aos 3 min finais, na media das
    %frequencias indentificadas pela terceira dimensao de matrix_conn
    
%     %Separing 3i and 3f 
    conn_matrix_3i = cellfun(@(x) x(:,:,1:3),conn_matrix,'un',false);
    conn_matrix_3f = cellfun(@(x) x(:,:,4:6),conn_matrix,'un',false);
    
    save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_3i.mat','conn_matrix_3i');
    save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_3f.mat','conn_matrix_3f');
    
    for i = 1:length(mental_states) %estados mentais
        for j = 1:7 %bandas de frequencias
            % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
                       
            MeanC_3i{i,j} = mean(cat(3, conn_matrix_3i{:,i,j}),3); %Mean of all subjects in all  minutes
            MeanC_cat_3i{i,j} = cat(3, conn_matrix_3i{:,i,j}); 
            
            MeanC_3f{i,j} = mean(cat(3, conn_matrix_3f{:,i,j}),3); %Mean of all subjects in all  minutes
            MeanC_cat_3f{i,j} = cat(3, conn_matrix_3f{:,i,j}); 

            %Taking max and min values
            minmaxValue_MeanC_3i{i,j} = [min(min(min(MeanC_3i{i,j}))) max(max(MeanC_3i{i,j}))]; %Max &min of the mean 
            minmaxValue_MeanCAll_3i{i,j} = [min(min(min(MeanC_cat_3i{i,j}))) max(max(max(MeanC_cat_3i{i,j})))]; %Max &min of all values
            
            minmaxValue_MeanC_3f{i,j} = [min(min(min(MeanC_3f{i,j}))) max(max(MeanC_3f{i,j}))]; %Max &min of the mean 
            minmaxValue_MeanCAll_3f{i,j} = [min(min(min(MeanC_cat_3f{i,j}))) max(max(max(MeanC_cat_3f{i,j})))]; %Max &min of all values

        end
    end

    save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/MeanC_3i.mat'],'MeanC_3i');
    save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/MeanC_3f.mat'],'MeanC_3f');
    
    save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/conn_matrix_3i.mat'],'conn_matrix_3i');
    save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/conn_matrix_3f.mat'],'conn_matrix_3f');
    
end

% %Vetor de estados 
% v_estados = {'Fatigue','Normal'};


%% Criando combinacao de pares de canais 

% Necessario vetorizar o tril da matriz de connectividade de duas matrizes
% na mesma frequencia em estados diferentes 
% As matrizes de connectividade serao 
%     * da media dos 5 minutos,para todos os sujeitos -> usar MeanC_cat
%     * de min a min dos 5 minutos,para todos os sujeitos -> usar media dos
%     subj de MeanC_cat_perMin_perSubj


%Getting index of conn matrix tril excluindo redundancia
tril_mask_ones = tril(ones(length(ch_label),length(ch_label)),-1);
[index_tril_i,index_tril_j ] = ind2sub([length(ch_label),length(ch_label)],find(tril_mask_ones)); %Turning linear index to subscripts
%Criando vetor de combinacao de pares 
%Combinacao 30 2 a 2 = 435 pares
for i = 1:factorial(19)/(factorial(2)*factorial(19-2)) %Combination
    ch_label_pairs{i,1} = [ch_label{index_tril_j(i)},'-',ch_label{index_tril_i(i)}];
end
%Saving vector of pairs combinations 
save('./Matrizes/Ocorrencia/ch_label_pairs.mat','ch_label_pairs');

%% Wilcoxon 

%S11D -  3min from begining (3i) and min from ending (3f) will be compared
%to get the statistical significance between suposed mental states 
% MeanC_3i and MeanC_3f 
% MeanC_3i = MeanC saved in RT 
% MeanC_3f = MeanC saved in RT_pos

for i = 1:7 %Para cada frequencia
    for j = 1:length(v_ch_mat) %Para todos os pares de um determinado canal
%            p_teste{i,j} = ranksum(MeanC{1,i}(j,:),MeanC{2,i}(j,:),'tail','right'); % Fadigado - Normal
          % hipotese: conn Norm > conn Fad 
          % Os valores em h2, se 1 , representam qdo a hipotese foi
          % alcancada
           [ p_val_fn{i,j},hip_fn{i,j}] = ranksum(MeanC_3i{1,i}(j,:),MeanC_3f{1,i}(j,:),'tail','left'); % Fadigado - Normal
           [ p_val_nf{i,j},hip_nf{i,j}] = ranksum(MeanC_3f{1,i}(j,:),MeanC_3i{1,i}(j,:),'tail','left'); % Fadigado - Normal
    end
end

%Labeling mask of h2
labeled_hip_nf = cell(7,length(p_val_nf));
labeled_hip_fn = cell(7,length(p_val_fn));
for i = 1:7
    for j = 1:length(p_val_nf)
        if hip_nf{i,j} == 1
            labeled_hip_nf{i,j} = ch_label{j};
        end
        if hip_fn{i,j} == 1
            labeled_hip_fn{i,j} = ch_label{j};
        end
    end
end

%Salvando valores de pval e hip para corr positiva 
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/p_val_fn.mat'],'p_val_fn');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/hip_fn.mat'],'hip_fn');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/labeled_hip_fn.mat'],'labeled_hip_fn');
     
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/p_val_nf.mat'],'p_val_nf');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/hip_nf.mat'],'hip_nf');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/labeled_hip_nf.mat'],'labeled_hip_nf');
%% Verifying pairs correlated with PSD and with significance 

%Getting the matrix 
% a_semsoma_pos_pos_rt >> a_semsoma_pos_rt of pos_rt still manually stantiated 
% a_semsoma_pos_rt >> a_semsoma_rt of rt still manually stantiated


%s11d
%tabela de merge de ocorrencias nos dois periodos analisados rt e rt_pos
merged_corr_rtposrt_pos = and(tabela_ocorr_semsoma_pos{1},tabela_ocorr_semsoma_pos{2});
merged_corr_logical_s11d_pos = logical(merged_corr_rtposrt_pos);

merged_corr_rtposrt_neg = and(tabela_ocorr_semsoma_neg{1},tabela_ocorr_semsoma_neg{2});
merged_corr_logical_s11d_neg = logical(merged_corr_rtposrt_neg);

save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/merged_corr_rtposrt_pos.mat'],'merged_corr_rtposrt_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/merged_corr_rtposrt_neg.mat'],'merged_corr_rtposrt_neg');

%Turning hip cell to mat
%Tabels 3 de TabelaOcorrencia_s11d
hip_mat_nf = cell2mat(hip_nf)';
hip_mat_fn  = cell2mat(hip_fn)';

save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/hip_mat_fn.mat'],'hip_mat_fn');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/hip_mat_nf.mat'],'hip_mat_nf');

% Verifying channel with hip 
%s11d - quarta tabela do and , com ch com corr em ambos os periodos e
%diff estatistica
verif_corr_ocurr_s11d_nf_pos = and(hip_mat_nf,merged_corr_logical_s11d_pos); %30 x 7
verif_corr_ocurr_s11d_nf_neg = and(hip_mat_nf,merged_corr_logical_s11d_neg); %30 x 7

verif_corr_ocurr_s11d_fn_pos = and(hip_mat_fn,merged_corr_logical_s11d_pos); %30 x 7
verif_corr_ocurr_s11d_fn_neg = and(hip_mat_fn,merged_corr_logical_s11d_neg); %30 x 7

save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/verif_corr_ocurr_s11d_nf_pos.mat'],'verif_corr_ocurr_s11d_nf_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/verif_corr_ocurr_s11d_nf_neg.mat'],'verif_corr_ocurr_s11d_nf_neg');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/verif_corr_ocurr_s11d_fn_pos.mat'],'verif_corr_ocurr_s11d_fn_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/verif_corr_ocurr_s11d_fn_neg.mat'],'verif_corr_ocurr_s11d_fn_neg');
%% Analise de variacao de connectividade 

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

%% Benchmarck 

%Para  bench apenas F8-theta e P3-Alpha tiveram valores significativos e
%corr + (Pearson) com PSD
ch_selec_pos_bench_artificial = zeros(2,1);

%index segundo ch_label
ch_selec_pos_bench_artificial(1) = 16;%F8
ch_selec_pos_bench_artificial(2) = 1;%P3

freq_selec_pos_bench_artificial = zeros(2,1);

freq_selec_pos_bench_artificial(1) = 3;%theta
freq_selec_pos_bench_artificial(2) = 4;%alpha1

%Turning to cell (index) and cell of strings (labels)
v_ch_selec_label_bench_pos = cell(1,length(ch_selec_pos_bench_artificial));

if length(ch_selec_pos_bench_artificial) == 0
        v_ch_selec_label_bench_pos{i} = ['none'];
        v_ch_selec_bench_pos{i} = ['none'];
else
    for i = 1:length(ch_selec_pos_bench_artificial)
    v_ch_selec_label_bench_pos{i} = [ch_label{ch_selec_pos_bench_artificial(i)},'-',freqbdw_label{freq_selec_pos_bench_artificial(i)}];
    v_ch_selec_bench_pos{i} = [ch_selec_pos_bench_artificial(i) freq_selec_pos_bench_artificial(i)];
    end
end

% Obtendo variacao da conectividade para todos os pares dos canais
% selecionados 
varia_conn_bench_pos = zeros(length(v_ch_selec_label_bench_pos),19);

for i = 1:length(v_ch_selec_label_bench_pos) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
    for j = 1:19 %Para todas as combinacoes de canal
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_bench_pos(i,j) = MeanC_3f{1,v_ch_selec_bench_pos{i}(2)}(v_ch_selec_bench_pos{i}(1),j) / MeanC_3i{1,v_ch_selec_bench_pos{i}(2)}(v_ch_selec_bench_pos{i}(1),j);
    end
end

save

%% ---------------------------------------------------------------

%Implementada para os canais selecionados na etapa anterior 
% A partir de MeanC

%Get index of ch and freq from table verif_corr_and

[ch_selec_fn_pos,freq_selec_fn_pos] = find(verif_corr_ocurr_s11d_fn_pos ==1);
[ch_selec_nf_pos,freq_selec_nf_pos] = find(verif_corr_ocurr_s11d_nf_pos ==1);

[ch_selec_fn_neg,freq_selec_fn_neg] = find(verif_corr_ocurr_s11d_fn_neg ==1);
[ch_selec_nf_neg,freq_selec_nf_neg] = find(verif_corr_ocurr_s11d_nf_neg ==1);

%Turning to cell (index) and cell of strings (labels)
v_ch_selec_label_fn_pos = cell(1,length(ch_selec_fn_pos));
v_ch_selec_label_nf_pos = cell(1,length(ch_selec_nf_pos));

v_ch_selec_label_fn_neg = cell(1,length(ch_selec_fn_neg));
v_ch_selec_label_nf_neg = cell(1,length(ch_selec_nf_neg));

if length(ch_selec_fn_pos) == 0
        v_ch_selec_label_fn_pos{i} = ['none'];
        v_ch_selec_fn_pos{i} = ['none'];
else
    for i = 1:length(ch_selec_fn_pos)
    v_ch_selec_label_fn_pos{i} = [ch_label{ch_selec_fn_pos(i)},'-',freqbdw_label{freq_selec_fn_pos(i)}];
    v_ch_selec_fn_pos{i} = [ch_selec_fn_pos(i) freq_selec_fn_pos(i)];
    end
end

if length(ch_selec_fn_neg) == 0
        v_ch_selec_label_fn_neg{i} = ['none'];
        v_ch_selec_fn_neg{i} = ['none'];
else
    for i = 1:length(ch_selec_fn_neg)
    v_ch_selec_label_fn_neg{i} = [ch_label{ch_selec_fn_neg(i)},'-',freqbdw_label{freq_selec_fn_neg(i)}];
    v_ch_selec_fn_neg{i} = [ch_selec_fn_neg(i) freq_selec_fn_neg(i)];
    end
end

if length(ch_selec_nf_pos) == 0
    v_ch_selec_label_nf_pos{i} = ['none'];
    v_ch_selec_nf_pos{i} = ['none'];
else
    for i = 1:length(ch_selec_nf_pos)
      v_ch_selec_label_nf_pos{i} = [ch_label{ch_selec_nf_pos(i)},'-',freqbdw_label{freq_selec_nf_pos(i)}];
      v_ch_selec_nf_pos{i} = [ch_selec_nf_pos(i) freq_selec_nf_pos(i)];   
    end
end

if length(ch_selec_nf_neg) == 0
        v_ch_selec_label_nf_neg{i} = ['none'];
        v_ch_selec_nf_neg{i} = ['none'];
else
    for i = 1:length(ch_selec_nf_neg)
    v_ch_selec_label_nf_neg{i} = [ch_label{ch_selec_nf_neg(i)},'-',freqbdw_label{freq_selec_nf_neg(i)}];
    v_ch_selec_nf_neg{i} = [ch_selec_nf_neg(i) freq_selec_nf_neg(i)];
    end
end

 
varia_conn_nf_pos = zeros(length(v_ch_selec_label_nf_pos),19);
varia_conn_fn_pos = zeros(length(v_ch_selec_label_fn_pos),19);

varia_conn_nf_neg = zeros(length(v_ch_selec_label_nf_neg),19);
varia_conn_fn_neg = zeros(length(v_ch_selec_label_fn_neg),19);

for i = 1:length(v_ch_selec_label_fn_pos) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
    for j = 1:19 %Para todas as combinacoes de canal
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_fn_pos(i,j) = MeanC_3f{1,v_ch_selec_fn_pos{i}(2)}(v_ch_selec_fn_pos{i}(1),j) / MeanC_3i{1,v_ch_selec_fn_pos{i}(2)}(v_ch_selec_fn_pos{i}(1),j);
    end
end

for i = 1:length(v_ch_selec_label_fn_neg) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
    for j = 1:19 %Para todas as combinacoes de canal
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_fn_neg(i,j) = MeanC_3f{1,v_ch_selec_fn_neg{i}(2)}(v_ch_selec_fn_neg{i}(1),j) / MeanC_3i{1,v_ch_selec_fn_neg{i}(2)}(v_ch_selec_fn_neg{i}(1),j);
    end
end

for i = 1:length(v_ch_selec_label_nf_pos) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
    for j = 1:19 %Para todas as combinacoes de canal
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_nf_pos(i,j) = MeanC_3i{1,v_ch_selec_nf_pos{i}(2)}(v_ch_selec_nf_pos{i}(1),j) / MeanC_3f{1,v_ch_selec_nf_pos{i}(2)}(v_ch_selec_nf_pos{i}(1),j);
    end
end

for i = 1:length(v_ch_selec_label_nf_neg) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
    for j = 1:19 %Para todas as combinacoes de canal
%           varia_conn(w) = a_nor(w)/a_fat(w);
%           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn_nf_neg(i,j) = MeanC_3i{1,v_ch_selec_nf_neg{i}(2)}(v_ch_selec_nf_neg{i}(1),j) / MeanC_3f{1,v_ch_selec_nf_neg{i}(2)}(v_ch_selec_nf_neg{i}(1),j);
    end
end

%Removendo valores menores que 1
varia_conn_nf_pos(varia_conn_nf_pos<1) = 0;
varia_conn_fn_pos(varia_conn_fn_pos<1) = 0;

varia_conn_nf_neg(varia_conn_nf_neg<1) = 0;
varia_conn_fn_neg(varia_conn_fn_neg<1) = 0;
%Removendo NaN
varia_conn_nf_pos(isnan(varia_conn_nf_pos))=0;
varia_conn_fn_pos(isnan(varia_conn_fn_pos))=0;

varia_conn_nf_neg(isnan(varia_conn_nf_neg))=0;
varia_conn_fn_neg(isnan(varia_conn_fn_neg))=0;
%Transpondo para ch no eixo y 
varia_conn_nf_pos = varia_conn_nf_pos';
varia_conn_fn_pos = varia_conn_fn_pos';

varia_conn_nf_neg = varia_conn_nf_neg';
varia_conn_fn_neg = varia_conn_fn_neg';

%Matrizes de variacao em relacao ao estado normal 
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/varia_conn_nf_pos.mat'],'varia_conn_nf_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/varia_conn_nf_neg.mat'],'varia_conn_nf_neg');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/varia_conn_fn_pos.mat'],'varia_conn_fn_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/varia_conn_fn_neg.mat'],'varia_conn_fn_neg');

save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_fn_pos.mat'],'v_ch_selec_fn_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_fn_neg.mat'],'v_ch_selec_fn_neg');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_nf_pos.mat'],'v_ch_selec_nf_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_nf_neg.mat'],'v_ch_selec_nf_neg');

save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_label_fn_pos.mat'],'v_ch_selec_label_fn_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_label_fn_neg.mat'],'v_ch_selec_label_fn_neg');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_label_nf_pos.mat'],'v_ch_selec_label_nf_pos');
save(['./S11D/Ocorrencia/',type_corr,'/',path_conn(26:end-1),'/v_ch_selec_label_nf_neg.mat'],'v_ch_selec_label_nf_neg');
% clear varia_conn

%% Multiplots com fieldtrip 

% path_fieldtrip = fullfile('..','..','..','Fieldtrip');
% addpath(path_fieldtrip);
% % addpath('C:\Users\b0024\Documents\Fieldtrip');
% 
% % Preamble
% ft_defaults

%% Multiplotting

% %Saving struct to fill with differents matrixconn
% conn_struct = conn_data_cell{1,1};
% orig_conn_struct.freq = conn_struct.freq;
% % conn_struct.freq = freqbdw{i};
% % conn_struct.wpli_debiasedspctrm = conn_matrix_freq_meansubj{i,k};
% 
% for i = 1:length(freqbdw)
%     for j = 1:2 %mental states
%         
%         %Setting values
%         [token,remain] = strtok(freqbdw{i},':');
%         conn_struct.freq = orig_conn_struct.freq(str2num(token)+2:str2num(remain(2:end))+2);
%         conn_struct.wpli_debiasedspctrm = conn_matrix_freq_meansubj{i,j};
%         
%         cfg = [];
%         cfg.layout = fullfile('Z:','MylenaReis','Fieldtrip','template','layout','EEG1020.lay'); %Win alien
%         cfg.parameter = 'wpli_debiasedspctrm';
%         % cfg.xlim= [19 30];
%         cfg.ylim= 'minmax';
% %         cfg.channel = {'CP3' 'P3' 'T4' 'TP7' 'P3' 'FC3' 'P4' 'T3' 'F3' 'CP4' 'C4' 'PZ' 'T6'};
%         cfg.channel = {'CP3' 'FC3' 'F3' 'P4' 'T3' 'CP4' 'C4' 'PZ' 'T6' 'P3' 'T4' 'TP7' 'P3'};
%         % ft_multiplotCC(cfg,conn_data_cell{1,1});
%         ft_connectivityplot(cfg,a,conn_struct); %a -> normal (azul)
%     end
% end

% %% Plotting just the channels selected  - Coefficient of variation
% % v_freq_label = {'beta','beta1','beta2'};
% % v_freq = [2,6,7]; %index of frequencies beta, beta1 e beta2 em conn_m,atrix_freq_meansubj
% %find(v_freq==2)%retunr the ndex of each value
% 
% [i,j] = find(varia_conn_nf >10);%i >>indice de ch em ch_label e j, indice em v_ch_selec
% 
% if isempty(i) || isempty(j)
%     disp('Nenhum valor maior que 10. Vazio');
% else
%     for k = 1:length(j)
%     %     v_freq_label{i} = [ch_label{ch_selec(i)}];
%     %     v_freq{i} = [ch_selec(i) freq_selec(i)];
%         v_comb_selec_ch{k} = [v_ch_selec{j(k)}(2) v_ch_selec{j(k)}(1) i(k) ];
%         v_comb_selec_ch_label{k} = [ ch_label{i(k)},'-',v_ch_selec_label_fn_pos{j(k)} ];
%     end
% end
% 
% save('./Matrizes/v_comb_selec_ch.mat','v_comb_selec_ch');

% v_comb_selec_ch = {[2 18 26],[2 19 26],[2 19 16],[6 24 26],[7 19 9],[7 19 4],[7 19 25],[7 17 13],[7 18 21],[7 18 27],[7 24 26],[7 24 4]};

% %% Calculating CV
% %from alpha to beta2
% 
% %from v_comb_selec_label get the frequencies
% for i = 1:length(v_comb_selec_ch)
%     v_freq(i) = v_comb_selec_ch{i}(1); 
% end
% v_freq_unique = unique(v_freq);%selecionando os indices das frequencias sem repeticao 
% 
% save('./Matrizes/v_freq.mat','v_freq');
% save('./Matrizes/v_freq_unique.mat','v_freq_unique');
% 
% for i = 1:length(v_comb_selec_ch)
% 
% %     v_comb_selec_ch = {[2 18 26],[2 19 26],[2 19 16],[6 24 26],[7 19 9],[7 19 4],[7 19 25],[7 17 13],[7 18 21],[7 18 27],[7 24 26],[7 24 4]};
% %     v_freq = [1, 6, 7]; %from alpha to beta2
% 
%     %plot fadigado
% %      conn_val_fat = [];
% %      conn_val_norm = [];
%     for j = 1:length(v_freq_unique) %concatenado valores de alpha,beta1 e beta2
% %         conn_val_fat = [conn_val_fat; permute(conn_matrix_freq_meansubj{v_freq(j),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1])];
%           conn_val_fat{i,j} = permute(conn_matrix_freq_meansubj{v_freq_unique(j),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1]);
%           conn_val_norm{i,j} = permute(conn_matrix_freq_meansubj{v_freq_unique(j),2}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1]);
%             %Coefficient of Variation 
%           CV_fat(i,j) = getCV(conn_val_fat{i,j});
%           CV_norm(i,j) = getCV(conn_val_norm{i,j});
%     end
% end
% 
% % clear conn_val_fat
% % clear conn_val_norm
% save('./Matrizes/conn_val_fat.mat','conn_val_fat');
% save('./Matrizes/conn_val_nor.mat','conn_val_norm');

%% Plotting all values of CV in scatter plot
%     h = figure('position', [100 100 1000 700]);
%     
%     x = 1:length(v_freq_unique);%3 frequency bands
%     
%     hold on;
% 
%     p1 = plot(x,CV_fat','r*');
%     p2 = plot(x,CV_norm','bo');
%     
%     
%     %xlim
%     xlim([0 length(x)+1]);
%         
%     %Ticks
%     xticks([x]);
%     %Ticklabels
% %     xticklabels({'Alpha','Beta1','Beta2'})
%     xticklabels(freqbdw_label(v_freq_unique))
%         
% %     %title
%     title({['Coeficiente de Variação para os ',num2str(length(ch_selec)),'pares selecionados  Corr +']},'Interpreter','none');
%     xlabel('Frequencias')
%     ylabel('Coefficient of Variation')
% %     %legenda customizada 
%     h2 = zeros(2, 1);
%     h2(1) = plot(NaN,NaN,'r*');
%     h2(2) = plot(NaN,NaN,'bo');
% 
%     legend(h2, 'Fadiga','Normal');   
% 
% %     %Saving figures
% %     %             saveas(h,sprintf(strcat(pathcon_img,'/','MeanTeta.png'))); % will create FIG1, FIG2,...
%     saveas(h,'.\Images\Ocorrencia\Pearson\Corr_positiva\CV_Ch_selecionados','fig');
%     saveas(h,'.\Images\Ocorrencia\Pearson\Corr_positiva\CV_Ch_selecionados','png');
%     close all;
    
%% Plotting all values of CV in scatter plot - v2

% v_corr_metrics = {['Corr_Pearson\Corr_positiva\'],['Corr_Pearson\Corr_negativa\'],['Corr_spearman\Corr_negativa\']};
% 
% for j = 1:length(v_corr_metrics)
%     
% %Cleaning var 
% clear v_freq
% clear v_freq_unique
% clear CV_fat
% clear CV_norm
% clear v_comb_selec_ch_label
%     
% %loads
% load(['.\Matrizes\Ocorrencia\',v_corr_metrics{j},'v_freq.mat']);
% load(['.\Matrizes\Ocorrencia\',v_corr_metrics{j},'v_freq_unique.mat']);
% load(['.\Matrizes\Ocorrencia\',v_corr_metrics{j},'CV_fat.mat']);
% load(['.\Matrizes\Ocorrencia\',v_corr_metrics{j},'CV_norm.mat']);
% load(['.\Matrizes\Ocorrencia\',v_corr_metrics{j},'v_comb_selec_ch_label.mat']);
% 
% %Getting names of path for each tyoe of corr
% [token,remain] =  strtok(v_corr_metrics{j},'\');
% 
% % find(v_freq(1) == v_freq_unique) %return  the column number of frequencies in CV_**

% h = figure('position', [100 100 900 600]);
%         
%     for i = 1:length(v_freq)
%         plot(i,CV_fat(i,find(v_freq(i) == v_freq_unique)),'ro');
%         hold on; 
%         plot(i,CV_norm(i,find(v_freq(i) == v_freq_unique)),'b*');
%         
% %         imagesc(conn_val_fat{i,find(v_freq(i) == v_freq_unique));
% 
%         %Axis adjustment
%         xlim([.5 length(v_freq)+.5]);
% 
%         %Ticks
%         xticks(x);
%         %Ticklabels
%         xticklabels(v_comb_selec_ch_label)
%         xtickangle(45)
% 
%         %     %title
%         title({['Coeficiente de Variação para os ',num2str(length(CV_norm)),' pares selecionados'],[token(6:end),' ',remain(2:end-1)]},'Interpreter','none');
%         xlabel('Pares selecionados')
%         ylabel('Coeficiente de Variação (%)')
% 
%         % legenda
%         legend('Estado Fadigado','Estado Normal');
%     %     legend('Estado Fadigado','Estado Normal','Location','eastoutside');
%     %     legend(freqbdw_label{v_freq_unique(1)},freqbdw_label{v_freq_unique(2)},freqbdw_label{v_freq_unique(3)},'Location','northeastoutside','Orientation','vertical');
% 
%     end
%          %Saving figures
%         
%         saveas(h,['.\Images\Ocorrencia\',token(6:end),'_',remain(2:end-1),'CV_Ch_selecionados'],'fig');
%         saveas(h,['.\Images\Ocorrencia\',token(6:end),'_',remain(2:end-1),'CV_Ch_selecionados'],'png');
%         close all;
% 
% end

%% Plot connectividade dos pares 

% for i = 1:length(v_freq)
%     conn{i} = [mean(conn_val_fat{i,find(v_freq(i) == v_freq_unique)});mean(conn_val_norm{i,find(v_freq(i) == v_freq_unique)})];
% end
% 
% conn = cell2mat(conn);
% 
% %imagesc
% % x = 1:length(v_freq);
% % imagesc(conn);
% % xticks(x);
% % %Ticklabels
% % xticklabels(v_comb_selec_ch_label)
% % xtickangle(45)
% 
% %heatmap
% x = 1:length(v_freq);
% heatmap(conn);
% % xticks(x);
% %Ticklabels
% % xticklabels(v_comb_selec_ch_label)
% % xtickangle(45)
% ax = gca;
% ax.XData = [v_comb_selec_ch_label];
% ax.YData = ["Fatigue" "Normal"];
% ax.Position = [0.1300 0.1100 0.7750 0.9150];

%% Plot dos pares selecionados 
% for i = 1:length(v_comb_selec_ch)
% 
%     h = figure('position', [100 100 1000 700]);
%     
%     %eixo x
% %     x = [1:size(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1),1},3)];
%     x = [1:size(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1)},3)];
%     
%     %plot fadigado
%     conn_val_fat = permute(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1]);
%     plot(x,conn_val_fat,'r--*');%fadigado
%     hold on;
%     %plot mean Fadigado
%     % repetir um valor n vezes >>> repelem(a,n,1);
%     mean_fat = mean(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:));
%     std_fat = std(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:));
%     %plot mean fadigado
%     plot(x,repelem(mean_fat,length(x),1),'r');
%     %Coefficient of Variation 
%     CV_fat = getCV(conn_val_fat);
%     
%     %plot Normal
%     conn_val_norm = permute(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1),2}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1]);
%     plot(x,conn_val_norm,'b--o');%fadigado
%     %plot mean Normal
%     mean_norm = repelem(mean(conn_matrix_freq_meansubj{v_comb_selec_ch{i}(1),2}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:)),length(x),1);
%     plot(x,mean_norm,'b');%normal
%     hold off;
%     %Coefficient of Variation 
%     CV_norm = getCV(conn_val_norm);
%         
%     %xlim
%     xlim([1 length(x)]);
%     %Ticks
%     xticks([x]);
%     
%     %Ticklabels
%     xticklabels({str2num(freqbdw{v_comb_selec_ch{i}(1)})})
%     %     freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};
%         
%     %title
%     title({['Canal ',ch_label{v_comb_selec_ch{i}(2)},'-',ch_label{v_comb_selec_ch{i}(3)},' ',v_freq_label{find(v_freq_unique==v_comb_selec_ch{i}(1))}],['  mediaN:',num2str(round(mean_norm(1),4)),'  CV_fat:',num2str(CV_fat),'  CV_norm:',num2str(CV_norm)]},'Interpreter','none');
%     xlabel('Frequencia (Hz)')
%     ylabel('dwpli')
%     %legenda
%     legend('Fadiga','Média Fadiga','Normal','Média Normal','Location', 'southoutside','Orientation','horizontal')
%     %Saving figures
%     %             saveas(h,sprintf(strcat(pathcon_img,'/','MeanTeta.png'))); % will create FIG1, FIG2,...
%     saveas(h,['./Images/Ocorrencia/Ch_selecionados_',ch_label{v_comb_selec_ch{i}(2)},'_',ch_label{v_comb_selec_ch{i}(3)},'_',v_freq_label{find(v_freq_unique==v_comb_selec_ch{i}(1))}],'fig');
%     saveas(h,['./Images/Ocorrencia/Ch_selecionados_',ch_label{v_comb_selec_ch{i}(2)},'_',ch_label{v_comb_selec_ch{i}(3)},'_',v_freq_label{find(v_freq_unique==v_comb_selec_ch{i}(1))}],'png');
%     close all;
%     
% end

%% Organizando matriz de connectividade para testar validacao dos pares selcionados 

% %conn_matrix >>> 12 x 2 x 7 {30x30x5}
% % freqbdw_label >>> {'alfa'}    {'beta'}    {'teta'}    {'alfa1'}    {'alfa2'}    {'beta1'}    {'beta2'}
% 
% 
% % 1. select only the frequencies of v_freq_unique 
% 
% %load v_freq_unique to get the index of selected frequencies of the
% %correlation
% % size(conn_matrix_freq_permin) 12     2     7     5
% for i = 1:length(v_freq_unique)
%     conn_selec(:,:,i,:) = conn_matrix_freq_permin(:,:,v_freq_unique(i),:); %12 x 2 x 3 x 5{30x 30 x specific freq}
% end
% % c = reshape(permute(conn_selec,[1,4,3,2]),[12,15,2]);%12 x 15 x 2 
% 
% 
% % 2. select only the pairs of each frequencies 
% % find(v_freq_unique(1) == v_freq)%return the index of element from
% % v_freq_unique in v_freq >>> 2 5 6 which correspond to the position of
% % the selected pairs in v_comb_selec_ch
% 
% for i = 1:length(v_freq_unique)
% %     c{1,i} = v_comb_selec_ch_label(find(v_freq_unique(i) == v_freq)); %labels of selected pairs devided by freq
% %     c{2,i} = v_comb_selec_ch(find(v_freq_unique(i) == v_freq)); %index of selected pairs devided by freq
%       idx_selected_ch_per_bd{i} = v_comb_selec_ch(find(v_freq_unique(i) == v_freq)); %index of selected pairs devided by freq
% end
%% Vetor de atributos eh organizado, para cada estado, para cada banda
%selecionada (3, beta, beta1 e beta2), e cada sujeito (12) em que cada par
%em cada frequencia de cada banda eh concatenado para cada individuo e cada minuto 

% for e = 1:2 %estado 1 -> fad 2 -> norm 
%     for  m = 1:5 %min 
%         for  s = 1:12 %sujeitos
%             for i = 1:length(v_freq_unique)
%                 for j = 1:length(idx_selected_ch_per_bd{i}) %idx_selected_ch_per_bd{1}{2}
%                     a{i,s,m}{j} = conn_selec{s,e,i,m}(idx_selected_ch_per_bd{i}{j}(2),idx_selected_ch_per_bd{i}{j}(3),:)                    
%                     a2{i,s,m} = permute(cell2mat(a{i,s,m}),[3,2,1]);%turning cells of pairs to double   
% %                     rho_data_selected{i,s,m}(j) = rho_data{m,idx_selected_ch_per_bd{i},e,s}
%                 end
%                 vetor_atributos{s,i,e} = cell2mat(cellfun(@(x) reshape(x,1,[]),reshape(a2(i,s,:),1,[]),'un',0));
% %                 vetor_atributos2{s,e,i} = cell2mat(cellfun(@(x) reshape(x,1,[]),reshape(a2(i,s,:),1,[]),'un',0));
%             end
%         end
%     end
% end
%%
% 
% for i = 1:3
%     for j = 1:2
%         vetor_atributos_allsubj{j,i} = cat(1,vetor_atributos{:,i,j});
%     end
% end

% a4 = a2(1,1,:); %todos os pares do primeiro suj , na primeira banda, em
% todos os min 
%certo!
%in summary >>> ( to vectorize the 
% a6 = cell2mat(cellfun(@(x) reshape(x,1,[]),reshape(a4,1,[]),'un',0));
%% Plotting the linear regression of rho_data values

% a = permute(rho_data(:,1,1,:),[1,4,2,3]);
% %Take mean of rho through subjects
% 
% figure;
% for i = 1:12
%     plot(a{1,i},'o');
%     hold on;
% end
% 
% [rho,pval] = corr(psd_matrix{i,j,k}(:,l),conn_matrix{i,j,k}(:,:,l));%Pearson

%%

% for i = 1:length(v_comb_selec_ch)
%     for e = 1:2
%         for s = 1:12
% 
% %     v_comb_selec_ch = {[2 18 26],[2 19 26],[2 19 16],[6 24 26],[7 19 9],[7 19 4],[7 19 25],[7 17 13],[7 18 21],[7 18 27],[7 24 26],[7 24 4]};
% %     v_freq = [1, 6, 7]; %from alpha to beta2
% 
%     %plot fadigado
% %      conn_val_fat = [];
% %      conn_val_norm = [];
% %     for j = 1:length(v_freq_unique) %concatenado valores de alpha,beta1 e beta2
% %         data_selec_conn{i} = conn_matrix{:,:,v_freq_unique(j)}(v_comb_selec_ch(find(v_freq_unique(j) == v_freq));
%           data_selec_conn{e,i} = conn_matrix_freq_permin{s,e,v_freq(j)}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:);
%           data_selec_psd{e,i} = psd_matrix{s,e,v_freq(j)}(v_comb_selec_ch{i}(2));
% %     end
%         end
% %         data_selec_conn{e,i} = conn_matrix{s,e,v_freq(j)}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:);
%     end
% end 

% data_selec_conn = permute(mean(data_selec_conn,1),[2,3,1]);

 %%
% 
% a = permute(cell2mat(data_selec_conn(1,:)),[3,2,1]);
% 
% a2 = mean(a,1);%The mean of all 5 min 
% a = [a ; a2];
% 
% for i = 1:6
%     plotregression(a(i,:),data_selec_psd(1,:),'Regression');%Estado fadigado
% end
% 
% % t = cell2mat(conn_matrix(:,1,1));
% % t = reshape(t,[12,30,30,5]);
% % t = permute(mean(t,1),[2,3,4,1]);

% t2 = permute(mean(reshape(cell2mat(conn_matrix(:,1,1)),[12,30,30,5]),1),[2,3,4,1]);
% 
% for i = 1:length(v_comb_selec_ch)
%     for e = 1:2
%          data_selec_conn{e,i} = t2(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:);
%          data_selec_psd{e,i} = psd_matrix{s,e,v_freq(j)}(v_comb_selec_ch{i}(2));
%     end
% end 
% 
% for i = 1:12
%     for j = 1:5
%         plotregression(data_selec_conn{1,i}(:,:,j),data_selec_psd(1,i),'Regression');%Estado fadigado
%     end
% end