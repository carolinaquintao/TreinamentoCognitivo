function [obtainedlist] = getNamesFromFolder(received_path,stringToFind)
%Funcao para listar nomes de folders ou arquivos dentro de um determinado path

% O path dos arquivos ou pastas deve ser declarado para a funcao
% Assim como a especificacao do arquivo ou pasta, se todos tiverem alguma
% string em comum, declara-la em stringToFind
% ex: lista de sujeitos -> '*subj*'
% ex: listas todo o conteudo -> '*'

if stringToFind == '*'
    helper = dir([received_path,stringToFind]);
    
    %Identifica quais arquivos se deja listar, se todos os tipos,
    %ou apenas pastas 
    option = 2;%input('Deseja listar \n 1) Arquivos? \n 2) Pastas? \n')
    
    if option ~= 1 %Listar pastas
        % Retorna vetor booleano que identifica pasta
        dirFlags = [helper.isdir];
        % Extract only those that are directories.
        helper = helper(dirFlags);
    end
    
    obtainedlist = struct2cell(helper);
    obtainedlist = obtainedlist(1,:);
    obtainedlist=obtainedlist(~ismember(obtainedlist,{'.','..'}));

else
    obtainedlist = struct2cell(dir([received_path,'*',stringToFind,'*']));
    obtainedlist = obtainedlist(1,:);
end

end

