clear
load('heatmap_Antes_5iAntes.mat')
load('heatmap_Antes_5fAntes.mat')
load('heatmap_Depois_5iDepois.mat')
load('heatmap_Depois_5fDepois.mat')

% load('hemisf_AntesDepois_paraPcolor.mat')
pares_selec = [1:171];%[4,10,14,23,24,41,46,50,61,63,95,114,121,124,128,130,133,137,156,159,160,161,169];
%
freqbdw_label = {'delta','teta','alfa1','alfa2','mu','beta1','beta2','gama1','gama2','alfa','beta'};
freqbdw =       {'1:4','4:8','8:10','10:15','12:15','15:19','19:30','30:60','60:99','8:15','15:30'};
j=1
heatmap_Antes_5i = meanCell(heatmap_Antes_5i');
heatmap_Antes_5f = meanCell(heatmap_Antes_5f');
heatmap_Depois_5i = meanCell(heatmap_Depois_5i');
heatmap_Depois_5f = meanCell(heatmap_Depois_5f');
load('.\PreprocessigCarol - 3min\Matrizes\position_label.mat')
labelSelecionado = position_label(pares_selec);
    
for k=1:length(freqbdw_label)
    arquivo = ['tabelaFinal2_' freqbdw_label{k} '_' 'tail' '_' 'right''.mat']
    for i=pares_selec
        %     for k=length(freqbdw)
        %             p1(j,1) = anova1([hemisf_Antes_TC2D_5i(i,19:30)',hemisf_Antes_TC5D_5i(i,19:30)']);
        %             p1(j,2) = anova1([hemisf_Antes_TC2D_5f(i,19:30)',hemisf_Antes_TC5D_5f(i,19:30)']);
        
%         p1(i,1) = ranksum(heatmap_Antes_5i(i,1:4)',heatmap_Depois_5i(i,1:4)','tail','left');%right x>y  left x<y
%         p1(i,2) = ranksum(heatmap_Antes_5f(i,1:4)',heatmap_Depois_5f(i,1:4)','tail','left');
        p1(i,1) = ranksum(heatmap_Antes_5i(i,str2num(freqbdw{k}))',heatmap_Depois_5i(i,str2num(freqbdw{k}))','tail','right');%right x>y  left x<y
        p1(i,2) = ranksum(heatmap_Antes_5f(i,str2num(freqbdw{k}))',heatmap_Depois_5f(i,str2num(freqbdw{k}))','tail','right');
        
        close all
        %     j=j+1
        %     end
    end

    tabelaFinal = horzcat(labelSelecionado,num2cell(p1));
    %%
    pDepois5i = p1(:,1)<0.05;
    pDepois5f = p1(:,2)<0.05;
    pDepois5if = or(pDepois5i,pDepois5f);
    tabelaFinal2 = tabelaFinal(pDepois5if,:)
    save(arquivo,'tabelaFinal2')
    clear p1 pDepois5i pDepois5f pDepois5if tabelaFinal2
end
pAntes5i = p1(:,1)>0.7;
pAntes5f = p1(:,2)>0.7;
pAntes5if = or(pAntes5i,pAntes5f);

pAntesDepois = and(pDepois5if,pAntes5if);
%%
p1Selecionado = p1(pAntesDepois,:);
labelSelecionado = position_label(pAntesDepois);
tabelaFinal = horzcat(labelSelecionado,num2cell(p1Selecionado));
%%
posicao = 1:171;
pares_selec = posicao(pAntesDepois)