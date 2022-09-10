addpath('.','utils','*');
path_fieldtrip = fullfile('Y:\MylenaReis','Fieldtrip');
addpath(path_fieldtrip);
%load path to specific preprocessed_data
load('./Matrizes/path_preprocessed_data.mat');
load('./Matrizes/type_recording.mat');

load([path_preprocessed_data,type_recording,'\cell_data.mat']);
load([path_preprocessed_data,type_recording,'\names.mat']);
% cell_data = cell_data(11:end);
% names = names(11:end);
%Se arquivo preproc existir, carregar
%ou seja, qdo for rt ou rt_pos
% if char(type) ~= 'Benchmarck_raw'
if strcmp(type_recording,'Benchmark_raw') == 0 % se forem diferentes
    load([path_preprocessed_data,type_recording,'/preproc_data.mat']);
else
    % pasta dos arquivos preprocessados 
%     files = dir(['./Matrizes/Preprocessed_Data/',char(type),'/**/data_redef.mat']);
    files = dir([path_preprocessed_data,type_recording,'/']);
    flag_data = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..')
    preproc_data_files =  files(flag_data);
    preproc_data = struct2cell(preproc_data_files);
    preproc_data = preproc_data(1,:)';
end
preproc_data = preproc_data%(10:end);
%contador
i = num2cell(1:length(cell_data));

%For each preprocessed file of preproc_data
cellfun(@psd_analysis,cell_data,i',names,preproc_data);

disp('. ');
disp('. ');
disp('. ');
disp('. ');
disp('. ');
disp('---------------------------------------------------------------------- ');
disp('-------------------- Fim do cálculo da PSD --------------------------- ');
disp('---------------------------------------------------------------------- ');