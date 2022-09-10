clear
path = 'D:\treinamentoCognitivo\PreprocessingCarol\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\EFS_freq'
mkdir(path)

freqCell1 = load('D:\treinamentoCognitivo\PreprocessingCarol - Copia\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\freq_cell_abs.mat')
freqCell2 = load('D:\treinamentoCognitivo\PreprocessingCarol - Incompletos\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\freq_cell_abs.mat')
freq_cell = [freqCell1.freq_cell freqCell2.freq_cell];
save('D:\treinamentoCognitivo\PreprocessingCarol\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\freq_cell_abs.mat','freq_cell')
%
freqCellCMP1 = load('D:\treinamentoCognitivo\PreprocessingCarol - Copia\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\freq_cell_complex.mat')
freqCellCMP2 = load('D:\treinamentoCognitivo\PreprocessingCarol - Incompletos\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\freq_cell_complex.mat')
freq_cell = [freqCellCMP1.freq_cell freqCellCMP2.freq_cell];
save('D:\treinamentoCognitivo\PreprocessingCarol\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\freq_cell_complex.mat','freq_cell')

%%
clear

file2 = 'D:\treinamentoCognitivo\PreprocessingCarol - Incompletos\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\EFS_freq'
file1 = 'D:\treinamentoCognitivo\PreprocessingCarol - Copia\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\EFS_freq'

g = dir(file1)
g = g(3:end)

for i=1:length(g)
    name = split(g(i).name,'.')
    f1 = load(fullfile(file1,g(i).name))
    f2 = load(fullfile(file2,g(i).name))
%     conn_alfa = [f1.conn_alfa;f2.conn_alfa];
    if strcmp(name{1},'freq_cell_pertrials')
        conn = [f1.freq_cell f2.freq_cell];
%         assignin('base',name{1},conn)
    else
        conn = [eval(['f1.' name{1}]); eval(['f2.' name{1}])];
%         assignin('base',name{1},conn)
    end
    %
    assignin('base',name{1},conn)
    save(['D:\treinamentoCognitivo\PreprocessingCarol\Matrizes\Connectivity\EFS_37_03102019_Benchmark_raw\Bench_EFS\EFS_freq\' g(i).name],name{1})
end