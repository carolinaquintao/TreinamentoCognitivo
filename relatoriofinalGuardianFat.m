% Script para verificar como os pares escolhidos pela corr e sig  se
% comportam por grupo de desempenho e nos grupos controle e treinado

%Os indices dos canais selecionados estao em v_com_selc_ch,
%v_comb_selec_ch_s11d_corrPos, e v_comb_selec_ch_s11d_corrNeg

% MeanC = mean(cat(3, conn_matrix{:}), 3); %30x30

%s11d
v_comb_selec_semNull = v_comb_selec_ch_s11d_corrPos;
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
%                      v_comb_selec_semNull{j,m}(1) %numero da frequencia 
                    selected_corrPos_NF_s11d_e{i,k,l,m}

                    %                     end
                end
            end
        end
    end
end
disp('ok');

%% Calculo de matrizes de connectividade para analise de grupos treinado e controle do neurofeedback 

%Caminho dos arquivos 
% path_conn = ('W:\AnaSiravenha\BCI\Matrizes_Coleta_Carro_Conectividade\TC2D\Antes\');
% path_conn = ('W:\AnaSiravenha\BCI\Matrizes_Coleta_Carro_Conectividade\TC2D\Depois\');

% path_conn = ('W:\AnaSiravenha\BCI\Matrizes_Coleta_Carro_Conectividade\TC5D\Antes\');
path_conn = ('W:\AnaSiravenha\BCI\Matrizes_Coleta_Carro_Conectividade\TC5D\Depois\');

% Nomes dos sujeitos
var_subjects = getNamesFromFolder(path_conn,'*');

%% Organizando matriz de connectividade
organize_conn(var_subjects,path_conn);

%% Apos organizar as connectividades ...

%Selecionar os pares 

%TC2D
%conn_matrix_permin  %4 x 1 x 2 [ 19 x 19 x 172 ] (sujeito x mental state x
%5i/5f)

%Seguindo a mesma ordem que no PSD 
% freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

% path_conn(57:end)

% for i = 1:length(var_subjects)
for i = 1:4
    for j = 1:2 %intervalos de tempo
        for l = 1:length(freqbdw) %bdw
            %               conn_matrix_freq{i,j,l} = conn_matrix_permin{i,j,k}(:,:,eval(freqbdw{l})); %M
            conn_matrix_freq_TC2D_Antes{i,j,l} = conn_matrix_permin{i,1,j}(:,:,eval(freqbdw{l}));
            conn_matrix_meanfreq_TC2D_Antes{i,j,l} = mean(conn_matrix_freq_TC2D_Antes{i,j,l},3);
            
%             conn_matrix_freq_TC2D_Depois{i,j,l} = conn_matrix_permin{i,1,j}(:,:,eval(freqbdw{l}));
%             conn_matrix_meanfreq_TC2D_Depois{i,j,l} = mean(conn_matrix_freq_TC2D_Depois{i,j,l},3);        
        end
    end
end

save('./NeurofeedbackAnalysis/conn_matrix_freq_TC2D_Antes.mat','conn_matrix_freq_TC2D_Antes');
save('./NeurofeedbackAnalysis/conn_matrix_meanfreq_TC2D_Antes.mat','conn_matrix_meanfreq_TC2D_Antes');

% save('./NeurofeedbackAnalysis/conn_matrix_freq_TC5D_Depois.mat','conn_matrix_freq_TC5D_Depois');
% save('./NeurofeedbackAnalysis/conn_matrix_meanfreq_TC5D_Depois.mat','conn_matrix_meanfreq_TC5D_Depois');


%% Criacao do MeanC

%todos os sujeitos
for i = 1:2
    for j = 1:7 %bandas de frequencias
        % Media de todos os sujeitos concatenados nos 5 min de cada estado, de cada frequencia
        MeanC_TC2D_antes {i,j} = mean(cat(3, conn_matrix_freq_TC2D_Antes{:,i,j}),3); %Mean of all subjects in all 3 minutes
        MeanC_TC2D_depois{i,j} = mean(cat(3, conn_matrix_freq_TC2D_Depois{:,i,j}),3); %Mean of all subjects in all 3 minutes
        
        MeanC_TC5D_antes {i,j}  = mean(cat(3, conn_matrix_freq_TC5D_Antes{:,i,j}),3); %Mean of all subjects in all 3 minutes
        MeanC_TC5D_depois{i,j} = mean(cat(3, conn_matrix_freq_TC5D_Depois{:,i,j}),3); %Mean of all subjects in all 3 minutes


    end
end

%TC2D
con_5i_tc2d_antes = MeanC_TC2D_antes(1,:);
con_5f_tc2d_antes = MeanC_TC2D_antes(2,:);

con_5i_tc2d_depois = MeanC_TC2D_depois(1,:);
con_5f_tc2d_depois = MeanC_TC2D_depois(2,:);

%TC5D
con_5i_tc5d_antes = MeanC_TC5D_antes(1,:);
con_5f_tc5d_antes = MeanC_TC5D_antes(2,:);

con_5i_tc5d_depois = MeanC_TC5D_depois(1,:);
con_5f_tc5d_depois = MeanC_TC5D_depois(2,:);


%% Canais selecionados 


v_comb_selec_ch_s11d_corrPos = {[4 2 6],[7 11 18],[6 9 1],[6 10 1],[6 16 1],[6 7 1],[7 3 1],[7 1 19],[7 1 7]};

v_comb_selec_ch_s11d_corrNeg = {[2 6 15],[7 6 15],[7 19 15],[7 7 15],[2 3 16],[6 8 16],[6 1 16],[6 5 8],[6 16 8],[4 2 6],[7 15 6],[7 17 6]};


% for i = 1:size(v_comb_selec_ch_s11d_corrPos,2) %Para cada par e frequencia selecionado v_comb_selec_ch{1}
for i = 1:10
        tc2d_antes_5i_select_ch_corrPos_nf(i) = con_5i_tc2d_antes{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
        tc2d_antes_5f_select_ch_corrPos_nf(i) = con_5f_tc2d_antes{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
        
        tc2d_depois_5i_select_ch_corrPos_nf(i) = con_5i_tc2d_depois{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
        tc2d_depois_5f_select_ch_corrPos_nf(i) = con_5f_tc2d_depois{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));

        tc5d_antes_5i_select_ch_corrPos_nf(i) = con_5i_tc5d_antes{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
        tc5d_antes_5f_select_ch_corrPos_nf(i) = con_5f_tc5d_antes{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
        
        tc5d_depois_5i_select_ch_corrPos_nf(i) = con_5i_tc5d_depois{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
        tc5d_depois_5f_select_ch_corrPos_nf(i) = con_5f_tc5d_depois{v_comb_selec_ch_s11d_corrPos{1,i}(1)}(v_comb_selec_ch_s11d_corrPos{1,i}(2),v_comb_selec_ch_s11d_corrPos{1,i}(3));
end

%%
for i = 1:size(v_comb_selec_ch_s11d_corrNeg,2) %Para cada par e frequencia selecionado v_comb_selec_ch{3}
    
        tc2d_antes_5i_select_ch_corrNeg_nf(i) = con_5i_tc2d_antes{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));
        tc2d_antes_5f_select_ch_corrNeg_nf(i) = con_5f_tc2d_antes{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));

        tc2d_depois_5i_select_ch_corrNeg_nf(i) = con_5i_tc2d_depois{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));
        tc2d_depois_5f_select_ch_corrNeg_nf(i) = con_5f_tc2d_depois{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));

        tc5d_antes_5i_select_ch_corrNeg_nf(i) = con_5i_tc5d_antes{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));
        tc5d_antes_5f_select_ch_corrNeg_nf(i) = con_5f_tc5d_antes{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));

        tc5d_depois_5i_select_ch_corrNeg_nf(i) = con_5i_tc5d_depois{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));
        tc5d_depois_5f_select_ch_corrNeg_nf(i) = con_5f_tc5d_depois{v_comb_selec_ch_s11d_corrNeg{1,i}(1)}(v_comb_selec_ch_s11d_corrNeg{1,i}(2),v_comb_selec_ch_s11d_corrNeg{1,i}(3));
  
end



%% Calculo de correlacao 

%calculo de correlacao entre os valores de T2cd e t5cd com os grupos de
%desempenho 

%E
s11d_Pos_3i_e = [ 0.017301409	0.022963774	0.031245892	0.042611737	0.034473132	0.040165795	0.008924848	0.00992838	0.012308685	0.034070697];
s11d_Pos_3f_e = [ 0.032291464	0.016514171	0.040552268	0.047225349	0.0502206	0.032712138	0.007719901	0.00279982	0.005131254	0.047694422];

s11d_Neg_3i_e = [0.012234954	0.009836221	0.006952512	0.006706031	0.002129574	0.008836363	0.034473132	0.028332616	0.008836363	0.017301409	0.009836221	0.001003081];
s11d_Neg_3f_e = [0.009830655	0.005060555	0.001730352	0.002253024	7.31E-04	0.015401501	0.0502206	0.026493946	0.015401501	0.032291464	0.005060555	-0.004810308];

%B
s11d_Pos_3i_b = [0.007167873	0.026947619	0.035562963	3.89E-02	0.037399303	0.028340404	0.019311066	0.005471123	0.008485478	0.049799775];
s11d_Pos_3f_b = [0.003896131	0.023648872	0.090659599	0.10577686	0.084816899	0.055913418	0.039368385	0.014435696	0.011174476	0.085310869];

s11d_Neg_3i_b = [0.014370074	0.010167734	0.019033098	0.019933375	0.012134743	0.026146723	0.037399303	0.003863753	0.026146723	0.007167873	0.010167734	0.013892518];
s11d_Neg_3f_b = [0.016106817	0.006394534	0.022346941	0.017187129	0.006772524	0.017997086	0.084816899	0.03672365	0.017997086	0.003896131	0.006394534	0.023270535];

%R
s11d_Pos_3i_r = [0.011747905	0.006370993	0.036359764	0.03356066	0.040351942	0.019821029	0.024322598	1.89E-02	0.011149964	0.021029334];
s11d_Pos_3f_r = [0.010205787	0.004599395	0.104657054	0.067174529	0.041232099	0.020230235	0.023481838	0.014315389	-0.010474088	0.039127177];

s11d_Neg_3i_r = [0.017664914	0.015243889	0.003246791	0.008404422	0.00943761	0.037406929	0.040351942	0.001789617	0.037406929	0.011747905	0.015243889	0.021709473];
s11d_Neg_3f_r = [0.013086415	0.00604188	0.000407925	0.005280859	0.000500297	0.010872285	0.041232099	0.021223763	0.010872285	0.010205787	0.00604188	0.018818619];

%Todos os cenarios do grupo de desempenho (1 x 6) e (1 x 6)
v_grupos_desempenho_Pos = {s11d_Pos_3i_e,s11d_Pos_3f_e,s11d_Pos_3i_b,s11d_Pos_3f_b,s11d_Pos_3i_r,s11d_Pos_3f_r}
v_grupos_desempenho_Neg = {s11d_Neg_3i_e,s11d_Neg_3f_e,s11d_Neg_3i_b,s11d_Neg_3f_b,s11d_Neg_3i_r,s11d_Neg_3f_r}


%Todos os cenarios de neurofeedback(1 x 4) e (1 x 4)
%TC2D
v_tc2d_scenarios_neurofeedback_Pos = {tc2d_antes_5i_select_ch_corrPos_nf,tc2d_antes_5f_select_ch_corrPos_nf,...
    tc2d_depois_5i_select_ch_corrPos_nf,tc2d_depois_5f_select_ch_corrPos_nf};

v_tc2d_scenarios_neurofeedback_Neg = {tc2d_antes_5i_select_ch_corrNeg_nf,tc2d_antes_5f_select_ch_corrNeg_nf,...
    tc2d_depois_5i_select_ch_corrNeg_nf,tc2d_depois_5f_select_ch_corrNeg_nf};

%TC5D
%Todos os cenarios de neurofeedback(1 x 4) e (1 x 4)
v_tc5d_scenarios_neurofeedback_Pos = {tc5d_antes_5i_select_ch_corrPos_nf,tc5d_antes_5f_select_ch_corrPos_nf,...
    tc5d_depois_5i_select_ch_corrPos_nf,tc5d_depois_5f_select_ch_corrPos_nf};

v_tc5d_scenarios_neurofeedback_Neg = {tc5d_antes_5i_select_ch_corrNeg_nf,tc5d_antes_5f_select_ch_corrNeg_nf,...
    tc5d_depois_5i_select_ch_corrNeg_nf,tc5d_depois_5f_select_ch_corrNeg_nf};


for i = 1:6 %grupos desempenho
    for j = 1:4 %scenarios de neurofeedback
        [rho_Pos_tc2d{i,j},~] = corrcoef(v_grupos_desempenho_Pos{i},v_tc2d_scenarios_neurofeedback_Pos{j});
        [rho_Pos_tc5d{i,j},~] = corrcoef(v_grupos_desempenho_Pos{i},v_tc5d_scenarios_neurofeedback_Pos{j});
%         rho_up{i,j}= find(rho_data{i,j} >= 0.7); %Corr positiva
    end
end

%Retirando apenas o valor de correlacao (sem ter a matrix 2 x 2 )
rho_Pos_tc2d = cellfun(@(x) x(2),rho_Pos_tc2d,'un',0);
rho_Pos_tc5d = cellfun(@(x) x(2),rho_Pos_tc5d,'un',0);

xlswrite(['./S11D/Ocorrencia/rho_Pos_tc2d.xlsx'],rho_Pos_tc2d)
xlswrite(['./S11D/Ocorrencia/rho_Pos_tc5d.xlsx'],rho_Pos_tc5d)

for i = 1:6 %grupos desempenho
    for j = 1:4 %scenarios de neurofeedback
        [rho_Neg_tc2d{i,j},~] = corrcoef(v_grupos_desempenho_Neg{i},v_tc2d_scenarios_neurofeedback_Neg{j});
        [rho_Neg_tc5d{i,j},~] = corrcoef(v_grupos_desempenho_Neg{i},v_tc5d_scenarios_neurofeedback_Neg{j});
%         rho_up{i,j}= find(rho_data{i,j} >= 0.7); %Corr positiva
    end
end

xlswrite(['./S11D/Ocorrencia/rho_Neg_tc2d.xlsx'],rho_Neg_tc2d)
xlswrite(['./S11D/Ocorrencia/rho_Neg_tc5d.xlsx'],rho_Neg_tc5d)

%Retirando apenas o valor de correlacao (sem ter a matrix 2 x 2 )
rho_Neg_tc2d = cellfun(@(x) x(2),rho_Neg_tc2d,'un',0);
rho_Neg_tc5d = cellfun(@(x) x(2),rho_Neg_tc5d,'un',0);

%% Calculo do coeficiente de variacao (cv) 

% v_tc2d_scenarios_neurofeedback_Pos %4 x 1
% v_tc2d_scenarios_neurofeedback_Neg
% 
% v_tc5d_scenarios_neurofeedback_Pos
% v_tc5d_scenarios_neurofeedback_Neg

for i = 1:6
    CV_Pos_gruposDesempenho{i} = nanstd(v_grupos_desempenho_Pos{i})/nanmean(v_grupos_desempenho_Pos{i});
    CV_Neg_gruposDesempenho{i} = nanstd(v_grupos_desempenho_Neg{i})/nanmean(v_grupos_desempenho_Neg{i});
end

for i = 1:4
    CV_Pos_neurofeedback_tc2d{i} = nanstd(v_tc2d_scenarios_neurofeedback_Pos{i})/nanmean(v_tc2d_scenarios_neurofeedback_Pos{i});
    CV_Neg_neurofeedback_tc2d{i} = nanstd(v_tc2d_scenarios_neurofeedback_Neg{i})/nanmean(v_tc2d_scenarios_neurofeedback_Neg{i});
    
    CV_Pos_neurofeedback_tc5d{i} = nanstd(v_tc5d_scenarios_neurofeedback_Pos{i})/nanmean(v_tc5d_scenarios_neurofeedback_Pos{i});
    CV_Neg_neurofeedback_tc5d{i} = nanstd(v_tc5d_scenarios_neurofeedback_Neg{i})/nanmean(v_tc5d_scenarios_neurofeedback_Neg{i});
    
end

xlswrite(['./S11D/Ocorrencia/CV_Pos_gruposDesempenho.xlsx'],CV_Pos_gruposDesempenho)
xlswrite(['./S11D/Ocorrencia/CV_Neg_gruposDesempenho.xlsx'],CV_Neg_gruposDesempenho)

xlswrite(['./S11D/Ocorrencia/CV_Pos_neurofeedback_tc2d.xlsx'],CV_Pos_neurofeedback_tc2d)
xlswrite(['./S11D/Ocorrencia/CV_Neg_neurofeedback_tc2d.xlsx'],CV_Neg_neurofeedback_tc2d)
xlswrite(['./S11D/Ocorrencia/CV_Pos_neurofeedback_tc5d.xlsx'],CV_Pos_neurofeedback_tc5d)
xlswrite(['./S11D/Ocorrencia/CV_Neg_neurofeedback_tc5d.xlsx'],CV_Neg_neurofeedback_tc5d)