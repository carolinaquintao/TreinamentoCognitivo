% conn_matrix_meanfreq_meansubj_3i,conn_matrix_meanfreq_meansubj_3f %

%Bench
v_conn_data_graph_analysis_bench = {conn_matrix_meanfreq_meansubj_3i,conn_matrix_meanfreq_meansubj_3f};

%% Frequencias %%%%rodar aqui para gerar correlacao sem gerar matriz e psd!!
%Seguindo a mesma ordem que no PSD 
freqbdw_label = {'alfa','beta','teta','alfa1','alfa2','beta1','beta2'};
freqbdw = {'8:15','15:30','4:8','8:10','10:15','15:19','19:30'};

%%
v_conn_data_graph_analysis_bench = {conn_matrix_meanfreq_meansubj_3i,conn_matrix_meanfreq_meansubj_3f};
v_conn_data_graph_analysis_bench_label = {'conn_matrix_meanfreq_meansubj_3i','conn_matrix_meanfreq_meansubj_3f'};

% %% Custom positions of EEG1020 (plotting)
% load('./Matrizes/tx.mat');
% load('./Matrizes/ty.mat');

%% Bench
cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_bench,v_conn_data_graph_analysis_bench_label);
disp('Fim');
delete('./S11D/Connectivity_S11D/prompt.mat');
delete('./S11D/Connectivity_S11D/thrd.mat');
