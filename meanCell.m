function  [out] = meanCell(in)
%MEANCELL Summary of this function goes here
%   Detailed explanation goes here

% -------------------------------------------------------------------
%NOTA:.
%No in, as linhas devem ser os sujeitos!
% -------------------------------------------------------------------

%Organize the cell in a way to turn into 3d array maintaining the
%organization 

%exemplo
%matrizes de um mesmo sujeito em tempos diferentes 
% x = a{1}; %19x19x172 
% y = a{2}; %19x19x172 
% 
% z(:,:,:,1) = x;
% z(:,:,:,2) = y;
% mean(z,4); %<<< objetivo!

    if length(size(in)) == 3
        for i = 1:size(in,1)%25, suj
            for j = 1: size(in,3) %time
                helper(i,:,:,:,j) = in{i,:,j};
            end
            m_helper = mean(helper,5);
            out{i,1} = permute(m_helper(i,:,:,:),[2,3,4,1]);
        end
    else
        %Para arquivos como heatmap_vector_mean#i_group, que possuem []
        for i = 1:size(in,1)%1:3, suj 'E'-'B'-'R'
            for j = 1: length(find(~cellfun(@isempty,in(i,:)))) %para todos os sujeitos do grupo
                helper(i,:,:,j) = in{i,j};
            end
        end
        m_helper = mean(helper,4);
        out = permute(m_helper(i,:,:,:),[2,3,1]);

    end

end

