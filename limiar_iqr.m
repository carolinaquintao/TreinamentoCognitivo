%Script para analisar interquartil como limiar de conn 

% O interquartil pode ser por frequencia,por grupo, por periodo de tempo
% (3i , 3f) 

%ex conn_matrix_meanfreq_meansubj_3i >> 13 x 1 {19 x 19}

for i = 1:13 %Para cada frequencia 
    %Para cada frequencia tranformar 19 x 19 para 171 x 1  
    conn_pairs_meanfreq_meansubj_3i{i} = nonzeros(tril(conn_matrix_meanfreq_meansubj_3i{i}));
    conn_pairs_meanfreq_meansubj_3f{i} = nonzeros(tril(conn_matrix_meanfreq_meansubj_3f{i}));
    
    iqr_limiar_freq_3i{i} = iqr(conn_pairs_meanfreq_meansubj_3i{i});
    iqr_limiar_freq_3f{i} = iqr(conn_pairs_meanfreq_meansubj_3f{i});
    
    save('./Matrizes/iqr_limiar_freq_3i.mat','iqr_limiar_freq_3i');
    save('./Matrizes/iqr_limiar_freq_3f.mat','iqr_limiar_freq_3f');
end