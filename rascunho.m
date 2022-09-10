%Criando matriz psd por grupo 

%loading psd matrix 
%rt
load('Y:\code\ProjetosDeArtigos\RecoveredArticleComp\S11D\PSD_S11D\RT\psd_matrix.mat')

%States 
v_recording = {'RT','RT_posBench','Benchmark'};

%Taking name of subjects 
path_psd = ('./S11D/PSD_S11D/RT/');
% path_psd = ('./S11D/PSD_S11D/RT_posBench/');
% path_psd = ('./S11D/PSD_S11D/Benchmark/');

var_subjects_psd = getNamesFromFolder(path_psd,'*');
%% Formatacao kdmile

%Selecao de pares de canais corr e significancia 

%conn_matrix_permin {12,2,5}{30,30,103}

freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%orden corr+N>F, corr+F>N, corr-N>F, corr-F>N
%Empregando o v_comb_selec_ch

% selected_chfreq_corrsig = cell(5,12,2,2,24);

%% chinesa

% v_comb_selec_semNull = v_comb_selec_ch(1,:);
% v_comb_selec_semNull = v_comb_selec_ch(3,:);
contador_selected_chfreq_corrsig = ~cellfun('isempty',v_comb_selec_semNull);

for i = 1:5 %minutos
    for k = 1:12 %sujeitos
        for l = 1:2 %mental states
            for j = 1 %4 scenarios de corr , mas apenas 2 apresentaram valores nao nulos  tambem servira para frequencia
%                 for m = 1:length(freqbdw(selec_freq{j}))%para cada uma das frequencias selecionadas
%                     for m = 1; %corr+N>F
%                     for m = 2 %corr - N>F

                  for m = 1:nnz(contador_selected_chfreq_corrsig(j,:))%para cada uma das frequencias selecionadas
%                 for m = 1:length(v_comb_selec_semNull)
                    %                     selected_chfreq_corrsig{i,k,j,m} = mean(conn_matrix_permin{k,l,i}(selec_ch{j},:, str2num(cell2mat(freqbdw(selec_freq{j}(m))))),3)
                    
                    %                       selected_chfreq_corrsig{i,k,l,j} = mean(conn_matrix_permin{k,l,i}(v_comb_selec_ch{j}(2),v_comb_selec_ch{j}(3),str2num(cell2mat(freqbdw(v_comb_selec_ch{j}(1))))),3);
%                     if j == 1
                        selected_corrPos_NF{i,k,l,m} = mean(conn_matrix_permin{k,l,i}( v_comb_selec_semNull{j,m}(2), v_comb_selec_semNull{j,m}(3),str2num(cell2mat(freqbdw( v_comb_selec_semNull{j,m}(1))))),3);
%                     else
%                         selected_corrNeg_NF{i,k,l,m} = mean(conn_matrix_permin{k,l,i}( v_comb_selec_semNull{j,m}(2), v_comb_selec_semNull{j,m}(3),str2num(cell2mat(freqbdw( v_comb_selec_semNull{j,m}(1))))),3);
%                     end
                  end
            end
        end
    end
end
disp('ok');

%% s11d

% v_comb_selec_semNull = v_comb_selec_ch_s11d_corrPos;
% v_comb_selec_semNull = v_comb_selec_ch_s11d_corrNeg;
contador_selected_chfreq_corrsig = ~cellfun('isempty',v_comb_selec_semNull);

for i = 1:3 %minutos
    for k = 1:25 %sujeitos
        for l = 1:2 %mental states
            for j = 1 %4 scenarios de corr , mas apenas 2 apresentaram valores nao nulos  tambem servira para frequencia
%                 for m = 1:length(freqbdw(selec_freq{j}))%para cada uma das frequencias selecionadas
%                     for m = 1; %corr+N>F
%                     for m = 2 %corr - N>F

                  for m = 1:nnz(contador_selected_chfreq_corrsig(j,:))%para cada uma das frequencias selecionadas
%                 for m = 1:length(v_comb_selec_semNull)
                    %                     selected_chfreq_corrsig{i,k,j,m} = mean(conn_matrix_permin{k,l,i}(selec_ch{j},:, str2num(cell2mat(freqbdw(selec_freq{j}(m))))),3)
                    
                    %                       selected_chfreq_corrsig{i,k,l,j} = mean(conn_matrix_permin{k,l,i}(v_comb_selec_ch{j}(2),v_comb_selec_ch{j}(3),str2num(cell2mat(freqbdw(v_comb_selec_ch{j}(1))))),3);
%                     if j == 1
%                         selected_corrPos_NF_s11d{i,k,l,m} = mean(conn_matrix_permin_s11d{k,l,i}( v_comb_selec_semNull{j,m}(2), v_comb_selec_semNull{j,m}(3),str2num(cell2mat(freqbdw( v_comb_selec_semNull{j,m}(1))))),3);
%                     else
                        selected_corrNeg_NF_s11d{i,k,l,m} = mean(conn_matrix_permin_s11d{k,l,i}( v_comb_selec_semNull{j,m}(2), v_comb_selec_semNull{j,m}(3),str2num(cell2mat(freqbdw( v_comb_selec_semNull{j,m}(1))))),3);
%                     end
                                         end
            end
        end
    end
end
disp('ok');

%% Sem selecao de canal
%s11d
for i = 1:3 %minutos
    for k = 1:25 %sujeitos
        for l = 1:2 %mental states
            for m = 1:172 %frequencias 
%            
                    no_selected_s11d{i,k,l} = nonzeros(tril(conn_matrix_permin_s11d{k,l,i}(:,:,m)))
                   
            end
        end
    end
end

 no_selected_s11d = reshape(cell2mat(no_selected_s11d),[3,50,171])
 
 
 %% chinesa
%  for i = 1:5 %minutos
for i = 1:7 %frequencies bdw
    for k = 1:12 %sujeitos
        for l = 1:2 %mental states
%             for m = 1:103 %frequencias 
 
%                     no_selected_chin{i,k,l} = nonzeros(tril(conn_matrix_permin{k,l,i}(:,:,m)))
                      no_selected_chin_permin{i,j,k} = nonzeros(tril(conn_matrix{k,l,i}))
%             end
        end
    end
 end
  
%   no_selected_chin = reshape(cell2mat( no_selected_chin),[5,24,435]);

  
%% Reordenando os arquivos selected_corrPos_NF e selected_corrNeg_NF para 
% De 5 x 12 x 2 x 24 para  5 x 24 x 24
% De 5 x 12 x 2 x 7 para  5 x 24 x 7

selected_corrPos_NF_s11d = cell2mat(selected_corrPos_NF_s11d);
selected_corrPos_NF_s11d = reshape(selected_corrPos_NF_s11d,[3,50,size(selected_corrPos_NF_s11d,4)]);

selected_corrNeg_NF_s11d = cell2mat(selected_corrNeg_NF_s11d);
selected_corrNeg_NF_s11d = reshape(selected_corrNeg_NF_s11d,[3,50,size(selected_corrNeg_NF_s11d,4)]);

save([path_conn,'selected_corrPos_NF_s11d.mat'],'selected_corrPos_NF_s11d');
save([path_conn,'selected_corrNeg_NF_s11d.mat'],'selected_corrNeg_NF_s11d');

%% Reordenando os arquivos selected_corrPos_NF e selected_corrNeg_NF para 
% De 5 x 12 x 2 x 24 para  5 x 24 x 24
% De 5 x 12 x 2 x 7 para  5 x 24 x 7

selected_corrPos_NF = cell2mat(selected_corrPos_NF);
selected_corrPos_NF = reshape(selected_corrPos_NF,[5,24,size(selected_corrPos_NF,4)]);

