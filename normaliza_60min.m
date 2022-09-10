function dataset_60min_Norm = normaliza_60min(dataset_60min) %por classe
% dataset_n: base classe 1
% dataset_f: base classe 2
% tipo: 'classe':  normalização por classe  
%       default: normalização por feature e por classe;
    %% NORMALIZACAO SIBGRAPI
   disp('SIBIGRAPI por feature e por classe')
    vec = num2cell(dataset_60min,[1 size(dataset_60min,2)]);
    A = cellfun(@(x) normalize(x,'range'),vec,'UniformOutput',false);
    dataset_60min_Norm = cell2mat(A);

% save('./Testes_Artigo_IJCNN/Matrizes/dataset_all_Norm_IJCNN_60min_Mar18.mat','dataset_60min_Norm')
end
