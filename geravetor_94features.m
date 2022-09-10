clear
disp( ' ');
disp(' ********************* Initializing *********************** ');
disp( ' ');
% Path of data 
dataPath = fullfile('.','PreprocessigCarol - 3min','Matrizes','PSD','Depois');
files = dir(dataPath);
dirFlags = [files.isdir]& ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
files = files(dirFlags);
folder = {files.folder}.';
subjects = {files.name}.';
% 
% data = cell(12,1);

%% implement a cellfun for each subject
[v,v_teta,v_alfa,v_beta] = cellfun(@create_vectors_s11d,folder,subjects,'UniformOutput',false);

% Saving
save([dataPath '/v_60min.mat'],'v');
save([dataPath '/v_teta_60min.mat'],'v_teta');
save([dataPath '/v_beta_60min.mat'],'v_beta');
save([dataPath '/v_alfa_60min.mat'],'v_alfa');
% save('./Matrizes/v_pariet_alfa.mat','v_pariet_alfa');
% save('./Matrizes/v_frontal_teta.mat','v_frontal_teta');

%% Next step
%Concatenate the saved matrices
% first all tetas of fatigated state 
v_c = [];
v_teta_c = [];
v_alfa_c = [];
v_beta_c = [];
% v_pariet_alfa_c =[];
% v_frontal_teta_c =[];
trials = 300;

for l = 1:2 
    for m = 1:length(files) %12 subjects
         v_c = [v_c; v{m}{l}(:,:,:)]; %subj, state %%todas as bandas juntas
         v_teta_c =[v_teta_c; v_teta{m}{l}(:,:,:)]; %subj, state
         v_alfa_c =[v_alfa_c; v_alfa{m}{l}(:,:,:)]; %subj, state
         v_beta_c =[v_beta_c; v_beta{m}{l}(:,:,:)]; %subj, state
%          v_pariet_alfa_c  = [v_pariet_alfa_c ;v_pariet_alfa{m}{l}(1:280,:,:)];
%          v_frontal_teta_c = [v_frontal_teta_c;v_frontal_teta{m}{l}(1:280,:,:)];

    end
end

%Saving
save([dataPath '/v_c_60min.mat'],'v_c');
save([dataPath '/v_teta_c_60min.mat'],'v_teta_c');
save([dataPath '/v_alfa_c_60min.mat'],'v_alfa_c');
save([dataPath '/v_beta_c_60min.mat'],'v_beta_c');
% save('./Matrizes/v_pariet_alfa_c.mat', 'v_pariet_alfa_c');
% save('./Matrizes/v_frontal_teta_c.mat','v_frontal_teta_c');

%% Vectors of ratio 
% executar apartir daqui

% Eoh %beta/alfa
v_re = [mean(mean(v_beta_c,2),3)]./[mean(mean(v_alfa_c,2),3)];

% Holm %fteta/palfa
% v_rh = [mean(mean(v_c,2),3)]./[mean(mean(v_c,2),3)]; 
v_rh = [mean(mean(v_teta_c,2),3)]./[mean(mean(v_alfa_c,2),3)]; 


%Jap  %(teta+alfa)/beta
v_rj = [ (mean(mean(v_teta_c,2),3)+ mean(mean(v_alfa_c,2),3))./mean(mean(v_beta_c,2),3)];

%Jap %(teta+alfa)/(alfa+beta)
v_rj2 = [(mean(mean(v_teta_c,2),3)+ mean(mean(v_alfa_c,2),3))./(mean(mean(v_beta_c,2),3)+ mean(mean(v_alfa_c,2),3))];

%Saving
save([dataPath '/v_re_60min.mat'],'v_re');
save([dataPath '/v_rh_60min.mat'],'v_rh');
save([dataPath '/v_rj_60min.mat'],'v_rj');
save([dataPath '/v_rj2_60min.mat'],'v_rj2');


%% Creating vector of classes
fimF = length(v_re)/2;

