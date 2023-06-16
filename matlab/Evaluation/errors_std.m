close all
clear all
addpath('functions')
load(['data' filesep 'testing' filesep 'MonzaR6.mat'])
epcs = unique(test_data(:,3));

errors = [];
for i = 1:length(epcs)
    [a,b,c]= fun_get_error(i);
    errors=[errors;a];
end



mean_error=mean(errors);
mean_d=std(errors);

1;