selected_corrNeg_NF = cell2mat(selected_corrNeg_NF);
selected_corrNeg_NF = reshape(selected_corrNeg_NF,[5,24,size(selected_corrNeg_NF,4)]);

save([path_conn,'selected_corrPos_NF.mat'],'selected_corrPos_NF');
save([path_conn,'selected_corrNeg_NF.mat'],'selected_corrNeg_NF');

%% Removing channels that are not present in s11d
a = 2*(~eye(4,4))
a(2,:) = [];
a(:,2) = [];

% a = mean(conn_matrix_freq{1,1,1},3)

%Chanels to remove 
ch_to_remove = flip([8:12,18:22,29]); %decrescente
%%
for i = 1:7 %frequencies
    for j = 1:12 %sujeitos
        for k = 1:size(ch_to_remove,2)
            con_fat0{i}{j}(ch_to_remove(k),:) = [];
            con_fat0{i}{j}(:, ch_to_remove(k)) = [];
            
            con_nor0{i}{j}(ch_to_remove(k),:) = [];
            con_nor0{i}{j}(:, ch_to_remove(k)) = [];
%             a(ch_to_remove(i),:) = [];
%             a(:, ch_to_remove(i)) = [];
        end
    end
end

%% s11d - todos os sujeitos
%load conn_matrix_freq_permin3i %4d (25 x 1 x 13 x 3 ) ( subj x mental
%state x frequency x minutes)

for i = 1:25
    for j = 1:7
        for k = 1:3
            a{i,1,j,k} = mean(conn_matrix_freq_permin3i{i,1,j,k},3); %Mean nas frequencias  
            b{i,1,j,k} = mean(conn_matrix_freq_permin3f{i,1,j,k},3); %Mean nas frequencias   
        end
        conn_matrix_3i_s11d{i,1,j}  = permute(cell2mat(a(i,1,j,:)),[1,2,4,3]);
        conn_matrix_3f_s11d{i,1,j}  = permute(cell2mat(b(i,1,j,:)),[1,2,4,3]);
   end
end
clear a;
clear b;

save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_3i_s11d.mat','conn_matrix_3i_s11d');
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_3f_s11d.mat','conn_matrix_3f_s11d');


%% s11d - por grupo de desempenho 

idx_e = [6,5,2,7,16,19,20,13,18,23];
idx_b = [4,14,21,24,1,25,9];
idx_r = [8,15,17,3,11];
% idx_r = [3,10,11,12]; %Com FFS

%Vetor de sujeitos 
v_grupos_idx = {idx_e,idx_b,idx_r};


for i = 1:3 %Para cada grupo de desempenho
    for ii = 1:length(v_grupos_idx{i}) %para quantidade de cada grupo
        for j = 1:7 %frequencias
            for k = 1:3 %minutos
                
                a{i}{ii,1,j,k} =  mean(conn_matrix_freq_permin3i{v_grupos_idx{i}(ii),1,j,k},3); %Mean nas frequencias
                b{i}{ii,1,j,k} =  mean(conn_matrix_freq_permin3f{v_grupos_idx{i}(ii),1,j,k},3); %Mean nas frequencias
            end
            %             conn_matrix_3f_s11d{i,1,j}  = permute(cell2mat(b(i,1,j,:)),[1,2,4,3]);
            conn_matrix_3i_s11d_groups{i}{ii,1,j}  = permute(cell2mat(a{i}(ii,1,j,:)),[1,2,4,3]);
            conn_matrix_3f_s11d_groups{i}{ii,1,j}  = permute(cell2mat(b{i}(ii,1,j,:)),[1,2,4,3]);
        end
    end
%     conn_matrix_3i_s11d_groups{i}{ii,1,j}  = permute(cell2mat(a{i}(ii,1,j,:)),[1,2,4,3]);
end
clear a;
clear b;

save([path_conn,'conn_matrix_3i_s11d_groups.mat'],'conn_matrix_3i_s11d_groups');
save([path_conn,'conn_matrix_3f_s11d_groups.mat'],'conn_matrix_3f_s11d_groups');

%% Taking the mean of subjects from conn_matrix (s11d)
%This is necessary to take the max and minimum value to normalize plots 

%todos os sujeitos
    for j = 1:7 %bandas de frequencias
        % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
        MeanC_3i_s11d{i,j} = mean(cat(3, conn_matrix_3i_s11d{:,1,j}),3); %Mean of all subjects in all 3 minutes
        MeanC_3f_s11d{i,j} = mean(cat(3, conn_matrix_3f_s11d{:,1,j}),3); %Mean of all subjects in all 3 minutes

    end
    

%% Por grupo

for i = 1:3 %grupos
%     for ii = 1:length(v_grupos_idx{i}) %para quantidade de cada grupo
        for j = 1:7 %bandas de frequencias
            % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
            MeanC_3i_s11d_groups{i}{1,j} = mean(cat(3, conn_matrix_3i_s11d_groups{i}{:,1,j}),3); %Mean of all subjects in all 5 minutes
            %         MeanC_cat_3i_s11d{1,j,k} = cat(3, conn_matrix_3i_s11d{:,i,j});
            
            MeanC_3f_s11d_groups{i}{1,j} = mean(cat(3, conn_matrix_3f_s11d_groups{i}{:,1,j}),3); %Mean of all subjects in all 5 minutes
            %         MeanC_cat_3f_s11d{1,j,k} = cat(3, conn_matrix_3f_s11d{:,i,j});
            
        end
%     end
end


% save('./S11D/Ocorrencia/MeanC_cat_3i_s11d.mat','MeanC_cat_3i_s11d');
save('./S11D/Ocorrencia/MeanC_3i_s11d_groups.mat','MeanC_3i_s11d_groups');

% save('./Matrizes/Ocorrencia/MeanC_cat_3f_s11d.mat','MeanC_cat_3f_s11d');
save('./Matrizes/Ocorrencia/MeanC_3f_s11d_groups.mat','MeanC_3f_s11d_groups');

%% Formatacao kdmile 2 
% criando matriz com  a soma de todas da conectividade em todos os pares de
% um canal 

%carregando conn para todos os suj em um estado mental e em uma banda 
%  a = conn_matrix_freq(:,1,1); 

%tirando a media nas frequencias 
% a2 = cellfun(@(x) mean(x,3) ,a,'un',0);

% a2 = cellfun(@(x) mean(x,3) ,conn_matrix_freq(:,1,1),'un',0); %12 x 1 [30x30]

%Para cada frequencia 
%Provavelmente os valores aqui estao seno influenciados pela media,
%portanto os valores com  MeanC estao sendo testados
for i = 1:7
    
%     %Chinesa
%     con_fat0{i} = cellfun(@(x) mean(x,3) ,conn_matrix_freq(:,1,i),'un',0); %12 x 7 [30x30]
%     con_nor0{i} = cellfun(@(x) mean(x,3)
%     ,conn_matrix_freq(:,2,i),'un',0); %12 x 7 [30x30]
      
%     
%     %mean of all subjects
%     con_fat1{i} = mean(reshape(cell2mat(con_fat0{i}),[30,30,12]),3); %1 x 7 [30x30]
%     con_nor1{i} = mean(reshape(cell2mat(con_nor0{i}),[30,30,12]),3); %1 x 7 [30x30]

%     S11d
    con_fat0{i} = cellfun(@(x) mean(x,3) , permute(conn_matrix_3f(:,:,i),[1,3,2]),'un',0); %12 x 7 [30x30]
    con_nor0{i} = cellfun(@(x) mean(x,3) , permute(conn_matrix_3i(:,:,i),[1,3,2]),'un',0); %12 x 7 [30x30]
    
