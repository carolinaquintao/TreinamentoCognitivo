clear

%Seguindo a mesma ordem que no PSD
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2','gama1','gama2','gama','delta','mu','baixasFreq'};
freqbdw =       {'8:15','15:30','4:8','8:10','10:15','15:19','19:30','30:60','60:100','30:100','1:4','12:15','1:8'};
%                   1       2      3     4       5       6       7       8       9
%           
periodo = 'Depois';%'Antes';%
% grupo = 'TC2D';%'TC5D';%
path_conn = ['D:\treinamentoCognitivo\PreprocessigCarol - 3min\Matrizes\Connectivity\' periodo '\'];

%% Get names from folder
[names_list] = getNamesFromFolder(path_conn,'*');

%% organizando matrizes (de struct para matriz)
for i = 1:length(names_list)  %12
    disp(['Suj ',num2str(i)]);
    for j =1:2 %Para cada minuto
        disp(['Min ',num2str(j)]);
        a = split(names_list{i},'_');
        conn_matrix_permin0 = load([path_conn,names_list{i},'\',['Bench_' a{1} ],'\',[a{1} '_freq\'],'conn_data_cell.mat']);
        for l = 1:length(freqbdw) %bdw % 7
            %                   disp(['Freq ',num2str(l)]);
            %Var com structs
            %Var com matrizes de conn para um mesmo sujeito
            conn_matrix_permin{i,j} = conn_matrix_permin0.conn_data_cell{1,j}{1,1}.wpli_debiasedspctrm;%conn_matrix_permin0.conn_data_cell{1,2}{1,1}.wpli_debiasedspctrm
            helper0{i,j} = conn_matrix_permin0.conn_data_cell{1,j}{1,1}.wpli_debiasedspctrm;%conn_matrix_permin0{i,j}.conn_data_cell{j,1}.wpli_debiasedspctrm;
            
            conn_matrix_freq_permin{i,l,j} = conn_matrix_permin{i,j}(:,:,eval(freqbdw{l})); %Suj x bdw x min {19 x 19 x freq}
        end
    end
    
end

disp('Geracao de matrix ok');

%% Agrupando frequencias
for i = 1:length(names_list) % i = 1:25
    for l = 1:length(freqbdw) %bdw (7)
        for j = 1:2 %min
            %         conn_matrix_perfreq_mean3i{i,l} = conn_matrix_mean3i{i}(:,:,eval(freqbdw{l}));
            %         conn_matrix_perfreq_mean3f{i,l} = conn_matrix_mean3f{i}(:,:,eval(freqbdw{l}));
            conn_matrix_perfreq{i,l,j} = conn_matrix_freq_permin{i,l,j}; %numero de sujeitos  x 7 {19 x 19  x freq}
            conn_matrix_perMeanfreq{i,l,j} = mean(conn_matrix_freq_permin{i,l,j},3);%para grafo!!!
        end
    end
end

%% Selecionado apenas as frequencias de interesse (alfa, teta e beta) e Reorganizando os dados de cell para arrays
%Organizando para 27 frequencias

for i = 1:length(names_list) % sujeitos
    for j = 1:2 %min
        conn_matrix_Antes{i,j} = cat(3,conn_matrix_perfreq{i,11,j}(:,:,2:end),...
            conn_matrix_perfreq{i,3,j}(:,:,2:end),...
            conn_matrix_perfreq{i,1,j}(:,:,2:end),...
            conn_matrix_perfreq{i,2,j}(:,:,2:end),...
            conn_matrix_perfreq{i,8,j}(:,:,2:end),...
            conn_matrix_perfreq{i,9,j}(:,:,2:end)); %1 x 23 { 19 x 19 x 27}
    end
end

%% MATRIZ PARA PCOLOR
% Reorganizando os dados de (19 x 19 x 27)   para  (171 x 27)
%
% for i = 1:3 %grupo
%     for j = 1:size(v_grupos_idx{i},2) %sujeitos
j=1;
for i = 1:length(names_list)
    %         for j = 1:2 %min
    for k = 1:size(conn_matrix_Antes{1,1},3) %27 frequencias
%         heatmap_Antes_5i{i,1}(:,k) = nonzeros(tril(conn_matrix_Antes{i,1}(:,:,k)));
%         heatmap_Antes_5f{i,1}(:,k) = nonzeros(tril(conn_matrix_Antes{i,2}(:,:,k)));
        heatmap_Depois_5i{i,1}(:,k) = nonzeros(tril(conn_matrix_Antes{i,1}(:,:,k)));
        heatmap_Depois_5f{i,1}(:,k) = nonzeros(tril(conn_matrix_Antes{i,2}(:,:,k)));
    end
    %         end
end

save(['heatmap_Depois_5f' periodo '.mat'],'heatmap_Depois_5f')
save(['heatmap_Depois_5i' periodo '.mat'],'heatmap_Depois_5i')

%%

%% Organizing indexes in Right hemisphere, Left hemisphere and Interhemisf - [ WIP ]
% **********************************************************************************
% f_p_comb
load('.\PreprocessigCarol - 3min\Matrizes\ch_label.mat')
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
%%
%% Pairs combinations

%Number of channels
ch_num = [1:length(ch_label)]'; %19 x 1

%Combination of channels
pairs_cmb_idx = nchoosek(ch_num,2); %171 x 2

for i = 1:length(pairs_cmb_idx)
    pairs_cmb_names{i,1} = [ch_label{pairs_cmb_idx(i,1)},'_',ch_label{pairs_cmb_idx(i,2)}];
end
%vetor de index
v_index_heatmap = {hemisf_esq_idx,hemisf_esqZ_idx,z_area_idx,hemisf_dirZ_idx,hemisf_dir_idx,hemisf_esqdir_idx};

for i = 1:length(v_index_heatmap) %6
    for k=1:length(v_index_heatmap{i})
        a = ismember(pairs_cmb_idx(:,1),v_index_heatmap{i}(k,1));
        a(:,2) = ismember(pairs_cmb_idx(:,2),v_index_heatmap{i}(k,2));
        b = sum(a');
        [~,position(i,k)] = max(b)
        clear a;
        clear b;
    end
    %     disp(i);
end

%%  Turning vector position to a line array of 171 x 1
position = nonzeros(reshape(position',[size(position,1) * size(position,2),1]));
position_label = pairs_cmb_names(position);
save('position.mat','position')
save('position_label.mat','position_label')
%% New matrixes order
clear
load('position.mat')
load('position_label.mat')
load('heatmap_Antes_5iAntes.mat')
load('heatmap_Antes_5fAntes.mat')
load('heatmap_Depois_5iDepois.mat')
load('heatmap_Depois_5fDepois.mat')

% heatmap_vector_mean3i_meanSubjgroup
for i=1:8%size(heatmap_Depois_5i,1)
    for j = 1:171%size(heatmap_Depois_5i{i},1)%171
        
        hemisf_heatmap_vector_5i{i,1}(j,:) = heatmap_Antes_5i{i}(position(j),:);
        hemisf_heatmap_vector_5f{i,1}(j,:) = heatmap_Antes_5f{i}(position(j),:);
        hemisf_heatmap_vector_5i{i,2}(j,:) = heatmap_Depois_5i{i}(position(j),:);
        hemisf_heatmap_vector_5f{i,2}(j,:) = heatmap_Depois_5f{i}(position(j),:);
    end
end
%%
%Para os maiores e menores valores em cada intervalo de 3 min
path_saving = './S11D/Groups_MeanSubj/NoAbs/';
mkdir(path_saving);

%3i
%Getting higher value
for i = 1:size(heatmap_Antes_5i,1)
    max_value_5i(i,1) = max(max((cat(1,hemisf_heatmap_vector_5i{i,1},hemisf_heatmap_vector_5i{i,2}))));
    min_value_5i(i,1) = min(min((cat(1,hemisf_heatmap_vector_5i{i,1},hemisf_heatmap_vector_5i{i,2}))));
    max_value_5f(i,1) = max(max((cat(1,hemisf_heatmap_vector_5f{i,1},hemisf_heatmap_vector_5f{i,2}))));
    min_value_5f(i,1) = min(min((cat(1,hemisf_heatmap_vector_5f{i,1},hemisf_heatmap_vector_5f{i,2}))));
    
end
max_value_allperiod_5i = max(max_value_5i);
min_value_allperiod_5i = min(min_value_5i);
max_value_allperiod_5f = max(max_value_5f);
min_value_allperiod_5f = min(min_value_5f);
%%
path_saving = './S11D/Heatmaps/MeanSubj/SemAbsMaxMinAtAll';
mkdir(path_saving);
max_value_all= max([max_value_5i,max_value_5f]);
min_value_all = min([min_value_5i,min_value_5f]);
parameters_heatmap = [{'AlignVertexCenters','on','FaceColor','interp'};{'EdgeColor', 'none','AlignVertexCenters','on'}];

%TODO - Configurar aqui o tamanho do heatmap, a colorbar esta sendo cortada
for j = 1:size(hemisf_heatmap_vector_5f,2) %sujeitos, no caso 1 para a media dos sujeitos
    for i = 1:8 %grupo
        p1 = figure('Position',[1,30,1540,750]);
        % colormap('jet');
        ax1 = axes('Parent',p1);
        per = {'Antes','Depois'};
        %          for k = 1:size(conn_matrix_TetaAlfaBeta_permin_rt{1,1},3) %27 frequencias
        k = 1 %parameters of heatmap
        %3i
        %                 pc = pcolor(hemisf_heatmap_vector_5i{i}');
        pc = pcolor(hemisf_heatmap_vector_5i{i,j}');
        
        %Scalling colorbar
        colormap('jet');
        
        
        set(pc, parameters_heatmap{k,1},parameters_heatmap{k,2},parameters_heatmap{k,3},parameters_heatmap{k,4});%heatmap
        set(pc,'LineStyle','none');
        set(findall(p1,'Type','Text'),'FontSize',24)
        set(ax1,'XTickLabelRotation',90,'XTick',[1:171],'XTickLabel',position_label,'YTick',[1:99],'YTickLabel',[1:99],...
            'FontSize',8,'Position',[0.0231454005934718 0.0830258302583025 0.95727002967359 0.881918819188192],...
            'TickLabelInterpreter','none');

   
        % Create ylabel
        ylabel('Frequency (Hz)');
        
        % Create xlabel
        xlabel('Pairs of Channels');
        
        %Setting custom colorbar
                    h = colorbar;
        %Setting custom axis
        %                 caxis([min_value_all(j) max_value_all(j)]);
        caxis([min(min_value_all) max(max_value_all(j))]);
        
                    % Create line - Hemisf esq -> hemisf esq + area z
                    annotation(p1,'line',[0.171575332259342 0.171575332259342],[0.0823333333333333 0.96509009009009],'Color',[1 1 1],'LineWidth',2);
                    % Create line -  hemisf esq + area z  ->  area z
                    annotation(p1,'line',[0.300552474801661 0.300552474801661],[0.0812072072072072 0.96509009009009],'Color',[1 1 1],'LineWidth',2);
                    % Create line -  area z  ->  area z + hemisf dir
                    annotation(p1,'line',[0.315512097746243 0.315512097746243],[0.0811954767267268 0.967330611861862],'Color',[1 1 1],'LineWidth',2);
                    % Create line - area z + hemisf dir ->  hemisf dir
                    annotation(p1,'line',[0.445477786808174 0.445477786808174],[0.0811954767267269 0.967330611861862],'Color',[1 1 1],'LineWidth',2);
                    % Create line -  hemisf dir -> interhemisf
                    annotation(p1,'line',[0.594659633335007 0.594659633335007],[0.078954954954955 0.966216216216216],'Color',[1 1 1],'LineWidth',2);
        %Mean Min
        title(['vector_5i_suj ',num2str(i),' periodo: ',per{j}],'Interpreter','none');
                    savefig(p1,[path_saving,'\vector_5i_Antes_Depois_suj ',num2str(i),' periodo_',per{j},'.fig']);
                    saveas(p1,[path_saving,'\vector_5i_Antes_Depois_suj ',num2str(i),' periodo_',per{j},'.png']);
                    close;
        
        
    end
end
%%
% 
% 
% h1 = openfig([path_saving,'\vector_5i_Antes_Depois_suj ',num2str(1),' periodo_',per{1},'.fig'],'reuse');
% ax1 = gca;
% h2 = openfig([path_saving,'\vector_5i_Antes_Depois_suj ',num2str(2),' periodo_',per{1},'.fig'],'reuse');
% ax2 = gca;
% h3 = openfig([path_saving,'\vector_5i_Antes_Depois_suj ',num2str(3),' periodo_',per{1},'.fig'],'reuse');
% ax3 = gca;
% h4 = openfig([path_saving,'\vector_5i_Antes_Depois_suj ',num2str(4),' periodo_',per{1},'.fig'],'reuse');
% ax4 = gca;
% h5 = openfig([path_saving,'\vector_5i_Antes_Depois_suj ',num2str(5),' periodo_',per{1},'.fig'],'reuse');
% ax5 = gca;
% 
% % test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
% h6 = figure; %create new figure
% s1 = subplot(2,3,1); %create and get handle to the subplot axes
% s2 = subplot(2,3,2);
% s3 = subplot(2,3,3); %create and get handle to the subplot axes
% s4 = subplot(2,3,4);
% s5 = subplot(2,3,5); %create and get handle to the subplot axes
% fig3 = get(ax1,'children'); %get handle to all the children in the figure
% fig4 = get(ax2,'children');
% fig5 = get(ax3,'children');
% fig6 = get(ax4,'children');
% fig7 = get(ax5,'children');
% 
% copyobj(fig3,s1); %copy children to new parent axes i.e. the subplot axes
% copyobj(fig4,s2);
% copyobj(fig5,s3);
% copyobj(fig6,s4);
% copyobj(fig7,s5);


