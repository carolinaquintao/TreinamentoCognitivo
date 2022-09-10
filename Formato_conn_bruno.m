%% Conn por min nos 60 minutos, organizadas  em 171 x 60 x 27 ( pares  x min x frequencias ) 

%Seguindo a mesma ordem que no PSD 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

path_conn = '..\ConectCompArtigo\Matrizes\Connectivity\Benchmark_raw\';

%Get names from folder 
[names_list] = getNamesFromFolder(path_conn,'*');

%Excluindo IPM primeiro dia 
names_list(10) = []; %1 x 22

%% Organizar arquivos como Bruno pediu 

%     for j = 1:length(mental_states) %2
for i = 10:length(names_list)  %12
    disp(['Suj ',num2str(i)]);
        for j =1:60 %Para cada minuto
            disp(['Min ',num2str(j)]);
                for l = 1:length(freqbdw) %bdw % 7 
%                   disp(['Freq ',num2str(l)]);
                    %Var com structs 
                    conn_matrix_permin0{i,j} = load([path_conn,names_list{i}(1:10),'/freqAnalysis/wpli_debiased/conn_data_cell.mat']);
                    %Var com matrizes de conn para um mesmo sujeito 
                    conn_matrix_permin{i,j} = conn_matrix_permin0{i,j}.conn_data_cell{j,1}.wpli_debiasedspctrm;
                    helper0{i,j} = conn_matrix_permin0{i,j}.conn_data_cell{j,1}.wpli_debiasedspctrm;
                    
                    conn_matrix_freq_permin{i,l,j} = conn_matrix_permin{i,j}(:,:,eval(freqbdw{l})); %Suj x bdw x min {19 x 19 x freq}
                end
        end
            
            %Contador para ordenar a matriz para concatenacao 
%             x = 1:2:60;% Para os 60 minutos 
%             for ix = 1:length(x)
%                 helper = cat(4,helper0{x(ix)},helper0{x(ix)+1});  
%             end

            % conn_matrix_permin{j,k} = helper; %deve ser utilizado nos proximos passos
%             clear helper;
end

 disp('Geracao de matrix ok');   

%% 

%Agrupando frequencias 
for i = 1:length(names_list) % i = 1:25
    for l = 1:length(freqbdw) %bdw (7) 
        for j = 1:60 %min
%         conn_matrix_perfreq_mean3i{i,l} = conn_matrix_mean3i{i}(:,:,eval(freqbdw{l}));
%         conn_matrix_perfreq_mean3f{i,l} = conn_matrix_mean3f{i}(:,:,eval(freqbdw{l}));
          conn_matrix_perfreq{i,l,j} = conn_matrix_freq_permin{i,l,j}; %23 x 7 {19 x 19  x freq}
        end
    end
end

%% Selecionado apenas as frequencias de interesse (alfa, teta e beta) e Reorganizando os dados de cell para arrays 
%Organizando para 27 frequencias 

for i = 1:length(names_list) % i = 1:25
    for j = 1:60 %min
        conn_matrix_TetaAlfaBeta{i,j} = cat(3,conn_matrix_perfreq{i,3,j},conn_matrix_perfreq{i,1,j}(:,:,2:end),conn_matrix_perfreq{i,2,j}(:,:,2:end)); %1 x 23 { 19 x 19 x 27}
    end
end

%% Reorganizando os dados de (19 x 19 x 27)   para  (171 x 27)
% 
% for i = 1:3 %grupo
%     for j = 1:size(v_grupos_idx{i},2) %sujeitos
    for i = 1:length(names_list)
        for j = 1:60 %min
             for k = 1:size(conn_matrix_TetaAlfaBeta{1,1},3) %27 frequencias
                  conn_vector_permin_60min{i,1}(:,j,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta{i,j}(:,:,k)));

             end
        end
    end
% end