close all
clear all

data=[];
[b,c]=my_fun_ling('1230509');
a=30*ones(length(b),1);
data=[data;[a,b,c]];
[b,c]=my_fun_ling('6230510');
a=28*ones(length(b),1);
data=[data;[a,b,c]];
[b,c]=my_fun_ling('2230511');
a=26*ones(length(b),1);
data=[data;[a,b,c]];
[b,c]=my_fun_ling('7230510');
a=24*ones(length(b),1);
data=[data;[a,b,c]];
1;

function [temps,times] = my_fun_ling(date)
data_path =  [ 'RFIDdata' filesep date(1:1) 'data' date(2:7) filesep];
file_names = dir(data_path);
temps=[];
times=[];


for i = 3:length(file_names)
    data_name = file_names(i).name;
    temperature1 = str2num(data_name(1:5));
    temperature2 = str2num(data_name(7:11));
    temperature=(temperature1+temperature2)/2;
    temps=[temps;temperature];
    ptime_data = load([data_path data_name]);
    index=ptime_data(:,1)==1;
    ptime_subdata=ptime_data(index,:);
    times=[times;length(ptime_subdata)];
end
end