close all
clear all
addpath('functions')



errors=[1.6352,2.2925,2.1837,1.7969];
d=[1.7572,1.7454,1.9304,1.4285];

figure 
h=bar(1:1:4,errors,0.5);
hold on
h2=errorbar(1:1:4,errors,d,d);
h2.Color = [0 0 0];                            
h2.LineStyle = 'none';  
h2.LineWidth=0.8;


xticklabels({'24';'26';'28';'30'})
set(gca,'FontSize',12,'fontname','Times New Roman');
set(gcf,'Position', [100 100 350 250]); 
xlabel('发送功率(dBm)','Fontsize',12,'fontname','SimHei');
ylabel('温度误差(\circC)','Fontsize',12,'fontname','SimHei');
ylim([0 5])

