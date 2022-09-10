% Analise de trials minima para calculo da connectivity 

path_fieldtrip = fullfile('Z:','MylenaReis','Fieldtrip');
addpath(path_fieldtrip);
% addpath('C:\Users\b0024\Documents\Fieldtrip');

addpath('./utils');

% Preamble
ft_defaults

%% Loading necessary files

% load('./Matrizes/v_con.mat');%Para carregar de todas as metricas
v_con = {'wpli_debiased'};

% Loading freq_cell
% from './Matrizes/Connectivity/' folder

path_data = './Matrizes/DataAfterICA/s11d/PreprocTrialsZero5seg/';

ext_files = [];

%Duracao da trial para colocar como nome das pastas
trial_dur = 'zero5trial';

namefile = 'data_after_ica.mat';

%Calling function to get path data of all files, formating it in a cell
%and also get the name of each subject

if exist('./Matrizes/cell_data_ica.mat')
    disp('----------------------------------------------------');
    disp(' Loading cell_data_ica');
    disp('----------------------------------------------------');
    
    load('./Matrizes/cell_data_ica.mat');
else
    disp('----------------------------------------------------');
    disp(' Creating cell_data_ica');
    disp('----------------------------------------------------');
    
    [cell_data_ica,names_ica] = format_data(path_data,namefile,ext_files);
    save('./Matrizes/cell_data_ica.mat','cell_data_ica');
end

%% Performing frequency analysis over time series data

%For each element of cell_data
%contador
i = num2cell(1:length(cell_data_ica));

if exist(['./Matrizes/MinTrialAnalysis/',trial_dur,'/freq_cell.mat'])
    disp('----------------------------------------------------');
    disp(' Loading freq_cell');
    disp('----------------------------------------------------');
    
    load(['./Matrizes/MinTrialAnalysis/',trial_dur,'/freq_cell.mat']);
