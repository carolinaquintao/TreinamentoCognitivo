%Script para plotar as amplitudes do sinal EEG por segundo

% Load from datapreprocessed data 

path_files = '../ConectCompArtigo/Matrizes/Preprocessed_Data/Benchmark_raw/';

% stringToFind = '*';

%Get names from folder 
[names_list] = getNamesFromFolder(path_files,'*');

mkdir('./Matrizes/AmplitudesS11D/');

%% Em cada pasta, ha um arquivo chamado data_redef que possui uma sytruct com
%os dados preprocessados 

for i = 11:length(names_list)

        load([path_files,names_list{i},'/data_redef.mat'],'trial');
        
        %Verificando tamanho de trials 
        if length(trial) < 3600 %Se menor que 1hr
            disp(['Sujeito ',names_list{i},' com menos de 1hrs ']);
            time = 3000/60;
            data_amplitude0 = reshape(trial(1:3000),[60,50]); %Ate 50 minutos 
            names_list{i} = [names_list{i}(1:6),'_50min'];
        else
        
            data_amplitude0 = reshape(trial(1:3600),[60,60]); %Ate 60 minutos 
            time = 3600/60;
        end
        
    for j = 1:time %de 60 em 60 segundos ...
%         data_amplitude{j,1} = data_amplitude0(:,j);
        data_amplitude{j,1} = cat(3,data_amplitude0{:,j});
    end
    save(['./Matrizes/AmplitudesS11D/','data_amplitude_',names_list{i}(1:12)],'data_amplitude');
    
    %Limpa variavel com valores ordenados segundo ch x amostras x segundo
    clear data_amplitude; 

    %Limpa variavel com cell 60x60 corresponde aos valores por minuto em
    %segundos, durante 1 hora
    clear data_amplitude0; 

end

%%
A = [1 2 3;
     4 5 6;
     7 8 9];
 
B = [1 2 3;
     4 5 6;
     7 8 9];
 
%  out = cellfun(@(x,y,z)(x.*y.*z),A(:,1),A(:,2),A(:,3),'UniformOutput',false)
 
 %%
% A2 = cell2mat(arrayfun(@(x) mean(A(x,:)), 1:size(A,2), 'un',0));
arrayfun(@(x,y) mean(A(x,:)), mean(B(y,:)), 'un',0)