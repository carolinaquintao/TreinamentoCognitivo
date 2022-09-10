function  [v,v_teta,v_alfa,v_beta] = create_vectors_s11d(Folder,subj)
% The function of cellfun should create, for fatigated and normal state , per trial, the
% vectors of alfa, teta, beta, holm and eoh and store in separate cells 
% both will after will be concatenated.

%teste
% subj = 'subj01';

% to run for both fatigated and normalstate
regions = dir(fullfile(Folder,subj,'regions'));
dirFlags = ~[regions.isdir]& ~strcmp({regions.name},'.') & ~strcmp({regions.name},'..');
regions = regions(dirFlags);
regions = {regions.name}.';

% regions = struct2cell(regions);
% regions = regions(1,3:end) % To take just the subjects names
% regions = regions.'%names of subjects

% data of all regions of each subject
data = cell(2,length(regions));

%% For states
    for i = 1:length(regions)% for regions (1:6)
        
        f_path = fullfile(Folder,subj,'regions');
        
            l = load(fullfile(f_path,regions{i})); % get the name of file to load
            
            %helper to get the variable of file
            helper = eval(['l.',regions{i}(1:end-4)]);
            fim = size(helper,1);
            % Minutes division per trials 
            % 2700 trials  ->  45 min 
            % 1 - 300 trials -> first 5 minutes
            % 2400 - 2700 -> last 5 minutes
            
            data{1,i} = helper(1:300,:,:); % 5 first minutes
            data{2,i} = helper(fim-299:end,:,:); % 5 last minutes
 
            % for each state
            %concatenate all regions 
            v{1} = [data{1,1:6}];% 300 x 19 x 30  %first 5 minutes 
            v{2} = [data{2,1:6}];% 300 x 19 x 30  % last 5 minutes
%     end     
    end
    
%%
    
    % taking 
    for k = 1:2
        a = cell2mat(v(k));
        v_teta{k} = a(:,:,5:9); %300 x 5 x 30
        v_alfa{k} = a(:,:,9:13); 
        v_beta{k} = a(:,:,13:end);      
    end
    

end