%     %mean of all subjects
    con_fat1{i} = mean(reshape(cell2mat(con_fat0{i}),[19,19,25]),3); %12 x 7 [30x30]
    con_nor1{i} = mean(reshape(cell2mat(con_nor0{i}),[19,19,25]),3); %12 x 7 [30x30]
end

%Chinesa
con_fat1 = MeanC(1,:);
con_nor1 = MeanC(2,:);

%s11d
con_fat1 = MeanC_3f_s11d;
con_nor1 = MeanC_3i_s11d;

%s11d groups
con_fat1_groups = MeanC_3f_s11d_groups;
con_nor1_groups = MeanC_3i_s11d_groups;


path_conn = ('./Chinesa/Matrizes/Ocorrencia/');%Chinesa
% path_conn = ('./S11D/Ocorrencia/'); %S11D
save([path_conn,'con_fat0.mat'],'con_fat0');
save([path_conn,'con_nor0.mat'],'con_nor0');

save([path_conn,'con_fat1.mat'],'con_fat1');
save([path_conn,'con_nor1.mat'],'con_nor1');

%% Ploting selected chanels from v_comb_selec_ch_label with con_fat0

%Selecionando pares de canais existentes em s11d 
%Corr+
% v_comb_selec_ch_s11d_corrPos_label = [v_comb_selec_ch_label(1,3),v_comb_selec_ch_label(1,4),v_comb_selec_ch_label(1,5),v_comb_selec_ch_label(1,12),v_comb_selec_ch_label(1,13)...
%    v_comb_selec_ch_label(1,22),v_comb_selec_ch_label(1,23),v_comb_selec_ch_label(1,24)];
%'C3-C4-alfa1'	'T3-T4-beta2'	'FP1-P3-beta1'	'FP2-P3-beta1'	'F8-P3-beta1'	'P4-P3-beta1'	'F3-P3-beta2'	'PZ-P3-beta2'	'P4-P3-beta2'	'T3-O2-beta1'	

v_comb_selec_ch_s11d_corrPos = {[4 2 6],[7 11 18],[6 9 1],[6 10 1],[6 16 1],[6 7 1],[7 3 1],[7 1 19],[7 1 7]};

%Corr-
% v_comb_selec_ch_s11d_corrNeg_label = [v_comb_selec_ch_label(3,2),v_comb_selec_ch_label(3,3),v_comb_selec_ch_label(3,4),v_comb_selec_ch_label(3,5),v_comb_selec_ch_label(3,7)];
% 'C4-F7-beta'	'C4-F7-beta2'	'PZ-F7-beta2'	'P4-F7-beta2'	'F3-F8-beta'	'CZ-F8-beta1'	'P3-F8-beta1'	'F4-CZ-beta1'	'F8-CZ-beta1'	'C3-C4-alfa1'	'F7-C4-beta2'	'T6-C4-beta2'

v_comb_selec_ch_s11d_corrNeg = {[2 6 15],[7 6 15],[7 19 15],[7 7 15],[2 3 16],[6 8 16],[6 1 16],[6 5 8],[6 16 8],[4 2 6],[7 15 6],[7 17 6]};

%Para corr+N>F

%Chinesa
for i = 1:27 %Para cada par e frequencia selecionado v_comb_selec_ch{1}
        fat_select_ch_corrPos_nf(i) = con_fat1{v_comb_selec_ch{1,i}(1)}(v_comb_selec_ch{1,i}(2),v_comb_selec_ch{1,i}(3));
        nor_select_ch_corrPos_nf(i) = con_nor1{v_comb_selec_ch{1,i}(1)}(v_comb_selec_ch{1,i}(2),v_comb_selec_ch{1,i}(3));
end
for i = 1:20 %Para cada par e frequencia selecionado v_comb_selec_ch{3}
        fat_select_ch_corrNeg_nf(i) = con_fat1{v_comb_selec_ch{3,i}(1)}(v_comb_selec_ch{3,i}(2),v_comb_selec_ch{3,i}(3));
        nor_select_ch_corrNeg_nf(i) = con_nor1{v_comb_selec_ch{3,i}(1)}(v_comb_selec_ch{3,i}(2),v_comb_selec_ch{3,i}(3));
end

