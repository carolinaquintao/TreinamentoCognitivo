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
% % regions = dir(path_regions); %Win Alien 2 
% % regions = struct2cell(regions);
% % regions = regions(1,3:end);% To take just the subjects names
% % regions = regions.';% 6 regions 
% 
% %Dir in names with a specific string 'subj'
% % psd_regions = dir([path_regions,'*_t_t*']);
% 
% %Usando funcao
% psd_regions = getNamesFromFolder(path_regions,'_t_t');
%% Para cada um dos sujeitos 

%Chinesa
path_psd = ('./Matrizes/PSD/');

%S11d
% path_psd = ('./S11D/PSD_S11D/RT/');
% path_psd = ('./S11D/PSD_S11D/RT_posBench/');
% path_psd = ('./S11D/PSD_S11D/Benchmark/');

% path_conn = ('./Chinesa/Matrizes/Conn_Chinper5min/');%Chinesa
path_conn = ('./Chinesa/Matrizes/Conn_ChinperMinof5min/');%Chinesa
% path_conn = ('./S11D/Connectivity_S11D/RT_OA_raw/'); %S11D
% path_conn = ('./S11D/Connectivity_S11D/Benchmarck/'); %S11D

%Usando funcao
% var_subjects = getNamesFromFolder(path_psd,'*');
% var_subjects = getNamesFromFolder(path_conn_subjects,'*');
var_subjects = getNamesFromFolder(path_conn,'*');
% load('./Matrizes/ch_label.mat');

%% Organizing psd values 
%in psd_matrix{12,2,7}{30,5}

%Aqui ira retornar psd_matrix que eh a media de todos os sujeitos nos
%minutos de cada estado.

%To organize psd data in frequencies per subjects per mental state
organize_psd(var_subjects,path_psd);

% Plotting 
% plot_psd(var_subjects);

%% Organizing Conn values 
%in conn_matrix{12,2,7}{30,5}
%Aqui ira retornar conn_matrix que eh a media de todos os sujeitos nos
%minutos de cada estado 
organize_conn(var_subjects,path_conn);

%% Frequencias %%%%rodar aqui para gerar correlacao sem gerar matriz e psd!!
%Seguindo a mesma ordem que no PSD 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};
% freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2','gama1','gama2','gama','delta','mu','baixasFreq'};
% freqbdw =       {'8:15','15:30','4:8','8:10','10:15','15:19','19:30','30:60','60:100','30:100','1:4','12:15','1:8'};