else  
    disp('----------------------------------------------------');
    disp(' Creating cell_data_ica');
    disp('----------------------------------------------------');
    
    freq_cell = {};
    freq_cell = performfreqanalysis(cell_data_ica,names_ica');
end
% freq_cell = cellfun(@performfreqanalysis,cell_data_ica,i',names_ica');

mkdir(['./Matrizes/MinTrialAnalysis/',trial_dur,'/']);
save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/','freq_cell.mat'],'freq_cell');

disp('----------------------------------------------------');
disp(' Frequency analysis over time series Complete');
disp('----------------------------------------------------');

%% Beginning min trial analysis
disp('----------------------------------------------------');
disp(' Begining Min Trial Analysis');
disp('----------------------------------------------------');

%% Choosing randonly variables

%  subjects 
% s = num2cell(randsample(12,6,false));%chinesa
% s = num2cell(randsample(7,3,false));%s11d, caso escolha randomica
s = num2cell(4:7);

% Vector of conn metric 
% v_conn = {'coh','wpli_debiased','plv'};
v_conn = {'wpli_debiased'};

% Time in minutes
t = 15; % 15 min 

%s11d 
data_flag = 's11d';

%% De 15 em 15 minutos 

 % 15i
 for j = 1:length(s) %Para cada sujeito escolhido aleatoriamente
%       for i = 1:15:900 % o intervalo eh de 15 minutos por questoes de dinamizar o calculo , retorna 60 valores
        for i = 1:15:1800 % o intervalo eh de 15 minutos por questoes de dinamizar o calculo , retorna 60 valores trial de 0.5 seg
             cfg = [];
             cfg.method = 'wpli_debiased';
             if strcmp(cfg.method ,'coh') == 1
                 cfg.complex = 'absimag'; 
             end
             cfg.trials = [1:i];
             conn_a_15i{j} = ft_connectivityanalysis(cfg, freq_cell{j,2});

             disp(['15i_',num2str(i)]);

             m_15i{j,i} = conn_a_15i{j}.wpli_debiasedspctrm;

             % Selecting randon subjects, channels and frequencies
             % Mintrial_analysis%(?)
      end
 end
 
 %Removendo colunas com elementos vazios
  m_15i_dwpli_subj = reshape(m_15i(~cellfun(@isempty, m_15i)),[3,120]);
  
  mkdir(['./Matrizes/MinTrialAnalysis/',trial_dur,'/']);
  
%   save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/m_dwpli_15i.mat'],'m_15i');
  save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/m_15i_dwpli_subj.mat'],'m_15i_dwpli_subj');

%% 15f
% for j = 1:length(s)
%   for i = 1800:15:2700
%          cfg = [];
%          cfg.method = 'wpli_debiased';
%          if strcmp(cfg.method ,'coh') == 1
%              cfg.complex = 'absimag'; 
%          end
%          cfg.trials = [1:i];
%          conn_a_15f = ft_connectivityanalysis(cfg, freq_cell{1});
% 
%          disp(['15f_',num2str(i)]);
% 
%          m_15f{i} = conn_a_15f.wpli_debiasedspctrm;
%   end
% end
% 
% %Removendo colunas com elementos vazios
% m_15f_dwpli_subj = reshape(m_15f(~cellfun(@isempty, m_15f)),[3,60]);%Esta linha eh influenciada pelo numero de sujeitos escolhidos!
% 
% save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/m_dwpli_15f.mat'],'m_15f');
% save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/m_15f_subj.mat'],'m_15f_dwpli_subj');
    
%% Selecao de 50 valores aleatorios para posterior calculo da media dos 50 pares ao longo da banda beta 
%Apos calculada a conn para os intervalos, sera escolhido um numero
%randomico de pares ,
%  sempre na frequencia beta (30Hz) -> trocado para banda beta 
    
if exist(['./Matrizes/MinTrialAnalysis/',trial_dur,'/randon_select.mat']) == 2
    load(['./Matrizes/MinTrialAnalysis/',trial_dur,'/randon_select.mat']);
else
    randon_select = {};
    for i = 1:50
        % chose a pair of randon numbers from 1 to 19
        y_ch = randsample(19,2,false);

        % if they wer equal, repeat
        if y_ch(1)== y_ch(2)
            disp('Equal numbers');
            y_ch = randsample(19,2,false);
        end
        %chose a number from 1 to 100 
%         y_f = randsample(100,1,true)
%           y_f = 30; %sempre sera 30 porque queremos analisar no max beta
%             y_f = 12:27; %banda beta -> comentado, para evitar que
%             randon_select seja inchada 

    %     helper = [y_ch;y_f]
    
    randon_select{i} = [y_ch];
    
    %Concatenando com cada uma das frequencias de beta
%     for j = 1: length(y_f)
%         randon_select{j,i} = [y_ch;y_f(j)]; 
%     end

    end
    save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/randon_select.mat'],'randon_select');
end
    
% Criando variavel com 50 numeros escolhidos aleatoriamente entre 1 e 120 
% cinquenta_randon_num = randsample(1:120,50);

%% Agrupando valores de conectividade dos pares selecionados.
 v_15i_mean_beta = cell(length(s));
 
parfor k = 1:length(s)%de cada sujeito
    for j = 1:length(m_15i_dwpli_subj)%1:120 %das trials selecionadas de 1:15:900
        for i = 1:50 %Seleciona os 50 pares aleatorios determinados por randon_select
           %beta 12:27
           v_15i_mean_beta{k}(i,j)= abs(mean(m_15i_dwpli_subj{k,j}(randon_select{i}(1),randon_select{i}(2),12:27),3));
%              v_15i_mean_beta(k,i)= mean(m_15i_dwpli_subj{k,i}(randon_select{i}(1),randon_select{i}(2),12:27),3);
        end
    end
end

%v_15i sera uma matriz com os valores dos usuarios k, para as 60 trials
%escolhidas , para cada um dos pares e frequencias escolhidos 


% save(['./Matrizes/MinTrialAnalysis/',trial_dur,'/v_15i_mean_beta.mat'],'v_15i_mean_beta');

%plotting
% turning to double
% v_15_i= cell2mat(v_15_i);
%     v_15_f= cell2mat(v_15_f);   

%% Potting trials througth all 120 conditions of trials calculation

figure
for i = 1:3 %subjects
    subplot(1,3,i)
        for j = 1:50 %Para cada um dos valores selecionados 
        %    subplot(1,3,i)
           plot(v_15i_mean_beta{i}(j,:));
           title(['Sujeito: ',names{s{i}}(1:3)],'Interpreter','none');
           hold on;
        end
end
suptitle({'Teste de valores de conn para pares e frequencias escolhidas ',' randomicamente em relação ao num. de trials(dwpli)15i'});

%%

disp('. ');
disp('. ');
disp('---------------------------------------------------------------------- ');
disp('Fim da analise Min de Trials ... ');
disp('---------------------------------------------------------------------- ');