class_f = zeros(fimF,1);
class_n = ones(fimF,1);
classe = [class_f;class_n]';
%% Creating dataset
% TODO - Adicionar var dataset_n e dataset_f para as novas ratios
% e fazer uma cellfun =D 
% Fatigated Status from 1:3360
dataset_f = [];
% all features
dataset_f = [%v_re(1:fimF,:,:) ,v_rh(1:fimF,:,:),v_rj(1:fimF,:,:),v_rj2(1:fimF,:,:),...
    mean(v_teta_c(1:fimF,:,:),3),mean(v_beta_c(1:fimF,:,:),3),...
    mean(v_alfa_c(1:fimF,:,:),3)];

save([dataPath '/dataset_f_5minIF_Set2019.mat'],'dataset_f');

% Normal Status from 3361 to end
fimF = fimF+1;
dataset_n = [];
dataset_n = [%v_re(fimF:end,:,:) ,v_rh(fimF:end,:,:),v_rj(fimF:end,:,:),v_rj2(fimF:end,:,:),...
    mean(v_teta_c(fimF:end,:,:),3),mean(v_beta_c(fimF:end,:,:),3),...
    mean(v_alfa_c(fimF:end,:,:),3)];

save([dataPath '/dataset_n_5minIF_Set2019.mat'],'dataset_n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataset_5minIF = [%v_re(:,:,:) ,v_rh(:,:,:),v_rj(:,:,:),v_rj2(:,:,:),...
    mean(v_teta_c(:,:,:),3),mean(v_beta_c(:,:,:),3),...
    mean(v_alfa_c(:,:,:),3)];


%% %%%%%NAO PODE NORMALIZAR SOZINHO PQ A DISTRIBUIÇÃO DOS DADOS EH DIFERENTE
% dataset_60min_Norm = normaliza_60min(dataset_5minIF)';
% save([dataPath '/dataset_all_5minIF_Set2019_Norm.mat'],'dataset_60min_Norm');
%  save([dataPath '/dataset_all_5minIF_Set2019_Norm_comClasse.mat'],'dataset_60min_Norm','classe');
%% %%%%%sEGUE ISSO PARA NORMALIZAR EM CONJUNTO
load('Y:\AnaSiravenha\BCI\Artigo_Ext_KDMILE\Testes_Artigo_IJCNN\Matrizes\dataset_n_all_IJCNN_Sept18_semFFS.mat')
load('Y:\AnaSiravenha\BCI\Artigo_Ext_KDMILE\Testes_Artigo_IJCNN\Matrizes\dataset_f_all_IJCNN_Sept18_semFFS.mat')
d18_f = dataset_f;
d18_n = dataset_n;
%
load('D:\treinamentoCognitivo\PreprocessigCarol - 3min\Matrizes\PSD\Depois\dataset_f_5minIF_Set2019.mat')
load('D:\treinamentoCognitivo\PreprocessigCarol - 3min\Matrizes\PSD\Depois\dataset_n_5minIF_Set2019.mat')
d19_f = dataset_f';
d19_n = dataset_n';
%
data = [d18_f d19_f d18_n d19_n];
%
dataset_60min_Norm = normaliza_60min(data);
%
metade = size(dataset_60min_Norm,2)/2;
size18 = size(d18_f,2);

datasetNovo_f = dataset_60min_Norm(:,1:metade);
datasetNovo_n = dataset_60min_Norm(:,metade+1:end);

dataset_f = datasetNovo_f(:,size18+1:end);
dataset_n = datasetNovo_n(:,size18+1:end);
dataset_60min_Norm = [dataset_f dataset_n];

save([dataPath '/dataset_all_5minIF_Set2019_Norm.mat'],'dataset_60min_Norm');
save([dataPath '/dataset_all_5minIF_Set2019_Norm_comClasse.mat'],'dataset_60min_Norm','classe');

sum(result_melhor(1:2400)==0)
sum(result_melhor(2401:end)==0)

sum(result_melhor(1:2400)==1)
sum(result_melhor(2401:end)==1)
