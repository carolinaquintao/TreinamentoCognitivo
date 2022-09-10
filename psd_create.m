% Loading paths
path_matrices_psd = ('./Matrizes/psd/');

% Performing fft
cfg = [];
cfg.tapsmofrq = 2;
cfg.toi = data_after_ica.time(1);
cfg.foilim = [0 100];
cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.keeptrials = 'yes';

%load('./Matrizes/ConMatrices/data_after_ica.mat');
freq = ft_freqanalysis(cfg,data_after_ica);
%[path_matrices_psd,'subj',data(8:9),'/',data(10:(end-4)),'/'];
%Creating forlder for each subject
mkdir([path_matrices_psd,'subj',data(8:9),data(10:(end-4))]);
save([path_matrices_psd,'subj',data(8:9),data(10:(end-4)),'/','freq_normal.mat'],'freq');

%% Variables 
% Storing frequency values 
frequency = freq.freq;
save('./Matrizes/frequency.mat','frequency');
save([path_matrices_psd,'subj',data(8:9),'/',data(10:(end-4)),'/','frequency.mat'],'frequency');

% Saving channel labels
ch_label = freq.label;
save([path_matrices_psd,'subj',data(8:9),'/',data(10:(end-4)),'/','ch_label.mat'],'ch_label');

%% Creating vars Training

% Training - uncoment to run training
% pow_value = zeros(:,30,101);
path_matrices_psd = ('./Matrizes/psd/');

pow_value = freq.powspctrm; % (165 x 18 x 101) -> (trial x ch x freq)
% pow_rtOA_an_t(:,:,:,26+lin_idx(end)) = freq.powspctrm(1:165,:,:); % (165 x 18 x 101) -> (trial x ch x freq)
save([path_matrices_psd,'subj',data(8:9),'/',data(10:(end-4)),'/','/pow_value.mat'],'pow_value');

%% Calling functions to calculate psd per region 

disp( ' ');
disp(' ********************* Calling Ociptal *********************** ');
disp( ' ');

%ociptal %rt
ociptal_t %training