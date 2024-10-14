function [res] = mvpa_across_time(class1,class2,chnls,classifier,folds,metric,repeat,titlename,categories)

%     class1 = mnh{1}; class2 = mmh{1}; chnls= 'all'; classifier='lda';folds=5;metric='accuracy';repeat=1;
    cfg = [];
    cfg.channel     = chnls;
    class1 = ft_selectdata(cfg,class1);
    class2 = ft_selectdata(cfg,class2);
   
    for i=1:length(class1.trial)
        class1.trial{i} = movmean(class1.trial{i},12,2);
    end
    
    for i=1:length(class2.trial)
        class2.trial{i} = movmean(class2.trial{i},12,2);
    end
  

    dat = ft_appenddata(cfg, class1, class2);
    
    
    
    % Assuming your cell array is named 'cellArray'
    cellArray = dat.trial; % Replace 'yourCellArray' with the actual name of your cell array

    % Get the dimensions
    numTrials = length(cellArray); % This should be 205
    [numChannels, numTimes] = size(cellArray{1}); % This should be 126x200

    % Initialize the 3D array
    data3D = zeros(numTrials, numChannels, numTimes);
%     data3D = zeros(numTrials, numTimes, numChannels);->across space

    % Loop through each trial and assign it to the 3D array
    for i = 1:numTrials
        data3D(i, :, :) = cellArray{i};%(cellArray{i})' -> across space
    end
    
    dat.trial = data3D;
    clabel           = [ones(length(class1.time),1); 2*ones(length(class2.time),1)];
    pparam = mv_get_preprocess_param('oversample');
    fprintf('Number of samples in each class before oversampling: %d %d\n', arrayfun(@(c) sum(clabel==c), 1:max(clabel)))
    [~, dat.trial, clabel] = mv_preprocess_oversample(pparam, dat.trial, clabel);
    fprintf('Number of samples in each class after oversampling: %d %d\n', arrayfun(@(c) sum(clabel==c), 1:max(clabel)))


    cfg = [] ; 
    start_time = 1; %25*1000/250 = 100 ms
    end_time = 200; %200*4 = 800 ms
    cfg.method           = 'mvpa';
    cfg.classifier = classifier;
    cfg.channel = chnls;
%     cfg.latency= latency; -> across space
    cfg.features  = 'chan';
    cfg.metric = metric;
    cfg.cv = 'kfold';
    cfg.k = folds;
    cfg.repeat = repeat;
    cfg.time          = start_time:end_time;
    [~, res] = mv_classify_across_time(cfg, dat.trial, clabel);
    res.perf = res.perf  - mean(res.perf(1:50)) + 0.5;
    
    mv_plot_result(res,dat.time{1}(start_time:end_time))

%     [~, res] = mv_classify(cfg, dat.trial, clabel);
%     mv_plot_result(res,dat.time{1}(start_time:end_time))
    title(sprintf('%s (%s)',titlename, categories))
%     saveas(gcf,sprintf('mni_mmi_mvpa_across_time_frontal_%s.png',categories(1:5)))

%     
end