%% Loading regions vector 
load('./Matrizes/Ocorrencia/v_regions_index.mat');
for i = 1:length(v_regions_index)
%     load(['./Matrizes/',v_regions_index{i}]);
      load([v_regions_index{2,i},'\',v_regions_index{1,i}]);
end

% load('./Matrizes/l.mat');
if path_psd(3:6) == "S11D"
    load('./Matrizes/ch_label_19.mat');
    v_zChannels = [4,8,19];
else
    load('./Matrizes/ch_label.mat');
    v_zChannels = [5,10,15,20,25,29];
end

v_f = setdiff(v_f,v_zChannels);
v_c = setdiff(v_c,v_zChannels);
v_fp = setdiff(v_fp,v_zChannels);
v_o = setdiff(v_o,v_zChannels);
v_p = setdiff(v_p,v_zChannels);
v_t = setdiff(v_t,v_zChannels);

%Gerando indices por hemisferio 
v_f_dir = v_f(mod(v_f,2)==0);
v_f_esq = v_f(mod(v_f,2)~=0);

v_c_dir = v_c(mod(v_c,2)==0);
v_c_esq = v_c(mod(v_c,2)~=0);

v_fp_dir = v_fp(mod(v_fp,2)==0);
v_fp_esq = v_fp(mod(v_fp,2)~=0);

v_o_dir = v_o(2);
v_o_esq = v_o(1);

v_p_dir = v_p(2);
v_p_esq = v_p(1);

v_t_dir = v_t(mod(v_t,2)==0);
v_t_esq = v_t(mod(v_t,2)~=0);

%% Implementando correlacao entre o psd e a conn 
% e analisando ocorrencia de rho_up e rho_down

%Empregando psd_matrix e conn_matrix

% rho_data = cell(12,2,7);
% plv_data = cell(12,2,7);

mental_states = {'Fatigue','Normal'};

%%
for l = 1:length(conn_data_cell)  %Time interval (per min)
    for k = 1:7 %frequencies
        table = zeros(length(psd_matrix),34);%12 fad e 12 norm 
        pp = 1;
        m_max=0;

        for j = 1:length(mental_states) %mental states
            for i = 1:length(psd_matrix) %subjects
%                  [rho{i,j,k},pval{i,j,k}] = corr(psd_matrix{i,j,k}(:,l),conn_matrix{i,j,k}(:,:,l));
                   [rho,pval] = corr(psd_matrix{i,j,k}(:,l),conn_matrix{i,j,k}(:,:,l));%Pearson
%                      [rho,pval] = corr(psd_matrix{i,j,k}(:,l),conn_matrix{i,j,k}(:,:,l),'type','Spearman');%Spearman
                   rho_data{l,k,j,i} = rho;
                   plv_data{l,k,j,i} = pval;
                   
%                    rho_up{i,j,k,l}= find(rho_data{i,j,k,l} > 0.65);
                   rho_up{l,k,j,i}= find(rho_data{l,k,j,i} >= 0.7); %Corr positiva
                   rho_down{l,k,j,i}= find(rho_data{l,k,j,i} < -0.7); %Corr negativa
                   
                   %Corr positiva
%                    if ~isempty(find(rho_data{l,k,j,i} >= 0.7, 1)) 
%                        m = numel(rho_up{l,k,j,i});%counting elements in the matrix 
%                        table(pp,1:4+m) = [l,k,j,i,rho_up{l,k,j,i}];
%                        pp = pp+1;
%                        if m > m_max
%                            m_max = m;
%                        end
%                    end

%                     %Corr negativa
                    if ~isempty(find(rho_data{l,k,j,i} < -0.7, 1)) 
                       m = numel(rho_down{l,k,j,i});
                       table(pp,1:4+m) = [l,k,j,i,rho_down{l,k,j,i}];
                       pp = pp+1;
                       if m > m_max
                           m_max = m;
                       end
                   end
            end
        end
        if pp > 1
           aux{l,k} = table(1:pp-1,1:m_max+4);
           if path_conn(3:6) ~= "S11D" %Somente para os dois estados normal e fadigado da chinesa 
               tbS1 = table(:,3)==1;
               tbS2 = table(:,3)==2;
               table1 = table(tbS1,:);
               table2 = table(tbS2,:);
               [~,~,vals1] = find(table1(:,5:end));
               valsChannels1{l,k} = vals1;

               [~,~,vals2] = find(table2(:,5:end));
               valsChannels2{l,k} = vals2;
           else %S11D
               tbS1 = table(:,3)==1;
               table1 = table(tbS1,:);
               [~,~,vals1] = find(table1(:,5:end));
               valsChannels1{l,k} = vals1;
               
           end
           clear table  
        end
    end
end

%%
%Criando pasta para para para guardar analise de ocorrencia
mkdir('./Matrizes/Ocorrencia/');

%Cell geral com todos os estados 
% save('./Matrizes/Ocorrencia/aux_cell.mat','aux');
%Estado fadigado  
% save('./Matrizes/Ocorrencia/valsChannels1.mat','valsChannels1');
%Estado normal
% save('./Matrizes/Ocorrencia/valsChannels2.mat','valsChannels2');

%% funcao  que receba os vetores de regiao para verificar igualdade com os 
% elementos de aux, caso haja, o numero de canais sera contado dependendo

% Criando vetor de canais 
v_ch = {v_fp,v_f,v_c,v_t,v_p,v_o,v_zChannels};

%Turning to string
% v_ch = cellfun(@num2str,v_ch,'un',0)

%Estado mental Fadigado 
% usar valsChannels_up1;

%Estado mental Normal
% usar valsChannels_up2;

for i = 1:length(v_ch)
    if exist('valsChannels1','var')
%     [ocorrencia_ch_up1{i},sum_ocorrencia_up1{i}] = contaCanais(aux,v_ch{i},ch_label);%(minuto+len, freq, #canais, regiao)
      [ocorrencia_ch1{i},sum_ocorrencia_up1{i}] = contaCanais(valsChannels1,v_ch{i},ch_label);
      [ocorrencia_ch2{i},sum_ocorrencia_up2{i}] = contaCanais(valsChannels2,v_ch{i},ch_label);%(minuto+len, freq, #canais, regiao)
    else %s11d
      [ocorrencia_ch1{i},sum_ocorrencia_up1{i}] = contaCanais(valsChannels1,v_ch{i},ch_label);
    end
end

% %Fatigue state
% save('./Matrizes/Ocorrencia/ocorrencia_ch_up1.mat','ocorrencia_ch_up1');
% save('./Matrizes/Ocorrencia/sum_ocorrencia_up1.mat','sum_ocorrencia_up1');
% %Normal state
% save('./Matrizes/Ocorrencia/ocorrencia_ch_up2.mat','ocorrencia_ch_up2');
% save('./Matrizes/Ocorrencia/sum_ocorrencia_up2.mat','sum_ocorrencia_up2');

%Fatigue state
save('./Matrizes/Ocorrencia/ocorrencia_ch1.mat','ocorrencia_ch1');
save('./Matrizes/Ocorrencia/sum_ocorrencia_up1.mat','sum_ocorrencia_up1');
%Normal state
save('./Matrizes/Ocorrencia/ocorrencia_ch2.mat','ocorrencia_ch2');
save('./Matrizes/Ocorrencia/sum_ocorrencia_up2.mat','sum_ocorrencia_up2');

%% Cronstructing table of data 

%Turning v_ch to row matrix or column
% v_ch2 = cellfun(@transpose,v_ch,'UniformOutput',0);
for i = 1:length(v_ch)
%     if size(v_ch{i},1) ~= 1 %row
    if size(v_ch{i},1) == 1 %column
        v_ch{i} = transpose(v_ch{i});
    end
end

%Coluna de labels
v_ch_mat = ch_label((cell2mat(v_ch')));
channels_table = vertcat(v_ch_mat(1:2),'Sum',v_ch_mat(3:10),'Sum',v_ch_mat(11:14),'Sum',v_ch_mat(15:20),'Sum',v_ch_mat(21:22),'Sum',v_ch_mat(23:end),'Sum')

%Contruindo tabela de ocorrencias com a soma de ocorrencias por regiao
a = cell2mat(sum_ocorrencia_up1'); %fadigado
b = cell2mat(sum_ocorrencia_up2'); %normal

%CEll of all ocurrencies of all regions 
c = [];
for i = 1:7
    c{i} = [a(:,i),b(:,i)];
end
c = cell2mat(c);%tabela com canais selecionados!!!!!


%Contruindo tabela de ocorrencias sem a soma de ocorrencias por regiao
for i = 1:7 %para cada regiao
     a_semsoma{i} = sum_ocorrencia1{i}(1:end-1,:);   %fadigado
     b_semsoma{i} = sum_ocorrencia2{i}(1:end-1,:);  %normal
     
     a_soma{i} = sum_ocorrencia1{i}(end,:);   %fadigado
     b_soma{i} = sum_ocorrencia2{i}(end,:);  %normal
end
%turning to mat
a_semsoma = cell2mat(a_semsoma');
b_semsoma = cell2mat(b_semsoma');

a_soma = cell2mat(a_soma');
b_soma = cell2mat(b_soma');

%CEll of all ocurrencies of all regions without the sum
c_semsoma = [];
c_soma = [];
for i = 1:7
    c_semsoma{i} = [a_semsoma(:,i),b_semsoma(:,i)];
    c_soma{i} = [a_soma(:,i),b_soma(:,i)];
end
c_semsoma = cell2mat(c_semsoma);
c_soma = cell2mat(c_soma);
c_semsoma_logical = logical(c_semsoma);
%% Taking the mean of subjects from conn_matrix (chinesa)
%This is necessary to take the max and minimum value to normalize plots 

for i = 1:2 %estados mentais
    for j = 1:7 %bandas de frequencias
        % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
        MeanC{i,j} = mean(cat(3, conn_matrix{:,i,j}),3); %Mean of all subjects in all 5 minutes
        MeanC_cat{i,j,k} = cat(3, conn_matrix{:,i,j}); 
        
        %Taking max and min values
        minmaxValue_MeanC{i,j} = [min(min(min(MeanC{i,j}))) max(max(MeanC{i,j}))]; %Max &min of the mean 
        minmaxValue_MeanCAll{i,j} = [min(min(min(MeanC_cat{i,j}))) max(max(max(MeanC_cat{i,j})))]; %Max &min of all values

    end
%     minmaxValueAllFreqs{i,1} = min(minmaxValue_MeanC{i,1:7});
end

save('./Matrizes/Ocorrencia/MeanC_cat.mat','MeanC_cat');
save('./Matrizes/Ocorrencia/MeanC.mat','MeanC');

save('./Matrizes/Ocorrencia/minmaxValue_MeanC.mat','minmaxValue_MeanC');
save('./Matrizes/Ocorrencia/minmaxValue_MeanCAll.mat','minmaxValue_MeanCAll');

%% Taking the mean of subjects from conn_matrix (s11d)
%This is necessary to take the max and minimum value to normalize plots 


    for j = 1:7 %bandas de frequencias
        % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
        MeanC_3i_s11d{i,j} = mean(cat(3, conn_matrix_3i_s11d{:,1,j}),3); %Mean of all subjects in all 3 minutes
        MeanC_3f_s11d{i,j} = mean(cat(3, conn_matrix_3f_s11d{:,1,j}),3); %Mean of all subjects in all 3 minutes
%         MeanC_cat{i,j,k} = cat(3, conn_matrix{:,i,j}); 
        
        %Taking max and min values
%         minmaxValue_MeanC{i,j} = [min(min(min(MeanC{i,j}))) max(max(MeanC{i,j}))]; %Max &min of the mean 
%         minmaxValue_MeanCAll{i,j} = [min(min(min(MeanC_cat{i,j}))) max(max(max(MeanC_cat{i,j})))]; %Max &min of all values

    end
%     minmaxValueAllFreqs{i,1} = min(minmaxValue_MeanC{i,1:7});


%% Normalizacao das matrizes de todos os 5 min de dados por estado 

for j = 1:7 %bandas de frequencias
    for i = 1:2 %estados mentais
        minmaxValue_bystate{j} = [min(min(minmaxValue_MeanC{:,j})) max(max(minmaxValue_MeanC{:,j}))];
    end
end

save('./Matrizes/Ocorrencia/minmaxValue_bystate.mat','minmaxValue_bystate');

%% Sobre MeanC_cat - Removendo dimensao dos sujeitos 
% MeanC_cat{i,j} é a concatenacao dos 5 minutos de cada um dos 12 sujeitos,
% ou seja, 5 minutos do primeiro sujeito, concatenados com 5 min do segundo
% sujeito e etc.

% MeanC_cat -> {2,7}(30,30,60)

for i = 1:2
    for j = 1:7
%         MeanC_cat_perMin_perSubj{i,j} =
%         mean(reshape(MeanC_cat{i,j},[30,30,5,12]),4);%Mean to eliminate
%         subject dim
          MeanC_cat_perMin_perSubj{i,j} = reshape(MeanC_cat{i,j},[30,30,5,12]);
          %MeanC_cat_perMin_perSubj cell(2,7) of (30,30,5,12)double
    end
end

%Taking mean of subjects 
MeanC_cat_perMin_perFreq = cellfun(@(x) mean(x,4),MeanC_cat_perMin_perSubj,'un',0);

Cmeans = cellfun(@mean, MeanC_cat_perMin_perSubj,'un',0);

%% Plotting connectivity matrix 

%Vetor de estados 
v_estados = {'Fatigue','Normal'};

%Vetor de frequencias 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%Limites considerados 
%% Of all 5 min 
custom_limit = minmaxValue_MeanC; %MinMax de cada frequencia e de cada estado (nao normalizado)
% custom_limit = minmaxValue_bystate; %MinMax normalizado ao longo dos estados para cada frequencia 

%Of conn matrix of all 5 min 
%Pasta com os plots dos 5 min sem normaizacao de todos os suj
% path_img = './Images/conn/NonNormalized/OfAll5min/MatrizCon/';

%Pasta com os plots dos 5 min normalizados ao longo dos estados
% path_img = './Images/conn/Normalized/All5minMatrix_normbystate/MatrizCon/';

%Pasta com os plots dos 5 min normalizados ao longo dos estados por sujeito
path_img = './Images/conn/Normalized/All5minMatrix_normbystate_persubj/MatrizCon/';

mkdir(path_img);

disp(' --------------------------------------------------------- ');
disp('Plotting and saving connectivity matrixes per band');
disp(' --------------------------------------------------------- ');

%Vetor de matrizes de connectividade que serao plotadas 
%MeanC ->  Media de conectividades para todos os sujeitos nos 5 min
%{2,7}cell of (30,30) double.
%MeanC_cat -> Conectividade dos 12 sujeitos ao longo dos 5 min concatenados
%em matrizes 30x30x60. é uma cell(2,7) de (30,30,60) double

%Plot of the mean of connectivity through all 5 min 
for i = 1:2
    for j = 1:7
        %Add aqui especificacao para salvar por metrica
        h = figure('position', [100 100 1000 700]);
        %             imagesc(tril(mean(conn_teta{i},3)));
%         imagesc(tril(MeanC{i,j})); %Of all 5 min 
        imagesc(tril(MeanC_cat{i,j}));
        set(gca,'XTick',1:length(ch_label));
        set(gca,'XTickLabel', ch_label);
        set(gca,'YTick',1:length(ch_label));
        set(gca,'YTickLabel', ch_label);
        
        %Setting limit to the max&min value 
        caxis([custom_limit{1,j}]); %Comment for non normalization
        
        % Setting colorbar ticks 
        % The max colorbar value will always be the max value of
        % connectivity
        cbh = colorbar('h'); %Creating object of colorbar
%         cbh.Ticks(end) = custom_limit{1,j}(2);
        cbh.Ticks = linspace(custom_limit{1,j}(1),custom_limit{1,j}(2),10);
        cbh.Location = 'eastoutside';
%         colorbar; %Uncoment for non normalization 
        
        title(['Conectividade dwpli',' - ',v_estados{i},' frequencia ',freqbdw_label{j},'(',freqbdw{j},')'],'Interpreter','none');
        %             % Changing color scheme
        %              colorscheme = othercolor('OrRd9',260);        
        %              colormap(colorscheme);       
        
        %Saving figures
        %             saveas(h,sprintf(strcat(pathcon_img,'/','MeanTeta.png'))); % will create FIG1, FIG2,...
        saveas(h,[path_img,'MatrizCon_',v_estados{i},'_',freqbdw_label{j}],'fig');
        saveas(h,[path_img,'MatrizCon_',v_estados{i},'_',freqbdw_label{j}],'png');
        close all;
    end
end

%% Plotting matrices of each minute of 5 min  

%Creating folder to save images of each minute of 5 min 
% path_img = './Images/conn/Normalized/OfEachMin_persubj/MatrizCon/';%Pasta com os plots de cada min dos 5 min com normaizacao para todos os sujeitos e min 
% path_img = './Images/conn/Normalized/OfEachMin_persubj_normbystate/MatrizCon/';%Pasta com os plots de cada min dos 5 min normalizados ao longo dos estados

%Pasta com os plots dos 5min por sujeito 
% path_img = './Images/conn/NonNormalized/OfAll5min_persubj/MatrizCon/';

%Pasta com os plots dos 5min por min por sujeito 
% path_img = './Images/conn/NonNormalized/OfEachMin_persubj/MatrizCon/';

mkdir(path_img);

%Custom limit of colorbar
% custom_limit = minmaxValue_MeanCAll; %MinMax de cada frequencia e de cada estado (nao normalizado)

%Calculating mean of state
for i = 1:7
    for j = 1:2 %estados mentais
        minmaxValue_MeanCAll_bystate{i} = [min(min(minmaxValue_MeanCAll{:,i})) max(max(minmaxValue_MeanCAll{:,i}))];
    end
end

%Calculating mean of 5 min per subject is done by  MeanC_cat_perMin_perSubj -> cell(2,7) de (30,30,60) double
for i = 1:2
    for j = 1:7
       MeanC_cat_ofAll5min_perSubj{i,j} =  permute(mean(MeanC_cat_perMin_perSubj{i,j},3),[1,2,4,3]);
    end
end

custom_limit = minmaxValue_MeanCAll_bystate; %MinMax normalizado ao longo dos estados para cada frequencia 

%%
disp(' --------------------------------------------------------- ');
disp('Plotting and saving connectivity matrixes per band');
disp(' --------------------------------------------------------- ');

%Vetor de matrizes de connectividade que serao plotadas 
%MeanC ->  Media de conectividades para todos os sujeitos nos 5 min
%{2,7}cell of (30,30) double.
%MeanC_cat -> Conectividade dos 12 sujeitos ao longo dos 5 min concatenados
%em matrizes 30x30x60. é uma cell(2,7) de (30,30,60) double
%MeanC_cat_perMin_perSubj-> Conn por sujeito por minuto -> MeanC_cat_perMin_perSubj cell(2,7) of (30,30,5,12)double

%Plot of the mean of connectivity through all 5 min 
for i = 1:2 
    for j = 1:7
        for k = 1:5  %  min 
            for l = 1:12 %subj
                %Add aqui especificacao para salvar por metrica
                h = figure('position', [100 100 1000 700]);
%                 imagesc(tril(MeanC_cat_perMin_perSubj{i,j}(:,:,k,l)));
                imagesc(tril(MeanC_cat_ofAll5min_perSubj{i,j}(:,:,l)));
                set(gca,'XTick',1:length(ch_label));
                set(gca,'XTickLabel', ch_label);
                set(gca,'YTick',1:length(ch_label));
                set(gca,'YTickLabel', ch_label);

                %Setting limit to the max&min value 
%                 caxis([custom_limit{i,j}]); %Limit for no state normalization 
                caxis([custom_limit{j}]); %Limit for state normalization 

                % Setting colorbar ticks 
                % The max colorbar value will always be the max value of
                % connectivity
                cbh = colorbar('h'); %Creating object of colorbar
%                 cbh.Ticks = linspace(custom_limit{i,j}(1),custom_limit{i,j}(2),10);
                cbh.Ticks = linspace(custom_limit{j}(1),custom_limit{j}(2),10);
                cbh.Location = 'eastoutside';
%                 colorbar; %Uncoment for non normalization 

%                 title(['Dwpli',' - ',v_estados{i},' subj',num2str(l),'Min:',num2str(k),' frequencia ',freqbdw_label{j},'(',freqbdw{j},')'],'Interpreter','none');      
                title(['Dwpli',' - ',v_estados{i},' subj',num2str(l),' frequencia ',freqbdw_label{j},'(',freqbdw{j},')'],'Interpreter','none'); %Of all 5 min 
                %Saving figures
                %             saveas(h,sprintf(strcat(pathcon_img,'/','MeanTeta.png'))); % will create FIG1, FIG2,...
                
                %Per minute
%                 saveas(h,[path_img,'MatrizCon_subj',num2str(l),'_min',num2str(k),'_',v_estados{i},'_',freqbdw_label{j}],'fig');
%                 saveas(h,[path_img,'MatrizCon_subj',num2str(l),'_min',num2str(k),'_',v_estados{i},'_',freqbdw_label{j}],'png');

                %Of all 5 min 
                saveas(h,[path_img,'MatrizCon_subj',num2str(l),'_ofAll5min_',v_estados{i},'_',freqbdw_label{j}],'fig');
                saveas(h,[path_img,'MatrizCon_subj',num2str(l),'_ofAll5min_',v_estados{i},'_',freqbdw_label{j}],'png');
                close all;
            end
        end
    end
end



%% Wilcoxon

% Necessario vetorizar o tril da matriz de connectividade de duas matrizes
% na mesma frequencia em estados diferentes 
% As matrizes de connectividade serao 
%     * da media dos 5 minutos,para todos os sujeitos -> usar MeanC_cat
%     * de min a min dos 5 minutos,para todos os sujeitos -> usar media dos
%     subj de MeanC_cat_perMin_perSubj



%Getting index of conn matrix tril excluindo redundancia
tril_mask_ones = tril(ones(30,30),-1);
[index_tril_i,index_tril_j ] = ind2sub([30,30],find(tril_mask_ones)); %Turning linear index to subscripts
%Criando vetor de combinacao de pares 
%Combinacao 30 2 a 2 = 435 pares
for i = 1:435
    ch_label_pairs{i,1} = [ch_label{index_tril_j(i)},'-',ch_label{index_tril_i(i)}];
end
%Saving vector of pairs combinations 
save('./Matrizes/Ocorrencia/ch_label_pairs.mat','ch_label_pairs');



%Getting index of conn matrix tril considerando redundancia
matrix_mask_ones = ones(30,30);
[index_matrix_i,index_matrix_j ] = ind2sub([30,30],find(matrix_mask_ones)); %Turning linear index to subscripts
%Criando vetor de combinacao de pares 
%Combinacao 30 2 a 2 = 435 pares
for i = 1:900
    ch_label_pairs_redundante{i,1} = [ch_label{index_matrix_j(i)},'-',ch_label{index_matrix_i(i)}];
end
%Saving vector of pairs combinations 
save('./Matrizes/Ocorrencia/ch_label_pairs_redundante.mat','ch_label_pairs_redundante');


% Transformando matrizes de connectividade em vetor 
% for i = 1:2
%     for j = 1:7
%         MeanC_vector{i,j} = nonzeros(tril(MeanC{i,j}));
%     end
% end
%% Wilcoxon 
for i = 1:7 %Para cada frequencia
    for j = 1:30 %Para todos os pares de um determinado canal ( nao seria para todos os canais?)
%            p_teste{i,j} = ranksum(MeanC{1,i}(j,:),MeanC{2,i}(j,:),'tail','right'); % Fadigado - Normal
          % hipotese: conn Norm > conn Fad 
          % Os valores em h2, se 1 , representam qdo a hipotese foi
          % alcancada
          [ p_val_nf{i,j},hip_nf{i,j}] = ranksum(MeanC{1,i}(j,:),MeanC{2,i}(j,:),'tail','left'); %  Normal > Fadigado ***
          [ p_val_fn{i,j},hip_fn{i,j}] = ranksum(MeanC{1,i}(j,:),MeanC{2,i}(j,:),'tail','right'); % Fadigado > Normal 
    end
end

%Labeling mask of fn
labeled_hip_fn = cell(7,30);
for i = 1:7
    for j = 1:30
        if hip_fn{i,j} == 1
            labeled_hip_fn{i,j} = ch_label{j};
        end
    end
end

%Labeling mask of nf
labeled_hip_nf = cell(7,30);
for i = 1:7
    for j = 1:30
        if hip_nf{i,j} == 1
            labeled_hip_nf{i,j} = ch_label{j};
        end
    end
end

%Salvando valores de pval e hip para corr positiva 
save('./Matrizes/Ocorrencia/p_val.mat','p_val');
save('./Matrizes/Ocorrencia/hip.mat','hip');
save('./Matrizes/Ocorrencia/labeled_hip.mat','labeled_hip');
     

%% Verifying pairs correlated with PSD and with significance 

%Getting the matrix 
% a_semsoma %all ocorrencies for fatigue state in all 30 ch and 7 frequencies (30,7)
% b_semsoma %all ocorrencies for normal state in all 30 ch and 7 frequencies (30,7)

%Turning sum of ocorrencies to logical 
a_semsoma_logical = logical(a_semsoma);
b_semsoma_logical = logical(b_semsoma);

%Turning hip (of wilcoxon) cell to mat
hip_mat_nf = cell2mat(hip_nf);
hip_mat_fn = cell2mat(hip_fn);

% Verifying channel with hip 
verif_corr_ocurr_fat_nf = and(hip_mat_nf,a_semsoma_logical')'; %30 x 7
verif_corr_ocurr_nor_nf = and(hip_mat_nf,b_semsoma_logical')'; %30 x 7

verif_corr_ocurr_fat_fn = and(hip_mat_fn,a_semsoma_logical')'; %30 x 7
verif_corr_ocurr_nor_fn = and(hip_mat_fn,b_semsoma_logical')'; %30 x 7

verif_corr_ocurr_and_nf = and(verif_corr_ocurr_fat_nf,verif_corr_ocurr_nor_nf);

verif_corr_ocurr_and_fn = and(verif_corr_ocurr_fat_fn,verif_corr_ocurr_nor_fn);

% Turning results to table de ambos os estados 
verif_corr_ocurr = [];
for i = 1:7
    verif_corr_ocurr{i} = [verif_corr_ocurr_fat(:,i),verif_corr_ocurr_nor(:,i)];
end

verif_corr_ocurr = cell2mat(verif_corr_ocurr);
save('./Matrizes/Ocorrencia/verif_corr_ocurr.mat','verif_corr_ocurr');
save('./Matrizes/Ocorrencia/verif_corr_ocurr_fat.mat','verif_corr_ocurr_fat');
save('./Matrizes/Ocorrencia/verif_corr_ocurr_nor.mat','verif_corr_ocurr_nor');
save('./Matrizes/Ocorrencia/verif_corr_ocurr_and.mat','verif_corr_ocurr_and');

%% Analise de variacao de connectividade 
%Implementada para os canais selecionados na etapa anterior 
% A partir de MeanC

%% Nova analise
% selec_ch = {[14,18,22,23,26,27,28,29,30],[3],[3,12,13,17],[5]};
% selec_freq = {[1,2,4,5,6,7],[3],[2,4,6,7],[5]};

%Pego do excel 
% verif_corrPos_ocurr_and_nf = [0	0	0	0	0	0	0	0	0	0	1	0	0	1	1	0	0
% 0	0	0	0	0	0	0	1	1	1	0	0	1	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0
% 0	0	0	0	0	0	0	0	0	1	0	0	0	1	1	0	1
% 0	0	0	0	0	0	0	1	0	1	0	0	0	0	1	0	0
% ]';

% verif_corrPos_ocurr_and_fn =[0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
% ]';

% verif_corrNeg_ocurr_and_nf = [0	0	0	0	0	0	0	0	0	0	0	0	0
% 1	0	0	0	1	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	1	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% 1	0	0	0	1	0	0	0	0	0	0	0	0
% 1	0	0	0	0	1	0	0	0	0	0	0	0]';
 
% verif_corrNeg_ocurr_and_fn = [ 0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	1	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% 0	0	0	0	0	0	0	0	0	0	0	0	0
% ]';

corrP_nf = [false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true	true	true	false	false	true	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	true	false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true	false	false	false	true	true	false	false	false	false	false	true
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true	true	true	false	false	false	false	true	false	false	false	false	false	false
];

corrN_nf = [false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true	false	false	false	false	false	false	false	false	true	true	false	false
false	false	true	false	false	false	true	false	false	false	false	false	false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true	false	true	false	false	false	false	false	false	false	false	false	false	false	true
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	true	false	false	false	true	false	false	false	false	false	false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false
];

corrP_fn = [false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	true	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
];

corrN_fn = [false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	true	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false	false
];

%% Get index of ch and freq from table verif_corr_and

% [ch_selec,freq_selec] = find(verif_corr_ocurr_and ==1);
% 
% [ch_selec,freq_selec] = find(verif_corr_ocurr_and_fn ==1);

%Corr +
[freq_selec_pos_nf,ch_selec_pos_nf] = find(corrP_nf ==1);
[freq_selec_pos_fn,ch_selec_pos_fn] = find(corrP_fn ==1);

%Corr -
[freq_selec_neg_nf,ch_selec_neg_nf] = find(corrN_nf ==1);
[freq_selec_neg_fn,ch_selec_neg_fn] = find(corrN_fn ==1);

%% Turning to cell (index) and cell of strings (labels)
% v_ch_selec_label = cell(1,length(ch_selec));
% for i = 1:length(ch_selec)
%     v_ch_selec_label{i} = [ch_label{ch_selec(i)},'-',freqbdw_label{freq_selec(i)}];
%     v_ch_selec{i} = [ch_selec(i) freq_selec(i)];
% end

%Corr +
v_ch_selec_pos_label_nf = cell(1,length(ch_selec_pos_nf));
for i = 1:length(ch_selec_pos_nf)
    v_ch_selec_pos_label_nf{i} = [ch_label{ch_selec_pos_nf(i)},'-',freqbdw_label{freq_selec_pos_nf(i)}];
    v_ch_selec_pos_nf{i} = [ch_selec_pos_nf(i) freq_selec_pos_nf(i)];
end

v_ch_selec_pos_label_fn = cell(1,length(ch_selec_pos_fn));
for i = 1:length(ch_selec_pos_fn)
    v_ch_selec_pos_label_fn{i} = [ch_label{ch_selec_pos_fn(i)},'-',freqbdw_label{freq_selec_pos_fn(i)}];
    v_ch_selec_pos_fn{i} = [ch_selec_pos_fn(i) freq_selec_pos_fn(i)];
end

%Corr-
v_ch_selec_neg_label_nf = cell(1,length(ch_selec_neg_nf));
for i = 1:length(ch_selec_neg_nf)
    v_ch_selec_neg_label_nf{i} = [ch_label{ch_selec_neg_nf(i)},'-',freqbdw_label{freq_selec_neg_nf(i)}];
    v_ch_selec_neg_nf{i} = [ch_selec_neg_nf(i) freq_selec_neg_nf(i)];
end

v_ch_selec_neg_label_fn = cell(1,length(ch_selec_neg_fn));
for i = 1:length(ch_selec_neg_fn)
    v_ch_selec_neg_label_fn{i} = [ch_label{ch_selec_neg_fn(i)},'-',freqbdw_label{freq_selec_neg_fn(i)}];
    v_ch_selec_neg_fn{i} = [ch_selec_neg_fn(i) freq_selec_neg_fn(i)];
end


v_selec_label = {v_ch_selec_pos_label_nf,v_ch_selec_pos_label_fn,v_ch_selec_neg_label_nf,v_ch_selec_neg_label_fn};
v_selec = {v_ch_selec_pos_nf,v_ch_selec_pos_fn,v_ch_selec_neg_nf,v_ch_selec_neg_fn};

%%

%15 elementos
%Corr+
% v_ch_selec_label = {'T3-alpha1','T4-beta2','TP7-beta','TP7-beta1','TP7-beta2','T5-beta1','C4-alpha1','CP3-beta','CP3-beta1','CP3-beta2','P3-beta1','P3-beta2','O2-alpha','O2-alpha1','O2-alpha2'};
%Corr - 
% v_ch_selec_label = {'F7-beta','F7-beta1','F7-beta2','F8-beta','F8-beta1','T6-alpha','TP7-alpha','TP7-alpha1','C4-alpha1','O1-alpha','O2-alpha1','Cz-beta'};


%V_ch_selec guarda as informacoes do indice do canal (v_ch_selec{1}(1)) e
%da frequencia analisada (v_ch_selec{1}(2))
% v_ch_selec = {[13 4],[17 7],[18 2],[18 6],[18 7],[23 6],[16 4],[19 2],[19 6],[19 7],[24 6],[24 7],[30 1],[30 4],[30 5]};

%C4 em alpha1
% a_fat = MeanC{1,4}(16,:); %MeanC{estado,freq}(ch_selec,:)
% a_nor = MeanC{2,4}(16,:); 

% varia_conn = zeros(length(v_ch_selec_label),30);
% for i = 1:length(v_ch_selec_label) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
%     for j = 1:30 %Para todas as combinacoes de canal
% %           varia_conn(w) = a_nor(w)/a_fat(w);
% %           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
%             varia_conn(i,j) = MeanC{2,v_ch_selec{i}(2)}(v_ch_selec{i}(1),j) / MeanC{1,v_ch_selec{i}(2)}(v_ch_selec{i}(1),j);
% %             varia_conn_fn(i,j) = MeanC{2,v_ch_selec{i}(2)}(v_ch_selec{i}(1),j) / MeanC{1,v_ch_selec{i}(2)}(v_ch_selec{i}(1),j);
%     end
% end
% 
% %Removendo valores menores que 1
% varia_conn(varia_conn<1) = 0;
% %Removendo NaN
% varia_conn(isnan(varia_conn))=0;
% %Transpondo para ch no eixo y 
% varia_conn = varia_conn';

%Pares selecionados kdmile
v_selec_label = {v_ch_selec_pos_label_nf,v_ch_selec_pos_label_fn,v_ch_selec_neg_label_nf,v_ch_selec_neg_label_fn};
v_selec = {v_ch_selec_pos_nf,v_ch_selec_pos_fn,v_ch_selec_neg_nf,v_ch_selec_neg_fn};

%%
for m = 1:length(v_selec) %4 scenarios
    varia_conn{m} = zeros(length(v_selec_label{m}),30);
    for i = 1:length(v_selec_label{m}) %quantidade de canais selecionados de acordo com suas respectivas frequencias como em v_ch_selec_label
        for j = 1:30 %Para todas as combinacoes de canal
            %           varia_conn(w) = a_nor(w)/a_fat(w);
            %           varia_conn(w) = MeanC{2,4}(16,w)/MeanC{1,4}(16,w);
            varia_conn{m}(i,j) = MeanC{2,v_selec{m}{i}(2)}(v_selec{m}{i}(1),j) / MeanC{1,v_selec{m}{i}(2)}(v_selec{m}{i}(1),j);
            %             varia_conn_fn(i,j) = MeanC{2,v_ch_selec{i}(2)}(v_ch_selec{i}(1),j) / MeanC{1,v_ch_selec{i}(2)}(v_ch_selec{i}(1),j);
        end
    end
end

% xlswrite('./Chinesa/Matrizes/varia_connfP.xls','varia_conn{1}');

for m = 1:length(v_selec) %4 scenarios
    %Removendo valores menores que 1
    varia_conn{m}(varia_conn{m}<1) = 0;
    %Removendo NaN
    varia_conn{m}(isnan(varia_conn{m}))=0;
    %Transpondo para ch no eixo y
    varia_conn{m} = varia_conn{m}';
end

%% Getting name of selected pairs of channels > 5

for m = 1:4 %scenarios
    for i = 1:size(varia_conn{m},2)%Para cada ch escolhido
        [l,c] = find(varia_conn{m}>5);
        [l1,c1] = find(varia_conn{m}>10);
        for k = 1:length(c)
            varia_conn_label{m}{k} = [ch_label{l(k)},'-',v_selec_label{m}{c(k)}];
%             varia_conn_maiorq5{m}{k} = varia_conn{m}(l,c);
        end
        
        for k1 = 1:length(c1)
            varia_conn_label_maiorq10{m}{k1} = [ch_label{l1(k1)},'-',v_selec_label{m}{c(k1)}];
%             varia_conn_maiorq5{m}{k} = varia_conn{m}(l,c);
        end
    end 
   
end
disp('ok');

save([path_conn,'varia_conn_label_kdmile.mat'],'varia_conn_label');
save([path_conn,'varia_conn_label_maior10_kdmile.mat'],'varia_conn_label_maiorq10');

%% Outra forma de fazer - a certa!

v_comb_selec_ch = cell(4,24); %Cria cell vazia
v_comb_selec_ch_label = cell(4,24); %Cria cell vazia

for m = 1: 4 %4 scenarios
    %[i,j] = [row,col], que representa a identificacao do par no varia_con
    [i,j] = find(varia_conn{m} >5);%i >>indice de ch em ch_label e j, indice em v_ch_selec
    
    
    if isempty(i) || isempty(j)
        disp('Nenhum valor maior que 10. Vazio');
    else
        for k = 1:length(j) %ao longo dos canais selecionados ...
            %     v_freq_label{i} = [ch_label{ch_selec(i)}];
            %     v_freq{i} = [ch_selec(i) freq_selec(i)];
            v_comb_selec_ch{m,k} = [v_selec{m}{j(k)}(2) v_selec{m}{j(k)}(1) i(k) ];
            v_comb_selec_ch_label{m,k} = [ ch_label{i(k)},'-',v_selec_label{m}{j(k)} ];
        end
    end
end

save([path_conn,'v_comb_selec_ch_maiorq5.mat'],'v_comb_selec_ch');
save([path_conn,'v_comb_selec_ch_label_maiorq5.mat'],'v_comb_selec_ch_label');

% save([path_conn,'v_comb_selec_ch_maiorq10.mat'],'v_comb_selec_ch');
% save([path_conn,'v_comb_selec_ch_label_maiorq10.mat'],'v_comb_selec_ch_label');
%%

save([path_conn,'varia_conn_kdmile.mat'],'varia_conn');

save('./Matrizes/Ocorrencia/varia_conn.mat','varia_conn');
save('./Matrizes/Ocorrencia/v_ch_selec.mat','v_ch_selec');
save('./Matrizes/Ocorrencia/v_ch_selec_label.mat','v_ch_selec_label');
% clear varia_conn

%% Multiplots com fieldtrip 

path_fieldtrip = fullfile('..','..','..','Fieldtrip');
addpath(path_fieldtrip);
% addpath('C:\Users\b0024\Documents\Fieldtrip');

% Preamble
ft_defaults

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

%% Plotting just the channels selected  - Coefficient of variation
% v_freq_label = {'beta','beta1','beta2'};
% v_freq = [2,6,7]; %index of frequencies beta, beta1 e beta2 em conn_m,atrix_freq_meansubj
%find(v_freq==2)%retunr the ndex of each value


% [i,j] = find(varia_conn >10);%i >>indice de ch em ch_label e j, indice em v_ch_selec
% 
% if isempty(i) || isempty(j)
%     disp('Nenhum valor maior que 10. Vazio');
% else
%     for k = 1:length(j)
%     %     v_freq_label{i} = [ch_label{ch_selec(i)}];
%     %     v_freq{i} = [ch_selec(i) freq_selec(i)];
%         v_comb_selec_ch{k} = [v_ch_selec{j(k)}(2) v_ch_selec{j(k)}(1) i(k) ];
%         v_comb_selec_ch_label{k} = [ ch_label{i(k)},'-',v_ch_selec_label{j(k)} ];
%     end
% end
% 
% save('./Matrizes/v_comb_selec_ch.mat','v_comb_selec_ch');

%KDMILE version 

v_selec_label = {v_ch_selec_pos_label_nf,v_ch_selec_pos_label_fn,v_ch_selec_neg_label_nf,v_ch_selec_neg_label_fn};
v_selec = {v_ch_selec_pos_label_nf,v_ch_selec_pos_label_fn,v_ch_selec_neg_label_nf,v_ch_selec_neg_label_fn};

%%
v_comb_selec_ch = cell(4,24); %Cria cell vazia
v_comb_selec_ch_label = cell(4,24); %Cria cell vazia

for m = 1: 4 %4 scenarios
    %[i,j] = [row,col], que representa a identificacao do par no varia_con
    [i,j] = find(varia_conn{m} >10);%i >>indice de ch em ch_label e j, indice em v_ch_selec
    
    
    if isempty(i) || isempty(j)
        disp('Nenhum valor maior que 10. Vazio');
    else
        for k = 1:length(j) %ao longo dos canais selecionados ...
            %     v_freq_label{i} = [ch_label{ch_selec(i)}];
            %     v_freq{i} = [ch_selec(i) freq_selec(i)];
            v_comb_selec_ch{m,k} = [v_selec{m}{j(k)}(2) v_selec{m}{j(k)}(1) i(k) ];
            v_comb_selec_ch_label{m,k} = [ ch_label{i(k)},'-',v_selec_label{m}{j(k)} ];
        end
    end
end
%%
save([path_conn,'v_comb_selec_ch.mat'],'v_comb_selec_ch');
save([path_conn,'v_comb_selec_ch_label.mat'],'v_comb_selec_ch_label');

% v_comb_selec_ch = {[2 18 26],[2 19 26],[2 19 16],[6 24 26],[7 19 9],[7 19 4],[7 19 25],[7 17 13],[7 18 21],[7 18 27],[7 24 26],[7 24 4]};

% varia_conn_label_maiorq10{m}{k1} = [ch_label{l1(k1)},'-',v_selec_label{m}{c(k1)}];

%% Calculating CV
%from alpha to beta2

% %from v_comb_selec_label get the frequencies
%     for i = 1:length(v_comb_selec_ch{m})
%         v_freq(i) = v_comb_selec_ch{i}(1);
%     end
    
%KDMile version 
%Para acessar cada um dos indices dos pares e frequencias selecionados,
%basta mudar o ultimo parametro de acordo com o par ( 1 e 2 )  e frequencia
%(3) em v_comb_selec_ch

v_freq_unique = unique(v_freq);%selecionando os indices das frequencias sem repeticao 

save('./Matrizes/v_freq.mat','v_freq');
save('./Matrizes/v_freq_unique.mat','v_freq_unique');

for i = 1:length(v_comb_selec_ch)

%     v_comb_selec_ch = {[2 18 26],[2 19 26],[2 19 16],[6 24 26],[7 19 9],[7 19 4],[7 19 25],[7 17 13],[7 18 21],[7 18 27],[7 24 26],[7 24 4]};
%     v_freq = [1, 6, 7]; %from alpha to beta2

    %plot fadigado
%      conn_val_fat = [];
%      conn_val_norm = [];
    for j = 1:length(v_freq_unique) %concatenado valores de alpha,beta1 e beta2
%         conn_val_fat = [conn_val_fat; permute(conn_matrix_freq_meansubj{v_freq(j),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1])];
          conn_val_fat{i,j} = permute(conn_matrix_freq_meansubj{v_freq_unique(j),1}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1]);
          conn_val_norm{i,j} = permute(conn_matrix_freq_meansubj{v_freq_unique(j),2}(v_comb_selec_ch{i}(2),v_comb_selec_ch{i}(3),:),[3,2,1]);
            %Coefficient of Variation 
          CV_fat(i,j) = getCV(conn_val_fat{i,j});
          CV_norm(i,j) = getCV(conn_val_norm{i,j});
    end
end

% clear conn_val_fat
% clear conn_val_norm
save('./Matrizes/conn_val_fat.mat','conn_val_fat');
save('./Matrizes/conn_val_nor.mat','conn_val_norm');

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

for i = 1:length(v_freq)
    conn{i} = [mean(conn_val_fat{i,find(v_freq(i) == v_freq_unique)});mean(conn_val_norm{i,find(v_freq(i) == v_freq_unique)})];
end

conn = cell2mat(conn);
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