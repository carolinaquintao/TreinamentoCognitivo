clear;close all
load('heatmap_Antes_5iAntes.mat')
load('heatmap_Antes_5fAntes.mat')
load('heatmap_Depois_5iDepois.mat')
load('heatmap_Depois_5fDepois.mat')

pessoas = size(heatmap_Antes_5i{i});
connMat = conn_matrix_perfreq_mean5f_groups{i};
for j=1:pessoas
    ini = conn_matrix_perfreq_mean5i_groups{i}{j};
    fim = conn_matrix_perfreq_mean5f_groups{i}{j};

    A = ini;
    B = fim;
    I=1:size(A,1);
    J=1:size(B,1);
    alt = cell2mat(arrayfun(@(I,J) anova1([A(I,:) B(J,:)],[],'off'), I,J,'un',0));
% %         I=1:size(A,2);
% %         J=1:size(B,2);
% %         alt = cell2mat(arrayfun(@(I,J) anova1([A(:,I) B(:,J)],[],'off'), I,J,'un',0));
%         alt = cell2mat(arrayfun(@(I,J) ranksum(A(:,I),B(:,J)), I,J,'un',0));
    alt(alt>0.05 & alt<0.95) = NaN;
    result{i,j,:} = alt;
    clear alt
end

 %%
tc5 = cat(1,result{1,:});
tc2 = cat(1,result{2,:});
ntc = cat(1,result{3,:});
%%
sum_tc5 = nansum(tc5);
sum_tc2 = nansum(tc2);
sum_ntc = nansum(ntc);
%%
sum_tc5 = double(sum_tc5<0.03);
sum_tc2 = double(sum_tc2<0.03);
sum_ntc = double(sum_ntc<0.03);
%%
new = cat(1,sum_tc5,sum_tc2,sum_ntc);
bar3(new)
%%
%%
sum_tc5 = sum(double(tc5<0.05))%double(tc5(1,:)<0.05&tc5(2,:)<0.05&tc5(3,:)<0.05&tc5(4,:)<0.05&tc5(4,:)<0.05);
sum_tc2 = sum(double(tc2<0.05))%double(tc2(1,:)<0.05&tc2(2,:)<0.05&tc2(3,:)<0.05&tc2(4,:)<0.05&tc2(4,:)<0.05);
sum_ntc = sum(double(ntc<0.05))%double(ntc(1,:)<0.05&ntc(2,:)<0.05);
%
sum_tc5 = double(sum_tc5>=3)
sum_tc2 = double(sum_tc2>=2)
sum_ntc = double(sum_ntc>1)
%
new = cat(1,sum_tc5,sum_tc2);
bar3(new)


