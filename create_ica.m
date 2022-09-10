% Script to calculate ica for each subject 

%Load path to store dataafterica
load('./Matrizes/path_data_after_ica.mat');

%load path to specific preprocessed_data
load('./Matrizes/path_preprocessed_data.mat');

% load([path_preprocessed_data,type_recording,'/cell_data.mat']);
% load([path_preprocessed_data,type_recording,'/names.mat']);
cell_data = {'D:\ColetaDirecao\1a turma\Depois\TC2\DAP_29_190619\DAP_29_190619_Benchmark_raw.edf'};
names = {'DAP_29_190619_Benchmark_raw'};
% path_data_after_ica = ['./Matrizes/DataAfterICA/',char(type_recording),'/'];
% mkdir(path_data_after_ica);

%Se arquivo preproc existir, carregar
%ou seja, qdo for rt ou rt_pos
% if char(type_recording) ~= 'Benchmarck_raw'
if strcmp(type_recording,'Benchmark_raw') && strcmp(type_recording,'Fatiguestate') && strcmp(type_recording,'Normalstate') == 0 % se nao for Benchmarck
    load([path_preprocessed_data,type_recording,'/preproc_data.mat']);
else 
    % pasta dos arquivos preprocessados 
%     files = dir(['./Matrizes/Preprocessed_Data/',char(type_recording),'/**/data_redef.mat']);
    files = dir([path_preprocessed_data,type_recording,'/']);
    flag_data = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..')
    preproc_data_files =  files(flag_data);
    preproc_data = struct2cell(preproc_data_files);
    preproc_data = preproc_data(1,:)';
end

%contador
i = num2cell(1:length(cell_data));

%For each preprocessed file of preproc_data

cellfun(@ica_analysis,cell_data,i',names,preproc_data);
% cellfun(@ica_analysis,preproc_data);

disp('. ');
disp('. ');
disp('. ');
disp('. ');
disp('. ');
disp('---------------------------------------------------------------------- ');
disp('-------------------- Fim do cálculo ICA --------------------------- ');
disp('---------------------------------------------------------------------- ');

%no ica
% if exist([path_data_after_ica,type_recording,'/data_after_ica.mat']) == 0
%     if strcmp(type_recording,'Benchmark_raw')
%         %Saving each data_redef on a folder of subjects name
%         mkdir([path_data_after_ica,type_recording,'/',names(1:end-10),'/']);
%         save([path_data_after_ica,type_recording,'/',names(1:end-10),'/data_after_ica.mat'],'-struct','data_after_ica');      
%     else
%         dataAfterIca = {};
%         dataAfterIca = [dataAfterIca ; data_after_ica];
%         save([path_data_after_ica,type_recording,'/data_after_ica.mat'],'data_after_ica');
%     end
% else
%         load([path_data_after_ica,type_recording,'/data_after_ica.mat']);
%         dataAfterIca = [dataAfterIca ; data_after_ica];
%         save([path_data_after_ica,type_recording,'/data_after_ica.mat'],'data_after_ica');
% end

