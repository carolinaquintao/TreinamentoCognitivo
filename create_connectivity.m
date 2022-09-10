addpath('./utils/');
addpath('./regions/');
addpath('./othercolor/');

load('./Matrizes/cell_data.mat');
load('./Matrizes/names.mat');
if exist('./Matrizes/x0.mat') && exist('./Matrizes/x.mat')
    
   prompt00 = 'Arquivos de verificação de tipo de freq analysis e trials x e x0 presentes. \n [1] Excluir arquivos? \n [2] Ignorar e prosseguir. \n';
        x00 = input(prompt00);
        
        if x00 == 1
            disp('');
            disp('----------------------------------- ');
            disp('Deletando arquivos ... ');
            disp('----------------------------------- ');
            disp('');
            
            delete('./Matrizes/x.mat');
            delete('./Matrizes/x0.mat');
            delete('./Matrizes/vx1.mat');
%           delete('ResultFile.txt');
        else
            disp('');
            disp('----------------------------------- ');
            disp('Prosseguindo ... ');
            disp('----------------------------------- ');
            disp('');
        end
end
path_fieldtrip = fullfile('Y:\MylenaReis','Fieldtrip');
addpath(path_fieldtrip);
%contador
i = num2cell(1:length(cell_data));

% Carregando de  arquivos ja salvos (dataAfterIca)
% for i = 1:length(cell_data)
%     %Getting the name of file
%     [filepath,filename,ext] = fileparts(cell_data{i});
%     disp('--------------------------------------------');
%     disp(['Sujeito ',num2str(i),'.']); 
%     disp('--------------------------------------------');
%     connectivity(i,filename)
% end

cellfun(@connectivity,cell_data,i',names);


%TODO - Colocar aqui para varrer names e cell_data com devido caminho


 % Script para calculo do wilcoxon 
disp('. ');
disp('. ');
disp('. ');
disp('. ');
disp('. ');
disp('---------------------------------------------------------------------- ');
disp('Fim do cálculo dos dados de conectividade ... ');
disp('---------------------------------------------------------------------- ');
% disp('. ');
% disp('. ');
% disp('. ');
% disp('. ');
% disp('. ');
% disp('---------------------------------------------------------------------- ');
% disp('Calculando Diferença significativa nos dados ... ');
% disp('---------------------------------------------------------------------- ');
% wilcoxon
     