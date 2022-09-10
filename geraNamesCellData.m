

path_data = 'Y:\TreinamentoCognitivo\Coletas\S11D-10-14-Fev-2020\';%Depois Grupo controle
% path_data = 'Y:\TreinamentoCognitivo\Coletas\S11D-27-31-Jan-2020\';%Antes Grupo controle
% 
% path_data = 'Y:\TreinamentoCognitivo\Coletas\S11D-02-05Sept_2019\';%Antes Grupo treinado
% path_data = 'Y:\TreinamentoCognitivo\Coletas\S11D-16-20Sept-2019\';%Depois Grupo treinado 1a semana


ext_files = 'edf';%s11d

% Name of file 
namefile = [];

%Calling function to get path data of all files, formating it in a cell
%and also get the name of each subject
[old_cell_data,~] = format_data(path_data,namefile,ext_files);
%Selecting type of data
[cell_data,names,~] = select_type(old_cell_data,ext_files)

% path_data = 'Y:\TreinamentoCognitivo\Coletas\S11D-01-04-Oct-2019\';%Depois Grupo treinado 2a semana
% [old_cell_data,~] = format_data(path_data,namefile,ext_files);
% %Selecting type of data
% [cell_data2,names2,~] = select_type(old_cell_data,ext_files)
% 
% cell_data = [cell_data1;cell_data2]
% names = [names1;names2];

save('cell_data.mat','cell_data')
save('names.mat','names')