%Para os canais que existem na chinesa em s11d 
for i = 1:size(v_comb_selec_ch_s11d_corrPos,2) %Para cada par e frequencia selecionado v_comb_selec_ch{1}
        fat_select_ch_corrPos_nf_s11d(i) = con_fat1{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
        nor_select_ch_corrPos_nf_s11d(i) = con_nor1{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
end
for i = 1:size(v_comb_selec_ch_s11d_corrNeg,2) %Para cada par e frequencia selecionado v_comb_selec_ch{3}
        fat_select_ch_corrNeg_nf_s11d(i) = con_fat1{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
        nor_select_ch_corrNeg_nf_s11d(i) = con_nor1{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
end

%S11d Por grupo 
for j = 1:3 %para cada grupo
    for i = 1:size(v_comb_selec_ch_s11d_corrPos,2) %Para cada par e frequencia selecionado v_comb_selec_ch{1}
        fat_select_ch_corrPos_nf_s11d_groups{j}(i) = con_fat1_groups{j}{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
        nor_select_ch_corrPos_nf_s11d_groups{j}(i) = con_nor1_groups{j}{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
    end
    for i = 1:size(v_comb_selec_ch_s11d_corrNeg,2) %Para cada par e frequencia selecionado v_comb_selec_ch{3}
        fat_select_ch_corrNeg_nf_s11d_groups{j}(i) = con_fat1_groups{j}{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
        nor_select_ch_corrNeg_nf_s11d_groups{j}(i) = con_nor1_groups{j}{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
    end
end

% for i = 1:size(v_comb_selec_ch_s11d_corrPos,2) %Para cada par e frequencia selecionado v_comb_selec_ch{1}
%     
%         allsubj_3f_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
%         allsubj_3i_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
% 
%         e_3f_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_e{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
%         e_3i_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_e{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
% 
%         b_3f_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_b{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
%         b_3i_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_b{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
% 
%         r_3f_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_r{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
%         r_3i_select_ch_corrPos_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_r{v_comb_selec_ch_s11d_corrPos{i}(1)}(v_comb_selec_ch_s11d_corrPos{i}(2),v_comb_selec_ch_s11d_corrPos{i}(3));
% 
% end
% 
% for i = 1:size(v_comb_selec_ch_s11d_corrNeg,2) %Para cada par e frequencia selecionado v_comb_selec_ch{3}
%        
%         allsubj_3f_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_e{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
%         allsubj_3i_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_e{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
%     
%         e_3f_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_e{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
%         e_3i_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_e{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
% 
%         b_3f_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_b{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
%         b_3i_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_b{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
% 
%         r_3f_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3f_r{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
%         r_3i_select_ch_corrNeg_nf_s11d(i) = conn_matrix_meanfreq_meansubj_3i_r{v_comb_selec_ch_s11d_corrNeg{i}(1)}(v_comb_selec_ch_s11d_corrNeg{i}(2),v_comb_selec_ch_s11d_corrNeg{i}(3));
% 
% end


%Corr Pos
xlswrite([path_conn,'fat_select_ch_corrPos_nf.xlsx'],fat_select_ch_corrPos_nf_s11d)
xlswrite([path_conn,'nor_select_ch_corrPos_nf.xlsx'],nor_select_ch_corrPos_nf_s11d)
%Corr Neg
xlswrite([path_conn,'fat_select_ch_corrNeg_nf.xlsx'],fat_select_ch_corrNeg_nf_s11d)
xlswrite([path_conn,'nor_select_ch_corrNeg_nf.xlsx'],nor_select_ch_corrNeg_nf_s11d)

% figure;bar([a;b]','stacked')
% figure;bar([a;b]');
%%
for w = 1:7 %para cada frequencia
    for i = 1:length(con_fat0{1}) %sujeitos   
        for j = 1:length(con_fat0{1}{1}) %para cada um dos canais
%             a3{i,1} = sum(a2{i}(:,j))
              con_fat_meanpairs_persub{i,j,w} = sum(con_fat0{w}{i}(:,j));
              con_nor_meanpairs_persub{i,j,w} = sum(con_nor0{w}{i}(:,j));
        end
    end
end

%% Wilcoxon 
        
for i = 1:length(con_fat0{1}{1}) %para cada um dos canais
    for j= 1:7 %Para cada frequencia
        %            p_teste{i,j} = ranksum(MeanC{1,i}(j,:),MeanC{2,i}(j,:),'tail','right'); % Fadigado - Normal
        % hipotese: conn Norm > conn Fad
        % Os valores em h2, se 1 , representam qdo a hipotese foi
        % alcancada
        [ p_val_nf{i,j},hip_nf{i,j}] = ranksum(cell2mat(con_fat_meanpairs_persub(:,i,j)),cell2mat(con_nor_meanpairs_persub(:,i,j)),'tail','left'); %  Normal > Fadigado ***
        [ p_val_fn{i,j},hip_fn{i,j}] = ranksum(cell2mat(con_fat_meanpairs_persub(:,i,j)),cell2mat(con_nor_meanpairs_persub(:,i,j)),'tail','right'); % Fadigado > Normal ***
    end
end

%%

X = randn(30,4);
Y = randn(30,1);

[rho,~] = corr(Y,X)

%Correlacao calculada cada elemento 
%% Index of groups

%Carrega nomes
load('./Matrizes/namesSet18.mat');

%indices de sujeitos de um grupo 
idx_e = [2,5,6,7,13,16,18,19,20];
idx_b = [1,4,8,9,14,15,17,22,21,23,24,25];
idx_r = [3,11,12];
% idx_r = [3,10,11,12]; %Com FFS

%Vetor de sujeitos 
v_grupos_idx = {idx_e,idx_b,idx_r};

%Mean in time 
% psd_matrix_rt = cellfun(@(x) mean(x,2), psd_matrix_rt,'un',0);
% psd_matrix_rtPos = cellfun(@(x) mean(x,2),psd_matrix_rtPos,'un',0);
% psd_matrix_bench_all = cellfun(@(x) mean(x,2),psd_matrix,'un',0);

%psd_matrix_rt_perfreq = psd_matrix_perfreq;

% var com valores de psd por grupo
% psd_matrix_perfreq_pergroup_meansubj loaded from s11d/psd

psd_matrix_perfreq_pergroup_meansubj_rt = psd_matrix_perfreq_pergroup_meansubj;
psd_matrix_perfreq_pergroup_meansubj_Posrt = psd_matrix_perfreq_pergroup_meansubj;

psd_matrix_perfreq_pergroup_meansubj_bench_3i = psd_matrix_perfreq_pergroup_meansubj_3i;
psd_matrix_perfreq_pergroup_meansubj_bench_3f = psd_matrix_perfreq_pergroup_meansubj_3f;

%Mean of subject for each group 
psd_matrix_rt_meansubj_groups = cellfun(@(x) cell2mat(x),psd_matrix_rt_groups(1),'un',0);
psd_matrix_rtPos_meansubj_groups = cellfun(@(x) mean(x), psd_matrix_rtPos_groups,'un',0);


%% Plotting psd

%Vetor de coletas
v_coletas = {psd_matrix_perfreq_pergroup_meansubj_rt ,psd_matrix_perfreq_pergroup_meansubj_Posrt,...
    psd_matrix_perfreq_pergroup_meansubj_bench_3i,psd_matrix_perfreq_pergroup_meansubj_bench_3f};

freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};
 
 %Vetor de sujeitos 
v_grupos= {'e','b','r'};

v_coletas_label = {'Rt','RTPos','Bench_3i','Bench_3F'};

%Creating folder of images 
mkdir('./S11D/Images/');

%Concatenating frequencies values to plot from 2 to 30 (just teta, alpha,
%beta)

for i = 1:length(v_coletas)
   for  j = 1:3 %group
     concat_v_coletas{j,i} = [v_coletas{i}{3,j},v_coletas{i}{1,j},v_coletas{i}{2,j}];
   end
end

%Mean of all channels
concat_v_coletas_mean_ch = cellfun(@(x) mean(x,1), concat_v_coletas,'un',0);
concat_v_coletas_mean_ch = cellfun(@(x) permute(x,[2,1]),concat_v_coletas_mean_ch,'un',0);

%%
for i0 = 1:length(v_coletas) %Tipo da coleta (rt-rtPos-bench3i-bench3f)
    for j = 1:3 % groups E-B-R
%         for i = 1:7 %frequencias        
            figure
            t = log(concat_v_coletas_mean_ch{j,i0});
            %     t = permute(mean(mean(ociptal_t_t,1),2),[2,3,1]);
            plot([1:29],t);
%             title(['Grupo',v_grupos{j},' ',freqbdw_label{i},' ',freqbdw{i}],'interpreter', 'none');
            title(['Grupo ',v_grupos{j},' ',v_coletas_label{i0},' Mean all channels'],'interpreter', 'none');
%             xlim([4 30]);
            %patch to teta and alfa
            a = get(gca,'YLim');
            patch([4,8,8,4],[a(1),a(1),a(2),a(2)],[0.3,0.6,0.5],'FaceAlpha',.1,'EdgeColor','none');
            patch([8,12,12,8],[a(1),a(1),a(2),a(2)],'blue','FaceAlpha',.1,'EdgeColor','none');
            %legend('Min 1F','Min 1P','Min 2F','Min 2P','Min 3F','Min 3P');
            xlabel('Frequency (Hz)');
            ylabel('Power (log)');
%         end  

            %Saving
            disp('Saving Images');
            saveas(gcf,['./S11D/Images/','Grupo',v_grupos{j},v_coletas_label{i0},'Mean all channels'],'fig');
            saveas(gcf,['./S11D/Images/','Grupo',v_grupos{j},v_coletas_label{i0},'Mean all channels'],'png');
            close all;

    end
end

%% Hold on RT

    for j = 1:3 % groups E-B-R
%         for i = 1:7 %frequencias        
            figure
            t = log(concat_v_coletas_mean_ch{j,1}); %rt
            t2 = log(concat_v_coletas_mean_ch{j,2}); %rtPos
            %     t = permute(mean(mean(ociptal_t_t,1),2),[2,3,1]);
            plot([1:29],t);
            hold on;
            plot([1:29],t2);
            
%             title(['Grupo',v_grupos{j},' ',freqbdw_label{i},' ',freqbdw{i}],'interpreter', 'none');
            title(['Grupo ',v_grupos{j},'Rt Mean all channels'],'interpreter', 'none');
%             xlim([4 30]);
            %patch to teta and alfa
            a = get(gca,'YLim');
            patch([4,8,8,4],[a(1),a(1),a(2),a(2)],[0.3,0.6,0.5],'FaceAlpha',.1,'EdgeColor','none');
            patch([8,12,12,8],[a(1),a(1),a(2),a(2)],'blue','FaceAlpha',.1,'EdgeColor','none');
            legend('Rt','RtPos');
            xlabel('Frequency (Hz)');
            ylabel('Power (log)');
%         end  

            %Saving
            disp('Saving Images');
            saveas(gcf,['./S11D/Images/','Grupo',v_grupos{j},'Rt_Mean all channels'],'fig');
            saveas(gcf,['./S11D/Images/','Grupo',v_grupos{j},'Rt_Mean all channels'],'png');
            close all;

    end

    %% Hold on Bench 3i Bnech 3f

    for j = 1:3 % groups E-B-R
%         for i = 1:7 %frequencias        
            figure
            t = log(concat_v_coletas_mean_ch{j,3}); %3i
            t2 = log(concat_v_coletas_mean_ch{j,4}); %3f
            %     t = permute(mean(mean(ociptal_t_t,1),2),[2,3,1]);
            plot([1:29],t);
            hold on;
            plot([1:29],t2);
            
%             title(['Grupo',v_grupos{j},' ',freqbdw_label{i},' ',freqbdw{i}],'interpreter', 'none');
            title(['Grupo ',v_grupos{j},'Bench Mean all channels'],'interpreter', 'none');
%             xlim([4 30]);
            %patch to teta and alfa
            a = get(gca,'YLim');
            patch([4,8,8,4],[a(1),a(1),a(2),a(2)],[0.3,0.6,0.5],'FaceAlpha',.1,'EdgeColor','none');
            patch([8,12,12,8],[a(1),a(1),a(2),a(2)],'blue','FaceAlpha',.1,'EdgeColor','none');
            legend('3 min iniciais','3 min finais');
            xlabel('Frequency (Hz)');
            ylabel('Power (log)');
%         end  

            %Saving
            disp('Saving Images');
            saveas(gcf,['./S11D/Images/','Grupo',v_grupos{j},'Bench_Mean all channels'],'fig');
            saveas(gcf,['./S11D/Images/','Grupo',v_grupos{j},'Bench_Mean all channels'],'png');
            close all;

    end
    
    %% Heatmap 
    
for i0 = 1:length(v_coletas) %Tipo da coleta (rt-rtPos-bench3i-bench3f)
    for i = 1:3 %grupos
        figure
        heatmap(concat_v_coletas{i,i0},'YData',ch_label,'YLabel','Canais','XLabel','Frequencias(Hz)','GridVisible','off');
        
        %Saving
        disp('Saving Images');
        saveas(gcf,['./S11D/Images/','Heatmap_Grupo',v_grupos{i},v_coletas_label{i0},'Bench_Mean all channels'],'fig');
        saveas(gcf,['./S11D/Images/','Heatmap_Grupo',v_grupos{i},v_coletas_label{i0},'Bench_Mean all channels'],'png');
        close all;
        
    end

end

%% Max e mIN value 
a = cellfun(@(x) max(max(max(max(x)))),conn_matrix_freq_meansubj_rt,'un',0);
a2 = cell2mat(a);
max(max(max(a2)))
min(min(min(a2)))

clear a;
clear a2;
%%

% a = rand(3,3);
% a2 = a(a>.2);
% a2_pos = find(a>.2);

%weigths
a2 = find(weights{1}>0.017);
w2 = weights{1}(a2); 

%nodes 
t = pairs_cmb_idx(a2,:);

G2{1} = graph(t(:,1),t(:,2),w2{i});
% Line width with connectivity 
G2{1}.Edges.LWidths = 7*G2{1}.Edges.Weight/max(G2{1}.Edges.Weight);

%% figure
figure('Position',[100,100,600,700]);plot(G2{i},'NodeLabel',ch_label,'LineWidth',abs(G2{1}.Edges.LWidths),'XData',tx','YData',ty');
    title(['graph',' ',freqbdw_label{i},' ',v_conn_data_graph_analysis_label],'Interpreter','none');
    
    %%
%     conn_matrix_meanfreq_meansubj_3f_e
    
conn_matrix_freq_meansubj_meanMin_3f_e = conn_matrix_meanfreq_meansubj_3f_e;
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_freq_meansubj_meanMin_3f_e.mat','conn_matrix_freq_meansubj_meanMin_3f_e');

conn_matrix_meanfreq_meansubj_3f_e = cellfun(@(x) mean(x,3),conn_matrix_meanfreq_meansubj_3f_e,'un',0);
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_meanfreq_meansubj_3f_e.mat','conn_matrix_meanfreq_meansubj_3f_e');


%% Heatmap 

%Frequencias 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%% Reformatando as matrizes{25x7z3} para 25x3 de {19x19x29}

%conn_matrix_freq_permin % (25 x 1 x 7 x 3)
%conn_matrix_freq_permin_rt = permute(conn_matrix_freq_permin,[1,3,4,2]);
% conn_matrix_freq_3f_permin = permute(conn_matrix_3f_permin,[1,3,4,2]);
% conn_matrix_freq_3i_permin = permute(conn_matrix_3i_permin,[1,3,4,2]);

%Turning 4D to 3D to get mean of 3 min 
for i = 1:3 %time dimension  
%     a{i} = reshape(conn_matrix_freq_3i_permin(:,:,i),[25,7,i]);
      a{i} = conn_matrix_freq_3i_permin(:,:,i);
end

for i = 1:25 %sujeitos
    for j = 1:3%time
        % teta(4:8), alfa(9:15), beta(16:30)
        %rt
        conn_matrix_TetaAlfaBeta_permin_rt{i,j} = cat(3,conn_matrix_freq_permin_rt{i,3,j},conn_matrix_freq_permin_rt{i,1,j}(:,:,2:end),conn_matrix_freq_permin_rt{i,2,j}(:,:,2:end));
        conn_matrix_TetaAlfaBeta_permin_rtPos{i,j} = cat(3,conn_matrix_freq_permin_rtPos{i,3,j},conn_matrix_freq_permin_rtPos{i,1,j}(:,:,2:end),conn_matrix_freq_permin_rtPos{i,2,j}(:,:,2:end));
        %Bench
        conn_matrix_TetaAlfaBeta_permin_3i{i,j} = cat(3,conn_matrix_freq_3i_permin{i,3,j},conn_matrix_freq_3i_permin{i,1,j}(:,:,2:end),conn_matrix_freq_3i_permin{i,2,j}(:,:,2:end));
        conn_matrix_TetaAlfaBeta_permin_3f{i,j} = cat(3,conn_matrix_freq_3f_permin{i,3,j},conn_matrix_freq_3f_permin{i,1,j}(:,:,2:end),conn_matrix_freq_3f_permin{i,2,j}(:,:,2:end));
        
        %Mean min 
        conn_matrix_TetaAlfaBeta_meanmin3i{i,1} = cat(3,conn_matrix_freq_3i_permin{i,3},conn_matrix_freq_3i_permin{i,1}(:,:,2:end),conn_matrix_freq_3i_permin{i,2}(:,:,2:end));
        conn_matrix_TetaAlfaBeta_meanmin3f{i,1} = cat(3,conn_matrix_freq_3f_permin{i,3},conn_matrix_freq_3f_permin{i,1}(:,:,2:end),conn_matrix_freq_3f_permin{i,2}(:,:,2:end));

    end
end

%RT
save('./S11D/Connectivity_S11D/RT_OA_raw/conn_matrix_TetaAlfaBeta_permin_rt.mat','conn_matrix_TetaAlfaBeta_permin_rt');
save('./S11D/Connectivity_S11D/PosBench_raw/conn_matrix_TetaAlfaBeta_permin_rtPos.mat','conn_matrix_TetaAlfaBeta_permin_rtPos');

%Bench
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_TetaAlfaBeta_permin_3i.mat','conn_matrix_TetaAlfaBeta_permin_3i');
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_TetaAlfaBeta_permin_3f.mat','conn_matrix_TetaAlfaBeta_permin_3f');

save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_TetaAlfaBeta_meanmin3i.mat','conn_matrix_TetaAlfaBeta_meanmin3i');
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_TetaAlfaBeta_meanmin3f.mat','conn_matrix_TetaAlfaBeta_meanmin3f');

%% Por grupo de desempenho 

%Vetor de sujeitos 
v_grupos_idx = {idx_e,idx_b,idx_r};


for i = 1:3 %grupo
    for j = 1:size(v_grupos_idx{i},2) %sujeitos
         
        conn_matrix_TetaAlfaBeta_meanmin3i_group{i,j} = cat(3,conn_matrix_perfreq_mean3i_groups{i}{j,3},conn_matrix_perfreq_mean3i_groups{i}{j,1}(:,:,2:end),conn_matrix_perfreq_mean3i_groups{i}{j,2}(:,:,2:end));
        conn_matrix_TetaAlfaBeta_meanmin3f_group{i,j} = cat(3,conn_matrix_perfreq_mean3f_groups{i}{j,3},conn_matrix_perfreq_mean3f_groups{i}{j,1}(:,:,2:end),conn_matrix_perfreq_mean3f_groups{i}{j,2}(:,:,2:end));
    end
end

save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_TetaAlfaBeta_meanmin3i_group.mat','conn_matrix_TetaAlfaBeta_meanmin3i_group');
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_TetaAlfaBeta_meanmin3f_group.mat','conn_matrix_TetaAlfaBeta_meanmin3f_group');


%% Vetores base para plot 
% var_subjects_conn

for i = 1:25 %sujeito
    for j = 1:3 %tempo
        for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
%           t = t = conn_matrix_TetaAlfaBeta_permin_rt{1,1};;
%             t2(:,i) = nonzeros(tril(t(:,:,i))); %vetor dos 171 pares por 27 frequencias para cada sujeito
              %Rt
              heatmap_vector_rt{i,j}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_permin_rt{i,j}(:,:,k)));
              heatmap_vector_rtPos{i,j}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_permin_rtPos{i,j}(:,:,k)));
              %Bench
              heatmap_vector_3i{i,j}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_permin_3i{i,j}(:,:,k)));
              heatmap_vector_3f{i,j}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_permin_3f{i,j}(:,:,k)));
              
              %Mean Bench 
              heatmap_vector_mean3i{i,1}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_meanmin3i{i,1}(:,:,k)));
              heatmap_vector_mean3f{i,1}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_meanmin3f{i,1}(:,:,k)));
              
        end
    end
end

%Rt
save('./S11D/Connectivity_S11D/RT_OA_raw/heatmap_vector_rt.mat','heatmap_vector_rt');
save('./S11D/Connectivity_S11D/PosBench_raw/heatmap_vector_rtPos.mat','heatmap_vector_rtPos');

%Bench
save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_3i.mat','heatmap_vector_3i');
save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_3f.mat','heatmap_vector_3f');

save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3i.mat','heatmap_vector_mean3i');
save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3f.mat','heatmap_vector_mean3f');

%% Para grupo

for i = 1:3 %grupo
    for j = 1:size(v_grupos_idx{i},2) %sujeitos
         for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
              heatmap_vector_mean3i_group{i,j}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_meanmin3i_group{i,j}(:,:,k)));
              heatmap_vector_mean3f_group{i,j}(:,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta_meanmin3f_group{i,j}(:,:,k)));

         end
    end
end

save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3i_group.mat','heatmap_vector_mean3i_group');
save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3f_group.mat','heatmap_vector_mean3f_group');

%Taking mean of subjects per group 
heatmap_vector_mean3i_meanSubjgroup = meanCell(heatmap_vector_mean3i_group);
heatmap_vector_mean3f_meanSubjgroup = meanCell(heatmap_vector_mean3f_group);

save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3i_meanSubjgroup.mat','heatmap_vector_mean3i_meanSubjgroup');
save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3f_meanSubjgroup.mat','heatmap_vector_mean3f_meanSubjgroup');

%% Heatmaps

%Parametros para plot interpolado e normal
parameters_heatmap = [{'AlignVertexCenters','on','FaceColor','interp'};{'EdgeColor', 'none','AlignVertexCenters','on'}];

for i = 1:25 %subj
    for j = 1:3 %time
        for k = 1:2   %parameters heatmap 
            p1 = figure('Position',[90,90,1520,450]);
            % colormap('jet');
            ax1 = axes('Parent',p1);
%             pc = pcolor(heatmap_vector_rt{i,j}');
            pc = pcolor(heatmap_vector_mean3i{i,1}');
            colormap('jet');
            % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
            % ax1.Units = 'normalized';

            set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
            set(findall(p1,'Type','Text'),'FontSize',24)
            set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',pairs_cmb_names,'YTick',[1:27],'YTickLabel',[2:30],...
                'FontSize',5,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                'TickLabelInterpreter','none');
            % Create ylabel
            ylabel('Frequencia (Hz)');

            % Create xlabel
            xlabel('Pares de Canais');
            colorbar;
            
%             title(['RT_permin_Subj',var_subjects_conn{i}(1:7),'Min',' ',num2str(j)],'Interpreter','none');
%             saveas(p1,['./S11D/Heatmaps/RT_min',num2str(j),'_Subj',var_subjects_conn{i}(1:7),'.fig']);
%             saveas(p1,['./S11D/Heatmaps/RT_min',num2str(j),'_Subj',var_subjects_conn{i}(1:7),'.png']);

            %Mean Min 
            title(['RT_meanmin_Subj',var_subjects_conn{i}(1:7)],'Interpreter','none');
            saveas(p1,['./S11D/Heatmaps/MeanMin/RT_MEANmin','_Subj',var_subjects_conn{i}(1:7),parameters_heatmap{k,end},'.fig']);
            saveas(p1,['./S11D/Heatmaps/MeanMin/RT_MEANmin','_Subj',var_subjects_conn{i}(1:7),parameters_heatmap{k,end},'.png']);
            close;

        end
    end
end

%% Plotting group per Subj

v_groups = {'E','B','R'};

%3i
for i = 1:3 %grupo
    for j = 1:size(v_grupos_idx{i},2) %sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1:2 %parameters of heatmap 
               
               %3i
                p1 = figure('Position',[90,90,1520,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
    %             pc = pcolor(heatmap_vector_rt{i,j}');
                pc = pcolor(heatmap_vector_mean3i_group{i,j}');
                colormap('jet');
                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',pairs_cmb_names,'YTick',[1:27],'YTickLabel',[2:30],...
                    'FontSize',5,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequencia (Hz)');

                % Create xlabel
                xlabel('Pares de Canais');
                colorbar;

                %Mean Min 
                title(['Bench_meanmin_Subj_group3i',' ',v_groups{i},' ',var_subjects_conn{v_grupos_idx{i}(j)}(1:7)],'Interpreter','none');
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_perSubj/3i_MEANmin_group_',v_groups{i},'_Subj',var_subjects_conn{v_grupos_idx{i}(j)}(1:7),parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_perSubj/3i_MEANmin_group_',v_groups{i},'_Subj',var_subjects_conn{v_grupos_idx{i}(j)}(1:7),parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end

%% Plotting group per Subj
% 3f
for i = 1:3 %grupo
    for j = 1:size(v_grupos_idx{i},2) %sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1:2 %parameters of heatmap 
               
               %3i
                p1 = figure('Position',[90,90,1520,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
    %             pc = pcolor(heatmap_vector_rt{i,j}');
                pc = pcolor(heatmap_vector_mean3f_group{i,j}');
                colormap('jet');
                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',pairs_cmb_names,'YTick',[1:27],'YTickLabel',[2:30],...
                    'FontSize',5,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequencia (Hz)');

                % Create xlabel
                xlabel('Pares de Canais');
                colorbar;

                %Mean Min 
                title(['Bench_meanmin_Subj_group3f',' ',v_groups{i},' ',var_subjects_conn{v_grupos_idx{i}(j)}(1:7)],'Interpreter','none');
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_perSubj/3f_MEANmin_group_',v_groups{i},'_Subj',var_subjects_conn{v_grupos_idx{i}(j)}(1:7),parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_perSubj/3f_MEANmin_group_',v_groups{i},'_Subj',var_subjects_conn{v_grupos_idx{i}(j)}(1:7),parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end

%% Plotting heatmaps per mean of subjects per group

%3i
for i = 1:3 %grupo
      for j = 1:size(heatmap_vector_mean3i_meanSubjgroup,2) %sujeitos, no caso 1 para a media dos sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1:2 %parameters of heatmap                
               %3i
                p1 = figure('Position',[90,90,1520,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
                pc = pcolor(heatmap_vector_mean3i_meanSubjgroup{i,j}');
                colormap('jet');
                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',pairs_cmb_names,'YTick',[1:27],'YTickLabel',[2:30],...
                    'FontSize',5,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequencia (Hz)');

                % Create xlabel
                xlabel('Pares de Canais');
                colorbar;

                %Mean Min 
                title(['Bench_meanmin_meanSubj_group3i',' ',v_groups{i}],'Interpreter','none');
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj/3i_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj/3i_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end

%% 3f
for i = 1:3 %grupo
      for j = 1:size(heatmap_vector_mean3f_meanSubjgroup,2) %sujeitos, no caso 1 para a media dos sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1:2 %parameters of heatmap                
               %3i
                p1 = figure('Position',[90,90,1520,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
                pc = pcolor(heatmap_vector_mean3f_meanSubjgroup{i,j}');
                colormap('jet');
                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',pairs_cmb_names,'YTick',[1:27],'YTickLabel',[2:30],...
                    'FontSize',5,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequencia (Hz)');

                % Create xlabel
                xlabel('Pares de Canais');
                colorbar;

                %Mean Min 
                title(['Bench_meanmin_meanSubj_group3f',' ',v_groups{i}],'Interpreter','none');
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj/3f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj/3f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end

%  %HEATMAP 
% set(pc, 'EdgeColor', 'none','AlignVertexCenters','on');%heatmap 
% set(findall(p1,'Type','Text'),'FontSize',24)
% set(ax1,'XTickLabelRotation',45,'XTick',[1:171],'YTick',[1:27],'FontSize',5,'FontWeight','bold',...
%      'Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192]);
%  
%  %HEATMAP INTERPOLADO
% set(pc,'AlignVertexCenters','on','FaceColor','interp'); %Heatmap interpolado 
% set(findall(p1,'Type','Text'),'FontSize',24)
% set(ax1,'XTickLabelRotation',45,'XTick',[1:171],'YTick',[1:27],'FontSize',5,'FontWeight','bold',...
%      'Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192]);


%%  Selecionando pares apenas dos fluxos P-P, F-F E F-P

v_f = [3,4,5,15,16];
v_p = [1,7,12,17,19];

%Combinacao F-F
f_f_comb = nchoosek(v_f,2); %10x2

p_p_comb = nchoosek(v_p,2); %10x2

f_p_comb = nchoosek([v_p,v_f],2); %45x2

save('./S11D/Connectivity_S11D/f_f_comb.mat','f_f_comb');
save('./S11D/Connectivity_S11D/f_p_comb.mat','f_p_comb');
save('./S11D/Connectivity_S11D/p_p_comb.mat','p_p_comb');

%Taking index of position of each p-p, p-f or f-f
% [~,idx_f_f] = intersect(pairs_cmb_idx,f_f_comb,'stable'); %5

% idx = ismember(pairs_cmb_idx,f_f_comb);
% out=sum(idx ,2);
% idx_f_f = find(out>1);

idx_f_f = find((sum(ismember(pairs_cmb_idx,f_f_comb),2)>1));
idx_f_p = find((sum(ismember(pairs_cmb_idx,f_p_comb),2)>1));
idx_p_p = find((sum(ismember(pairs_cmb_idx,p_p_comb),2)>1));

idx_f_f_label = pairs_cmb_names(idx_f_f);
idx_f_p_label = pairs_cmb_names(idx_f_p);
idx_p_p_label = pairs_cmb_names(idx_p_p);

save('./S11D/Connectivity_S11D/Benchmarck/idx_f_f.mat','idx_f_f');
save('./S11D/Connectivity_S11D/Benchmarck/idx_f_p.mat','idx_f_p');
save('./S11D/Connectivity_S11D/Benchmarck/idx_p_p.mat','idx_p_p');

save('./S11D/Connectivity_S11D/Benchmarck/idx_f_f_label.mat','idx_f_f_label');
save('./S11D/Connectivity_S11D/Benchmarck/idx_f_p_label.mat','idx_f_p_label');
save('./S11D/Connectivity_S11D/Benchmarck/idx_p_p_label.mat','idx_p_p_label');

%% Organizing indexes in Right hemisphere, Left hemisphere and Interhemisf - [ WIP ] 
% **********************************************************************************
% f_p_comb
 
%Selecionar indices pares, impares e misturados 
% a partir de ch_label
hemisf_dir = [5,6,7,10,14,16,17,18];%pares
hemisf_esq = [1,2,3,9,11,12,13,15]; %impares
z_area = [4,8,19];
%vector of hemispheres
v_hemisf = [hemisf_esq,z_area,hemisf_dir]';
v_hemisf_label = ch_label([hemisf_esq,z_area,hemisf_dir]');

v_p_hemisf_dir = [7];
v_p_z_area = [19];
v_p_hemisf_esq = [1];

t = nchoosek([v_hemisf],2); %45x2
t_label = v_hemisf_label(t);


idx_f_p_hemisf = find((sum(ismember(pairs_cmb_idx,f_p_comb),2)>1));

idx_f_p_label_hemisf = pairs_cmb_names(idx_f_p_hemisf);

%% Separando cada par das matrizes completas 
for i = 1:3 %grupos
%             heatmap_vector_3i_f_f{i,j} =  heatmap_vector_3i{i,j}(idx_f_f,:)%5 x 27
            %3i
            heatmap_vector_groups_3i_f_f{i} =  heatmap_vector_mean3i_meanSubjgroup{i}(idx_f_f,:)%5 x 27
            heatmap_vector_groups_3i_f_p{i} =  heatmap_vector_mean3i_meanSubjgroup{i}(idx_f_p,:)%5 x 27
            heatmap_vector_groups_3i_p_p{i} =  heatmap_vector_mean3i_meanSubjgroup{i}(idx_p_p,:)%5 x 27
            
            %3f
            heatmap_vector_groups_3f_f_f{i} =  heatmap_vector_mean3f_meanSubjgroup{i}(idx_f_f,:)%5 x 27
            heatmap_vector_groups_3f_f_p{i} =  heatmap_vector_mean3f_meanSubjgroup{i}(idx_f_p,:)%5 x 27
            heatmap_vector_groups_3f_p_p{i} =  heatmap_vector_mean3f_meanSubjgroup{i}(idx_p_p,:)%5 x 27
end

save('./S11D/Connectivity_S11D/heatmap_vector_groups_3i_f_f.mat','heatmap_vector_groups_3i_f_f');
save('./S11D/Connectivity_S11D/heatmap_vector_groups_3i_f_p.mat','heatmap_vector_groups_3i_f_p');
save('./S11D/Connectivity_S11D/heatmap_vector_groups_3i_p_p.mat','heatmap_vector_groups_3i_p_p');

save('./S11D/Connectivity_S11D/heatmap_vector_groups_3f_f_f.mat','heatmap_vector_groups_3f_f_f');
save('./S11D/Connectivity_S11D/heatmap_vector_groups_3f_f_p.mat','heatmap_vector_groups_3f_f_p');
save('./S11D/Connectivity_S11D/heatmap_vector_groups_3f_p_p.mat','heatmap_vector_groups_3f_p_p');

%% Plotting cropped heatmaps 

% F-F 3i
for i = 1:3 %grupo
    for k = 1:2 %parameters of heatmap
        p1 = figure;
        ax1 = axes('Parent',p1);
        pc = pcolor(heatmap_vector_groups_3i_f_f{i}');
%         colormap('jet');
        % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
        % ax1.Units = 'normalized';
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:1:size(heatmap_vector_groups_3i_f_f{i},1)*2],'XTickLabel',idx_f_f_label,'YTick',[1:27],'YTickLabel',[4:30],...
            'FontSize',5,'FontWeight','bold','TickLabelInterpreter','none');
        % Create ylabel
        ylabel('Frequencia (Hz)');

        % Create xlabel
        xlabel('Pares de Canais');
        colorbar;
        
        title(['Bench_meanmin_meanSubj_group3i_f_f',' ',v_groups{i}],'Interpreter','none');
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_F/3i_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_F/3i_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;
    end

end 

%% F-F 3f
for i = 1:3 %grupo
    for k = 1:2 %parameters of heatmap
        p1 = figure;
        ax1 = axes('Parent',p1);
        pc = pcolor(heatmap_vector_groups_3f_f_f{i}');
%         colormap('jet');
        % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
        % ax1.Units = 'normalized';
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:1:size(heatmap_vector_groups_3f_f_f{i},1)*2],'XTickLabel',idx_f_f_label,'YTick',[1:27],'YTickLabel',[4:30],...
            'FontSize',5,'FontWeight','bold','TickLabelInterpreter','none');
        % Create ylabel
        ylabel('Frequencia (Hz)');

        % Create xlabel
        xlabel('Pares de Canais');
        colorbar;
        
        title(['Bench_meanmin_meanSubj_group3f_f_f',' ',v_groups{i}],'Interpreter','none');
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_F/3f_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_F/3f_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;
    end

end 

%% F - P 3i

for i = 1:3 %grupo
    for k = 1:2 %parameters of heatmap
        p1 = figure;
        ax1 = axes('Parent',p1);
        pc = pcolor(heatmap_vector_groups_3i_f_p{i}');
%         colormap('jet');
        % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
        % ax1.Units = 'normalized';
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:1:size(heatmap_vector_groups_3i_f_p{i},1)*2],'XTickLabel',idx_f_f_label,'YTick',[1:27],'YTickLabel',[4:30],...
            'FontSize',5,'FontWeight','bold','TickLabelInterpreter','none');
        % Create ylabel
        ylabel('Frequencia (Hz)');

        % Create xlabel
        xlabel('Pares de Canais');
        colorbar;
        
        title(['Bench_meanmin_meanSubj_group3i_f_p',' ',v_groups{i}],'Interpreter','none');
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_P/3i_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_P/3i_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;
    end

end 

%% F - P 3f
for i = 1:3 %grupo
    for k = 1:2 %parameters of heatmap
        p1 = figure;
        ax1 = axes('Parent',p1);
        pc = pcolor(heatmap_vector_groups_3f_f_p{i}');
%         colormap('jet');
        % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
        % ax1.Units = 'normalized';
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:1:size(heatmap_vector_groups_3f_f_p{i},1)*2],'XTickLabel',idx_f_f_label,'YTick',[1:27],'YTickLabel',[4:30],...
            'FontSize',5,'FontWeight','bold','TickLabelInterpreter','none');
        % Create ylabel
        ylabel('Frequencia (Hz)');

        % Create xlabel
        xlabel('Pares de Canais');
        colorbar;
        
        title(['Bench_meanmin_meanSubj_group3f_f_p',' ',v_groups{i}],'Interpreter','none');
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_P/3f_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_F_P/3f_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;
    end

end 
%% P - P 3i
for i = 1:3 %grupo
    for k = 1:2 %parameters of heatmap
        p1 = figure;
        ax1 = axes('Parent',p1);
        pc = pcolor(heatmap_vector_groups_3i_p_p{i}');
%         colormap('jet');
        % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
        % ax1.Units = 'normalized';
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:1:size(heatmap_vector_groups_3i_p_p{i},1)*2],'XTickLabel',idx_f_f_label,'YTick',[1:27],'YTickLabel',[4:30],...
            'FontSize',5,'FontWeight','bold','TickLabelInterpreter','none');
        % Create ylabel
        ylabel('Frequencia (Hz)');

        % Create xlabel
        xlabel('Pares de Canais');
        colorbar;
        
        title(['Bench_meanmin_meanSubj_group3i_p_p',' ',v_groups{i}],'Interpreter','none');
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_P_P/3i_p_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_P_P/3i_p_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;
    end

end 

%% P - P 3f
for i = 1:3 %grupo
    for k = 1:2 %parameters of heatmap
        p1 = figure;
        ax1 = axes('Parent',p1);
        pc = pcolor(heatmap_vector_groups_3f_p_p{i}');
%         colormap('jet');
        % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
        % ax1.Units = 'normalized';
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:1:size(heatmap_vector_groups_3f_p_p{i},1)*2],'XTickLabel',idx_f_f_label,'YTick',[1:27],'YTickLabel',[4:30],...
            'FontSize',5,'FontWeight','bold','TickLabelInterpreter','none');
        % Create ylabel
        ylabel('Frequencia (Hz)');

        % Create xlabel
        xlabel('Pares de Canais');
        colorbar;
        
        title(['Bench_meanmin_meanSubj_group3f_p_p',' ',v_groups{i}],'Interpreter','none');
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_P_P/3f_p_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/MeanMin/Groups_MeanSubj_P_P/3f_p_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;
    end

end 
%% Gerando matrizes da media dos 3 min para Benchmark 

freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%3i
conn_matrix_mean3i = meanCell(conn_matrix_permin_3i);
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_mean3i.mat','conn_matrix_mean3i');

%3f
conn_matrix_mean3f = meanCell(conn_matrix_permin_3f);
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_mean3f.mat','conn_matrix_mean3f');

% Separating into frequencies 

for i = 1:25
    for l = 1:length(freqbdw) %bdw
        conn_matrix_perfreq_mean3i{i,l} = conn_matrix_mean3i{i}(:,:,eval(freqbdw{l}));
        conn_matrix_perfreq_mean3f{i,l} = conn_matrix_mean3f{i}(:,:,eval(freqbdw{l}));
    end
end

save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_perfreq_mean3i.mat','conn_matrix_perfreq_mean3i');
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_perfreq_mean3f.mat','conn_matrix_perfreq_mean3f');

% Dividing in groups 

%indices de sujeitos de um grupo 
idx_e = [2,5,6,7,13,16,18,19,20];
idx_b = [1,4,8,9,14,15,17,22,21,23,24,25];
idx_r = [3,11,12];
% idx_r = [3,10,11,12]; %Com FFS

%Vetor de sujeitos 
v_grupos_idx = {idx_e,idx_b,idx_r};

%construindo var com valores de conn por grupo
for i = 1:3
    conn_matrix_perfreq_mean3i_groups{i} = conn_matrix_perfreq_mean3i(v_grupos_idx{i},:,:);
    conn_matrix_perfreq_mean3f_groups{i} = conn_matrix_perfreq_mean3f(v_grupos_idx{i},:,:);
end

save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_perfreq_mean3i_groups.mat','conn_matrix_perfreq_mean3i_groups');
save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_perfreq_mean3f_groups.mat','conn_matrix_perfreq_mean3f_groups');