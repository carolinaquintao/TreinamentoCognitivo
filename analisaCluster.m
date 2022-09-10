addpath('./Matrizes/Ocorrencia/')
load('vetor_atributos_allsubj.mat')
%primeira linha Fadiga
%colunas Beta, Beta 1, Beta 2
beta = cat(1,vetor_atributos_allsubj{:,1});
beta1 = cat(1,vetor_atributos_allsubj{:,2});
beta2 = cat(1,vetor_atributos_allsubj{:,3});
classe = [ones(12,1); ones(12,1)*2];

newBeta = [beta classe];
newBeta1 = [beta1 classe];
newBeta2 = [beta2 classe];
%%
[coeff, scores, latent, tsquared, explained] = pca(beta);
% To display scores with group labelling, simply call the plot method on
% the score object stored in Pca result
figure;
scatter(scores(:, 1), scores(:, 2), classe*10,classe)
%%
[coeff, scores, latent, tsquared, explained] = pca(beta1);
% To display scores with group labelling, simply call the plot method on
% the score object stored in Pca result
figure;
scatter(scores(:, 1), scores(:, 2), classe*10,classe)
%%
[coeff, scores, latent, tsquared, explained] = pca(beta2);
% To display scores with group labelling, simply call the plot method on
% the score object stored in Pca result
figure;
scatter(scores(:, 1), scores(:, 2), classe*10,classe)
%%
nn = cat(2, beta,beta1,beta2);
y = kmeans(nn,2);
figure
bar(y)
%%
k=1;
for i=1:48:193
    f{1,k} = beta(1:12,i:i+47);
    f{2,k} = beta(13:end,i:i+47);
    k=k+1;
end

bet = [cat(1, f{1,:});cat(1, f{2,:})];
y = kmeans(bet,2);
figure
bar(y)
%%
k=1;
for i=1:5:20
    f1{1,k} = beta1(1:12,i:i+4);
    f1{2,k} = beta1(13:end,i:i+4);
    k=k+1;
end

bet1 = [cat(1, f1{1,:});cat(1, f1{2,:})];
y = kmeans(bet1,2);
figure
bar(y)
%%
k=1;
for i=1:96:384
    f2{1,k} = beta2(1:12,i:i+95);
    f2{2,k} = beta2(13:end,i:i+95);
    k=k+1;
end

bet2 = [cat(1, f2{1,:});cat(1, f2{2,:})];
y = kmeans(bet2,2);
figure
bar(y)