%Script para gerar matrizes com nova divisao de sujeitos por clusters
%(grupo Sergio)

%Carrega nomes
%Seguindo a mesma ordem que no PSD 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

% path_conn = '..\ConectCompArtigo\Matrizes\Connectivity\Benchmark_raw\';
path_conn = '..\ConectCompArtigo\Matrizes\Connectivity_crit_interv\';

%% Get names from folder 
[names_list] = getNamesFromFolder(path_conn,'*');

%% organizando matrizes (de struct para matriz)
for i = 10:length(names_list)  %12
    disp(['Suj ',num2str(i)]);
        for j =1:5 %Para cada minuto
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
            
end

 disp('Geracao de matrix ok');  
 
 %% Agrupando frequencias 
for i = 1:length(names_list) % i = 1:25
    for l = 1:length(freqbdw) %bdw (7) 
        for j = 1:60 %min
%         conn_matrix_perfreq_mean3i{i,l} = conn_matrix_mean3i{i}(:,:,eval(freqbdw{l}));
%         conn_matrix_perfreq_mean3f{i,l} = conn_matrix_mean3f{i}(:,:,eval(freqbdw{l}));
          conn_matrix_perfreq{i,l,j} = conn_matrix_freq_permin{i,l,j}; %numero de sujeitos  x 7 {19 x 19  x freq}
        end
    end
end

%% Selecionado apenas as frequencias de interesse (alfa, teta e beta) e Reorganizando os dados de cell para arrays 
%Organizando para 27 frequencias 

for i = 1:length(names_list) % sujeitos
    for j = 1:60 %min
        conn_matrix_TetaAlfaBeta{i,j} = cat(3,conn_matrix_perfreq{i,3,j},conn_matrix_perfreq{i,1,j}(:,:,2:end),conn_matrix_perfreq{i,2,j}(:,:,2:end)); %1 x 23 { 19 x 19 x 27}
    end
end

%% MATRIZ PARA PCOLOR 
% Reorganizando os dados de (19 x 19 x 27)   para  (171 x 27)
% 
% for i = 1:3 %grupo
%     for j = 1:size(v_grupos_idx{i},2) %sujeitos
    for i = 1:length(names_list)
        for j = 1:5 %min
             for k = 1:size(conn_matrix_TetaAlfaBeta{1,1},3) %27 frequencias
                  heatmap_tetaAlfaBeta{i,1}(:,j,k) = nonzeros(tril(conn_matrix_TetaAlfaBeta{i,j}(:,:,k)));
             end
        end
    end

%% Devisao por Grupo 

%Novos indices de sujeitos de um grupo - nao leva em consideracao o FFS
idx_e = [6,5,2,7,16,19,20,13,18,23];
idx_b = [4,14,21,24,1,25,9];
idx_r = [8,15,17,3,11];
% idx_r = [3,10,11,12]; %Com FFS

%Vetor de sujeitos 
v_grupos_idx = {idx_e,idx_b,idx_r};

%% construindo var com valores de conn por grupo
for i = 1:3
    conn_matrix_perfreq_mean3i_groups{i} = heatmap_tetaAlfaBeta(v_grupos_idx{i},:,:);

end

% save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_perfreq_mean3i_groups.mat','conn_matrix_perfreq_mean3i_groups');
% save('./S11D/Connectivity_S11D/Benchmarck/conn_matrix_perfreq_mean3f_groups.mat','conn_matrix_perfreq_mean3f_groups');

%% Taking mean of subjects per group 
heatmap_vector_mean3i_meanSubjgroup = meanCell(heatmap_vector_mean3i_group);
heatmap_vector_mean3f_meanSubjgroup = meanCell(heatmap_vector_mean3f_group);

% save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3i_meanSubjgroup.mat','heatmap_vector_mean3i_meanSubjgroup');
% save('./S11D/Connectivity_S11D/Benchmarck/heatmap_vector_mean3f_meanSubjgroup.mat','heatmap_vector_mean3f_meanSubjgroup');

%% Plotting

%Creating folder 
mkdir('./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/');

%Parametros para plot interpolado e normal
parameters_heatmap = [{'AlignVertexCenters','on','FaceColor','interp'};{'EdgeColor', 'none','AlignVertexCenters','on'}];

