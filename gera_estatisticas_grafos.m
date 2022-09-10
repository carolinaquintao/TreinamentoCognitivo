%importa Fiedtrip
addpath('.\..\Fieldtrip')

%importa conn_data_cell
periodo = 'Antes';%'Depois';%
path_conn = ['.\..\DADOS_PROCESSADOS\GrupoTreinado\Connectivity_5i_5f\' periodo '\'];
% path_conn = ['Y:\TreinamentoCognitivo\Coletas\DADOS_PROCESSADOS\GrupoControle\Connectivity_5i_5f\' periodo '\'];

freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2','gama1','gama2','gama','delta','mu','baixasFreq'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30','30:60','60:100','30:100','1:4','12:15','1:8'};
%% Get names from folder
[names_list] = getNamesFromFolder(path_conn,'*');

%% organizando matrizes (de struct para matriz)
for i = 1:length(names_list)  %12
    disp(['Suj ',num2str(i)]);
    a = split(names_list{i},'_');
    load([path_conn,names_list{i},'\',['Bench_' a{1} ],'\',[a{1} '_freq\'],'conn_data_cell.mat']);
    cfg           = [];
    cfg.method    = 'distance';
    cfg.dimord = 'chan_chan_freq';
    cfg.parameter = 'wpli_debiasedspctrm';
    cfg.threshold = .1;
     stat = ft_networkanalysis(cfg,conn_data_cell{1,1}{1,1})
    
    cfg               = [];
cfg.method        = 'surface';
cfg.funparameter  = 'degrees';
cfg.funcolormap   = 'jet';
ft_sourceplot(cfg, stat);
view([-150 30]);

    for j =1:2 %Para cada minuto
        disp(['Min ',num2str(j)]);
        for l = 1:length(freqbdw) %bdw % 7
            conn_matrix_permin{i,j} = conn_data_cell{1,j}{1,1}.wpli_debiasedspctrm;%conn_matrix_permin0.conn_data_cell{1,2}{1,1}.wpli_debiasedspctrm
            conn_matrix_perMeanfreq{i,l,j} = mean(conn_matrix_permin{i,j}(:,:,eval(freqbdw{l})),3);%para grafo!!!
        end
    end
end