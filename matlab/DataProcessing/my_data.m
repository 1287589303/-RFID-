close all
clear all

train_data = [];
[a,b,c]=my_fun_synchronize_data('1230509');
train_data=[train_data;[a,b,c]];


temp_col = 1;
ptime_col = 2;
epc_col = 3;
train_data20 = [];
epcs = unique(train_data(:,epc_col));
for i = 1:length(epcs)
    % Select the i-th tag
    index = train_data(:,epc_col) == epcs(i);
    % Change its ID to i
    subdata = train_data(index,:)
    subdata(:,epc_col) = i;
    train_data20 = [train_data20;subdata];
end
train_data = train_data20;
mkdir(['data' filesep 'training' filesep]);
filename =  ['data' filesep 'training' filesep 'MonzaR6.mat'];
save(filename,'train_data')

test_data = [];
[a,b,c]=my_fun_synchronize_data('2230511');
test_data=[test_data;[a,b,c]];


% Map the tag ID to 1-20
temp_col = 1;
ptime_col = 2;
epc_col = 3;
train_data20 = [];
epcs = unique(test_data(:,epc_col));
for i = 1:length(epcs)
    % Select the i-th tag
    index = test_data(:,epc_col) == epcs(i);
    % Change its ID to i
    subdata = test_data(index,:)
    subdata(:,epc_col) = i;
    train_data20 = [train_data20;subdata];
end
test_data = train_data20;
mkdir(['data' filesep 'testing' filesep]);
filename =  ['data' filesep 'testing' filesep 'MonzaR6.mat'];
save(filename,'test_data')


function [temps,ptimes,IDs] = my_fun_synchronize_data(date)
time_col = 4;
data_path =  [ 'RFIDdata' filesep date(1:1) 'data' date(2:7) filesep];
file_names = dir(data_path);
temp_filename = file_names(3).name ;
temps = [];
ptimes = [];
IDs= [];

for i = 3:length(file_names)
    data_name = file_names(i).name;
    temperature1 = str2num(data_name(1:5));
    temperature2 = str2num(data_name(7:11));
    temperature=(temperature1+temperature2)/2;
    ptime_data = load([data_path data_name]);
    epcs= ptime_data(:,1);
    epc_set = unique(epcs);
    for j = 1:length(epc_set)
        index=ptime_data(:,1)==epc_set(j);
        ptime_subdata=ptime_data(index,:);
        times = ptime_subdata(:,time_col)/1000;
        time_dif = times(2:end) - times(1:end-1);
        index = fun_diff(time_dif,1);
        time_dif = time_dif(logical(index));
        tems = temperature*ones(length(times),1);
        tems=tems(index,:);
        ids=ones(length(times),1);
        if epc_set(j)== 1
            ids=1*ids;
        elseif epc_set(j)== 11
            ids=2*ids;
        elseif epc_set(j)==100
            ids=3*ids;
        elseif epc_set(j)==101
            ids=4*ids;
        end
        ids=ids(index,:);
        temps = [temps;tems];
        ptimes = [ptimes;time_dif];
        IDs = [IDs; ids];
    end
end
end

function [index] = fun_diff(time_diff,lim)
% Remove noisy data. 
label = 1;
index =zeros(length(time_diff),1);
i =1;
while(i<length(time_diff))
    startpoint = i;
    while i<=length(time_diff)&time_diff(i)<10
        if time_diff(i)>lim
            label = 0;
        end
        i=i+1;
    end
    if label
        if max(time_diff(startpoint:i-1))-min(time_diff(startpoint:i-1))>0.1|i-startpoint<6
            index(startpoint:i-1) = 0;
        else
            index(startpoint:i-1) = 1;
        end
    else
        index(startpoint:i-1) = 0;
    end
    label =1;
    i = i+1;
end
index = logical(index);
end

