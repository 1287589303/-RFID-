close all
clear all
addpath('functions')

errors=[1.7969,1.5878,1.4050,1.5958,1.6461];
d=[1.4285,1.2042,0.9364,1.0410,1.1786];


figure 
h=bar(1:1:5,errors,0.5);
hold on
h2=errorbar(1:1:5,errors,d,d);
h2.Color = [0 0 0];                            
h2.LineStyle = 'none';  
h2.LineWidth=0.8;


xticklabels({'15';'30';'45';'60';'75'})
set(gca,'FontSize',12,'fontname','Times New Roman');
set(gcf,'Position', [100 100 350 250]); 
xlabel('天线与标签之间的距离(cm)','Fontsize',12,'fontname','SimHei');
ylabel('温度误差(\circC)','Fontsize',12,'fontname','SimHei');
ylim([0 5])

