% function [S,C,L] = small_world_ness(A,LR,CR,FLAG)
function [S,C,L] = small_world_ness(A,FLAG)

% SMALL_WORLD_NESS computes small-world-ness of graph
% [S,C,L] = SMALL_WORLD_NESS(A,LR,CR,FLAG) computes small-world-ness score S of
% graph described by adjacency matrix A, given mean shortest path
% length LR and mean clustering coefficient CR averaged over a random graph ensemble
% of the same (n,m) or (n,<k>) as A [vertices, edges or mean degree].
%
% FLAG is a number indicating which small-world-ness value to compute:
%   1 - raw form with Cws 
%   2 - raw form with transitivity C (no. of triangles)
%
% Also returns a 2 element array O  [C L], which are the mean clustering coefficient C 
% and mean shortest path length L of A.
%
% Mark Humphries 3/02/2017

%% Values of received adjacency matrix
% [L,P] = path_length3(A);
[~,D] = reachdist(A);  % returns Distance matrix of all pairwise distances
L = mean(D(:));  % mean shortest path-length: including self-loops

% calculate required form of C
switch FLAG
    case 1
        c = clustering_coef_bu(A);  % vector of each node's C_ws
        C = mean(c);  % mean C
    case 2
        C = clusttriang(A);
end

%% Creating randon mean shortest path length (LR) of 10 matrices

%Withing the L max and min range
a = min(L(L>0)); %minimum non zero value 
b = max(max(L)); %max value 
% r = (b-a).*rand(19,19) + a;

for i = 1:10
%     lr0  = rand(length(A),length(A));
    r{i} = (b-a).*rand(19,19) + a;
    lr0{i} = tril(r{i},-1)'+tril(r{i},-1); %Create randon path length 
end

%Mean of all random matrices 
lr = mean(reshape(cell2mat(lr0),[19,19,10]),3);

%% Calculating Small worldness

Ls = L / lr;
Cs =  C / CR;
S = Cs / Ls;
