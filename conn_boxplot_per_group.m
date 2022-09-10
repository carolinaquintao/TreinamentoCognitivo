 function  [ conn_perfreq_perch_boxplot,conn_perfreq_boxplot ] = conn_boxplot_per_group(v_conn_data_graph_analysis,v_conn_data_graph_analysis_labels)
%CONN_BOXPLOT_PER_GROUP Summary of this function goes here
%   funcao para plotar boxplots 

%Frequencies
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%Load de labels dos canais 
load('ch_label_19.mat');  
% load('./Matrizes/ch_regions.mat'); %Para ordenacao de canais por regiao

%Verificando origem do arquivo recebido
 verif = split(v_conn_data_graph_analysis_labels,'_');
 if length(verif)>5
     coleta_nome = [verif{5},'_',verif{6}];
 else
     coleta_nome = verif{5};
 end
        
path_tosave = ['./S11D/Graph_analysis_NewGroups_Division_original_ch_order/Boxplot/',coleta_nome,'/'];
mkdir(path_tosave);

for i = 1:length(freqbdw)
    
%     %Change organization of chanels from ch_labels to ch_label(per
%     %region)
%     a0{i} = tril(v_conn_data_graph_analysis{i}([ch_regions],[ch_regions']));%Seleciona triangulo inferior e reorganiza matriz de conn de forma a agrupar regioes 
%     a{i} = nonzeros(a0{1}); %retira os zeros do triu %171 x 1

%     b = mean(v_conn_data_graph_analysis{i},3);
%     b1 = b([ch_regions],[ch_regions]);

    %Boxplots 
    conn_perfreq_perch_boxplot{i} = abs(mean(v_conn_data_graph_analysis{i},3)); %Para plotar por canal
    conn_perfreq_boxplot{i} = abs(reshape(nonzeros(tril(mean(v_conn_data_graph_analysis{i},3))),171,1)); %Para plotar os valores de todos os canais 
   
    
    %plots
    % Plot para todos os pares de cada canal
    figure('Position',[100,100,1250,500]); 
    boxplot(conn_perfreq_perch_boxplot{i});
    set(gca,'XTick',[1:19],'XTickLabel',ch_label');
    xlabel('Canais','fontweight','bold');
    ylabel('Conectividade para as combinaoes de pares de canal','fontweight','bold');
    title(['Analise da variacao de conectividade para todos os pares de cada canal - ',freqbdw_label{i},' ',coleta_nome],'interpreter','none')
    
    saveas(gcf,[path_tosave,'boxplot_',freqbdw_label{i},'_',coleta_nome,'.fig']);
    saveas(gcf,[path_tosave,'boxplot_',freqbdw_label{i},'_',coleta_nome,'.png']);
    close;
   
    
end

    save('./S11D/Graph_analysis_NewGroups_Division/conn_perfreq_perch_boxplot.mat','conn_perfreq_perch_boxplot');
    save('./S11D/Graph_analysis_NewGroups_Division/conn_perfreq_boxplot.mat','conn_perfreq_boxplot');

end