%% 3i
for i = 1:3 %grupo
      for j = 1:size(heatmap_vector_mean3i_meanSubjgroup,2) %sujeitos, no caso 1 para a media dos sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1 %parameters of heatmap                
               %3i
                p1 = figure('Position',[90,90,1520,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
%                 ax1.FontSize = 11; 
                pc = pcolor(heatmap_vector_mean3i_meanSubjgroup{i,j}');
%                 pc = heatmap(heatmap_vector_mean3i_meanSubjgroup{i,j}');
                colormap('jet');
                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(pc,'LineStyle','none');
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',pairs_cmb_names,'YTick',[1:27],'YTickLabel',[4:30],...
                    'FontSize',11,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequency (Hz)');

                % Create xlabel
                xlabel('Pairs of Channels');
                colorbar;                            
                
                %Mean Min 
                title(['Bench_meanmin_meanSubj_group3i',' ',v_groups{i}],'Interpreter','none');
                saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/3i_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/3i_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
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
                saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/3f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/3f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end


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
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_F/3i_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_F/3i_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
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
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_F/3f_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_F/3f_f_f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close; 
    end

end 

%% F - P 3i

mkdir('./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_P/');

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
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_P/3i_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_P/3i_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
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
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_P/3f_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_F_P/3f_f_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
        close;  
    end

end 
%% P - P 3i

 mkdir('./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_P_P/');
 
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
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_P_P/3i_p_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
        saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/Groups_MeanSubj_P_P/3i_p_p_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
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

 %% Organizing indexes in Right hemisphere, Left hemisphere and Interhemisf 
% **********************************************************************************
% f_p_comb
 
%Selecionar indices pares, impares e misturados 
% a partir de ch_label
hemisf_dir = [5,6,7,10,14,16,17,18];%pares
hemisf_esq = [1,2,3,9,11,12,13,15]; %impares
z_area = [4,8,19];

%Hemisf Esq
hemisf_esq_idx = nchoosek([hemisf_esq],2); %28 x 2
%reordering to avoid error by redundancy
hemisf_esq_idx = sort(hemisf_esq_idx,2);
hemisf_esq_label = ch_label(hemisf_esq_idx);

%Area Z
z_area_idx = nchoosek([z_area],2); %3x2
%reordering to avoid error by redundancy
z_area_idx = sort(z_area_idx,2);
z_area_label = ch_label(z_area_idx);

%Hemisf Dir
hemisf_dir_idx = nchoosek([hemisf_dir],2); %28 x 2
%reordering to avoid error by redundancy
hemisf_dir_idx = sort(hemisf_dir_idx,2);
hemisf_dir_label = ch_label(hemisf_dir_idx);

%Hemisf Esq + Z
hemisf_esqZ_idx = nchoosek([hemisf_esq,z_area],2); %55 x 2
%Removing redundant combinations
hemisf_esqZ_idx = setdiff(hemisf_esqZ_idx,hemisf_esq_idx,'rows');
hemisf_esqZ_idx = setdiff(hemisf_esqZ_idx,z_area_idx,'row');
%reordering to avoid error by redundancy
hemisf_esqZ_idx = sort(hemisf_esqZ_idx,2);
hemisf_esqZ_label = ch_label(hemisf_esqZ_idx);%24 x 2
%reshaping
% hemisf_esqZ_idx = reshape(hemisf_esqZ_idx,[size(hemisf_esqZ_idx,1)*2,1]);

%Hemisf Dir+ Z
hemisf_dirZ_idx = nchoosek([hemisf_dir,z_area],2); %55 x 2
%Removing redundant combinations
hemisf_dirZ_idx = setdiff(hemisf_dirZ_idx,hemisf_dir_idx,'rows');
hemisf_dirZ_idx = setdiff(hemisf_dirZ_idx,z_area_idx,'row');
%reordering to avoid error by redundancy
hemisf_dirZ_idx = sort(hemisf_dirZ_idx,2);
hemisf_dirZ_label = ch_label(hemisf_dirZ_idx); %ok

%Hemisf Dir + Hemisf Esq
hemisf_esqdir_idx = nchoosek([hemisf_dir,hemisf_esq],2); 
%Removing redundant combinations
hemisf_esqdir_idx = setdiff(hemisf_esqdir_idx,hemisf_dir_idx,'rows');
hemisf_esqdir_idx = setdiff(hemisf_esqdir_idx,hemisf_esq_idx,'row');
%reordering to avoid error by redundancy
hemisf_esqdir_idx = sort(hemisf_esqdir_idx,2);
hemisf_esqdir_label = ch_label(hemisf_esqdir_idx); %64 x 2

%Achar os indices na ordem da matriz original de 171 pares 
%%

%vetor de index 
v_index_heatmap = {hemisf_esq_idx,hemisf_esqZ_idx,z_area_idx,hemisf_dirZ_idx,hemisf_dir_idx,hemisf_esqdir_idx};

for i = 1:length(v_index_heatmap) %6
    for k=1:length(v_index_heatmap{i}) 
        a = ismember(pairs_cmb_idx(:,1),v_index_heatmap{i}(k,1));
        a(:,2) = ismember(pairs_cmb_idx(:,2),v_index_heatmap{i}(k,2));
        b = sum(a');
        [~,position(i,k)] = max(b);
        clear a;
        clear b;
    end
%     disp(i);
end

%%  Turning vector position to a line array of 171 x 1
position = nonzeros(reshape(position',[size(position,1) * size(position,2),1]));
position_label = pairs_cmb_names(position);

%Saving variables 
save('./S11D/Connectivity_S11D/position.mat','position');
save('./S11D/Connectivity_S11D/position_label.mat','position_label');

%% New matrixes order  - Chamar a My <3
% heatmap_vector_mean3i_meanSubjgroup
for i = 1:3 %groups
    for j = 1:size(heatmap_vector_mean3i_meanSubjgroup{1,1},1)%171
        hemisf_heatmap_vector_mean3i_meanSubjgroup{i,1}(j,:) = heatmap_vector_mean3i_meanSubjgroup{i}(position(j),:);
        hemisf_heatmap_vector_mean3f_meanSubjgroup{i,1}(j,:) = heatmap_vector_mean3f_meanSubjgroup{i}(position(j),:)
    end
end

save('./S11D/Connectivity_S11D/Benchmarck/hemisf_heatmap_vector_mean3i_meanSubjgroup.mat','hemisf_heatmap_vector_mean3i_meanSubjgroup');
save('./S11D/Connectivity_S11D/Benchmarck/hemisf_heatmap_vector_mean3f_meanSubjgroup.mat','hemisf_heatmap_vector_mean3f_meanSubjgroup');

%% Reorganizing plots using newposition 

%Para os maiores e menores valores em cada intervalo de 3 min 
path_saving = './S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/NoAbs/';
mkdir(path_saving);

%3i
%Getting higher value 
for i = 1:3
   max_value{i} = max(max(abs(hemisf_heatmap_vector_mean3i_meanSubjgroup{i})));
   min_value{i} = min(min(hemisf_heatmap_vector_mean3i_meanSubjgroup{i}));
end

% for i = 1:3
%    max_value_3f{i} = max(max(abs(hemisf_heatmap_vector_mean3f_meanSubjgroup{i})));
%    min_value{i} = min(min(hemisf_heatmap_vector_mean3i_meanSubjgroup{i}));
% end

max_value_allperiod = max(cell2mat(max_value));
min_value_allperiod = min(cell2mat(min_value));
%Maior limite  de connectividade nos 3i eh no grupo E - B - R

% ---------------------------------------------------------------------------
%Quando ja se possuir os valores maiores e menores dos intervalos 3i e 3f
path_saving = './S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/NoAbsMaxMinAllInterv';
mkdir(path_saving);
max_value_all= max([cell2mat(max_value),cell2mat(max_value_3f)]);
min_value_all = min([cell2mat(min_value),cell2mat(min_value_3f)]);

%TODO - Configurar aqui o tamanho do heatmap, a colorbar esta sendo cortada
for i = 1:3 %grupo
      for j = 1:size(hemisf_heatmap_vector_mean3i_meanSubjgroup,2) %sujeitos, no caso 1 para a media dos sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1 %parameters of heatmap                
               %3i
                p1 = figure('Position',[300,300,1250,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
                pc = pcolor(hemisf_heatmap_vector_mean3i_meanSubjgroup{i}');
%                 pc = heatmap(heatmap_vector_mean3i_meanSubjgroup{i,j}');

                %Scalling colorbar
                colormap('jet');               


                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(pc,'LineStyle','none');
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',position_label,'YTick',[1:27],'YTickLabel',[4:30],...
                    'FontSize',11,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequency (Hz)');

                % Create xlabel
                xlabel('Pairs of Channels');
                
                %Setting custom colorbar
                h = colorbar; 
%                 set(h,'Ylim',[min_value_all max_value_all],'Ticks',linspace(min_value_all, max_value_all,6));
                
                %Setting custom axis
%                 caxis([min_value{i} max_value{i}]);
                caxis([min_value_all max_value_all]);
                
                % Create line - Hemisf esq -> hemisf esq + area z
                annotation(p1,'line',[0.171575332259342 0.171575332259342],...
    [0.0823333333333333 0.96509009009009],'Color',[1 1 1],'LineWidth',2);

                % Create line -  hemisf esq + area z  ->  area z
                annotation(p1,'line',[0.300552474801661 0.300552474801661],...
    [0.0812072072072072 0.96509009009009],'Color',[1 1 1],'LineWidth',2);

                % Create line -  area z  ->  area z + hemisf dir
                annotation(p1,'line',[0.315512097746243 0.315512097746243],...
    [0.0811954767267268 0.967330611861862],'Color',[1 1 1],'LineWidth',2);

                % Create line - area z + hemisf dir ->  hemisf dir
                annotation(p1,'line',[0.445477786808174 0.445477786808174],...
    [0.0811954767267269 0.967330611861862],'Color',[1 1 1],'LineWidth',2);

                % Create line -  hemisf dir -> interhemisf
                annotation(p1,'line',[0.594659633335007 0.594659633335007],...
    [0.078954954954955 0.966216216216216],'Color',[1 1 1],'LineWidth',2);
                
                %Mean Min 
                title(['Bench_meanmin_meanSubj_group3i',' ',v_groups{i}],'Interpreter','none');
                savefig(p1,[path_saving,'/3i_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
                saveas(p1,[path_saving,'/3i_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end

%% 3f

%Getting higher value 
for i = 1:3
   max_value_3f{i} = max(max(abs(hemisf_heatmap_vector_mean3f_meanSubjgroup{i})));
   min_value_3f{i} = min(min(hemisf_heatmap_vector_mean3f_meanSubjgroup{i}));
end

max_value_all_3f = max(cell2mat(max_value_3f));
min_value_all_3f = min(cell2mat(min_value_3f));

%Maior limite  de connectividade nos 3i eh no grupo E - B - R

for i = 1:3 %grupo
      for j = 1:size(hemisf_heatmap_vector_mean3f_meanSubjgroup,2) %sujeitos, no caso 1 para a media dos sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1 %parameters of heatmap                
               %3i
                p1 = figure('Position',[300,300,1250,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
                pc = pcolor(hemisf_heatmap_vector_mean3f_meanSubjgroup{i}');
%                 pc = heatmap(heatmap_vector_mean3i_meanSubjgroup{i,j}');

                %Scalling colorbar
                colormap('jet');               

                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(pc,'LineStyle','none');
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',position_label,'YTick',[1:27],'YTickLabel',[4:30],...
                    'FontSize',11,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequency (Hz)');

                % Create xlabel
                xlabel('Pairs of Channels');

                %Setting custom colorbar
                h = colorbar;
%                 set(h,'Ylim',[min_value_all_3f max_value_all],'Ticks',linspace(min_value_all_3f, max_value_all,6));
                
                %Setting custom axis
%                 caxis([min_value_all max_value_all]);
%                 caxis([0 max_value_3f{i}]);
                  caxis([0 max_value_all]);
                
                 % Create line - Hemisf esq -> hemisf esq + area z
                annotation(p1,'line',[0.171575332259342 0.171575332259342],...
    [0.0823333333333333 0.96509009009009],'Color',[1 1 1],'LineWidth',2);

                % Create line -  hemisf esq + area z  ->  area z
                annotation(p1,'line',[0.300552474801661 0.300552474801661],...
    [0.0812072072072072 0.96509009009009],'Color',[1 1 1],'LineWidth',2);

                % Create line -  area z  ->  area z + hemisf dir
                annotation(p1,'line',[0.315512097746243 0.315512097746243],...
    [0.0811954767267268 0.967330611861862],'Color',[1 1 1],'LineWidth',2);

                % Create line - area z + hemisf dir ->  hemisf dir
                annotation(p1,'line',[0.445477786808174 0.445477786808174],...
    [0.0811954767267269 0.967330611861862],'Color',[1 1 1],'LineWidth',2);

                % Create line -  hemisf dir -> interhemisf
                annotation(p1,'line',[0.594659633335007 0.594659633335007],...
    [0.078954954954955 0.966216216216216],'Color',[1 1 1],'LineWidth',2);

                
                %Mean Min 
                title(['Bench_meanmin_meanSubj_group3f',' ',v_groups{i}],'Interpreter','none');
               
%                 savefig(p1,[path_saving,'/3f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
%                 saveas(p1,[path_saving,'/3f_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
%                 close;
                
         end
    end
end

%% Calculating the difference between mental states 

diff_3f3i_hemisf_heatmap_mean3min_meanSubjgroup = cellfun(@(x,y) y - x,hemisf_heatmap_vector_mean3i_meanSubjgroup,hemisf_heatmap_vector_mean3f_meanSubjgroup,'un',0);

%Getting higher value 
for i = 1:3
   max_value_diff{i} = max(max(abs(diff_3f3i_hemisf_heatmap_mean3min_meanSubjgroup{i})));
end
max_value_all_diff = max(cell2mat(max_value_diff));
%Maior limite  de connectividade nos 3i eh no grupo E - B - R

%% plots
for i = 1:3 %grupo
      for j = 1:size(diff_3f3i_hemisf_heatmap_mean3min_meanSubjgroup,2) %sujeitos, no caso 1 para a media dos sujeitos
%          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
           for k = 1 %parameters of heatmap                
               %3i
                p1 = figure('Position',[90,90,1250,450]);
                % colormap('jet');
                ax1 = axes('Parent',p1);
                pc = pcolor(diff_3f3i_hemisf_heatmap_mean3min_meanSubjgroup{i}');
%                 pc = heatmap(heatmap_vector_mean3i_meanSubjgroup{i,j}');

                %Scalling colorbar
                colormap('jet');               

                % set(pc, 'EdgeColor', 'none','YTick',{1:27},'YTickLabel',{4:30},'XTick',{1:171},'XTickLabel',pairs_cmb_names,'XTickLabelRotation',45);
                % ax1.Units = 'normalized';

                set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap 
                set(pc,'LineStyle','none');
                set(findall(p1,'Type','Text'),'FontSize',24)
                set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',position_label,'YTick',[1:27],'YTickLabel',[4:30],...
                    'FontSize',5,'FontWeight','bold','Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
                    'TickLabelInterpreter','none');
                % Create ylabel
                ylabel('Frequency (Hz)');

                % Create xlabel
                xlabel('Pairs of Channels');

                %Setting custom colorbar
                h = colorbar;
%                 set(h,'Ylim',[0 max_value_diff{i}],'Ticks',linspace(0, max_value_diff{i},6));
                
                %Setting custom axis
%                 caxis([0 max_value_diff{i}]);
                 caxis([0 max_value_all_diff]);
                
                  % Create line - Hemisf esq -> hemisf esq + area z
                annotation(p1,'line',[0.171575332259342 0.171575332259342],...
    [0.0823333333333333 0.96509009009009],'Color',[1 1 1],'LineWidth',2);

                % Create line -  hemisf esq + area z  ->  area z
                annotation(p1,'line',[0.300552474801661 0.300552474801661],...
    [0.0812072072072072 0.96509009009009],'Color',[1 1 1],'LineWidth',2);

                % Create line -  area z  ->  area z + hemisf dir
                annotation(p1,'line',[0.315512097746243 0.315512097746243],...
    [0.0811954767267268 0.967330611861862],'Color',[1 1 1],'LineWidth',2);

                % Create line - area z + hemisf dir ->  hemisf dir
                annotation(p1,'line',[0.445477786808174 0.445477786808174],...
    [0.0811954767267269 0.967330611861862],'Color',[1 1 1],'LineWidth',2);

                % Create line -  hemisf dir -> interhemisf
                annotation(p1,'line',[0.594659633335007 0.594659633335007],...
    [0.078954954954955 0.966216216216216],'Color',[1 1 1],'LineWidth',2);

                
                %Mean Min 
%                 title(['Diff Bench_meanmin_meanSubj_group3f',' ',v_groups{i}],'Interpreter','none');
                savefig(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/diff_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.fig']);
                saveas(p1,['./S11D/Heatmaps/NewClusterGroups/Groups_MeanSubj/diff_MEANmin_group_',v_groups{i},'_',parameters_heatmap{k,end},'.png']);
                close;
                
         end
    end
end

%% Compass plot

% figure, plot(w, abs(X)), title('Amplitude plot')
% hemisf_heatmap_vector_mean3i_meanSubjgroup{1}(:,1) %primeira frequencia 
figure, plot(abs(hemisf_heatmap_vector_mean3i_meanSubjgroup{1}(:,1))), title('Amplitude plot');
% figure, plot(w, angle(X)), title('Phase plot')
figure, compass(angle(hemisf_heatmap_vector_mean3i_meanSubjgroup{1}(:,1))), title('Phase plot')

%% Compass plot

%Method dados
amp = [1.0448,0.365,0.0712,0.0622,0.1027]; 
pha = [77.16,105.75,61.67,320.84,101.95]; 
rdir = pha * pi/180; 
[x,y] = pol2cart(rdir,amp);
compass(x,y)
view([-90 90])

%Method 2
M = randn(5,5);
Z = eig(M);
figure
compass(Z)


