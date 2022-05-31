%% Load data and only use the year 2020
clear all
clc
A=readtable('Data_IER_2022.csv');
A_new=A(:,[1 2 3 4 5 44 48 52 56 60 64 68 97 98 99 100 101 102 103]);
B=A_new(95:193,:); %all 2020 data

N=height(B); %sample size 2020 participants
%% Replace Yes with 1
old="Yes";
new="1";
B.wear_1=str2double(replace(B.wear_1,old,new));
B.wear_2=str2double(replace(B.wear_2,old,new));
B.wear_3=str2double(replace(B.wear_3,old,new));
B.wear_4=str2double(replace(B.wear_4,old,new));
B.wear_5=str2double(replace(B.wear_5,old,new));
B.wear_6=str2double(replace(B.wear_6,old,new));
B.wear_7=str2double(replace(B.wear_7,old,new));
%% NaN to 0 , every unsure or no is replaced as 0
mask1 = isnan(B.wear_1);
mask2 = isnan(B.wear_2);
mask3 = isnan(B.wear_3);
mask4 = isnan(B.wear_4);
mask5 = isnan(B.wear_5);
mask6 = isnan(B.wear_6);
mask7 = isnan(B.wear_7);
B.wear_1(mask1) = 0;
B.wear_2(mask2) = 0;
B.wear_3(mask3) = 0;
B.wear_4(mask4) = 0;
B.wear_5(mask5) = 0;
B.wear_6(mask6) = 0;
B.wear_7(mask7) = 0;

%% Count of wearing Omron (yes=1)
yes_counter=zeros(N,1);
for i=1:N
yes_counter(i,1)=B.wear_1(i)+B.wear_2(i)+B.wear_3(i)+B.wear_4(i)+B.wear_5(i)+B.wear_6(i)+B.wear_7(i);
end
B.Count=yes_counter;

%% High-pass filter participants; only 4 days and more
idx = B.Count >= 4;
C=B(idx,:);
%% Remove aerobic steps of each day when omrom not worn >10 hours
L=height(C); %sample size participants >4 days 
for k=1:L
    if  C.wear_1(k) == 0
        C.stap_om_1_aer(k)=0;
    else C.wear_1(k) = C.wear_1(k);
    end
        if  C.wear_2(k) == 0
        C.stap_om_2_aer(k)=0;
    else C.wear_2(k) = C.wear_2(k);
        end
        if  C.wear_3(k) == 0
        C.stap_om_3_aer(k)=0;
    else C.wear_3(k) = C.wear_3(k);
        end
        if  C.wear_4(k) == 0
        C.stap_om_4_aer(k)=0;
    else C.wear_4(k) = C.wear_4(k);
        end
        if  C.wear_5(k) == 0
        C.stap_om_5_aer(k)=0;
    else C.wear_5(k) = C.wear_5(k);
        end
        if  C.wear_6(k) == 0
        C.stap_om_6_aer(k)=0;
    else C.wear_6(k) = C.wear_6(k);
        end
        if  C.wear_7(k) == 0
        C.stap_om_7_aer(k)=0;
    else C.wear_7(k) = C.wear_7(k);
    end
end
    
%% Average daily aerobic steps 
M=height(C); %sample size participants that worn Omron 10+ hours for at least 4 days or more 
avg=zeros(M,1);
for j=1:M
    avg(j)=(C.stap_om_1_aer(j)+C.stap_om_2_aer(j)+C.stap_om_3_aer(j)+C.stap_om_4_aer(j)+C.stap_om_5_aer(j)+C.stap_om_6_aer(j)+C.stap_om_7_aer(j))/C.Count(j);
end
C.avg=avg;

%% Replace 'Moved out' sample with 1 to divide 'Moved out' and 'Living with parents'
D=C;
old2="Moved_out"; 
new2="1";
D.living=str2double(replace(D.living,old2,new2));
idx2 = D.living == 1;
moved_out=D(idx2,:);

mask_D = isnan(D.living);
D.living(mask_D) = 0;

idx3 = D.living == 0;
living_at_parents=D(idx3,:);


%% Histograms; check if data is normally distributed or not
figure();
subplot(1,2,1)
histogram(moved_out.avg,'FaceColor','k') %
title('Moved out (n=37)')
xlabel('Range of aerobic steps')
ylabel('Number of participants')
legend('Participants')
subplot(1,2,2)
histogram(living_at_parents.avg,'FaceColor','k') %
title('Living with parents (n=50)')
xlabel('Range of aerobic steps')
legend('Participants')

%% Mann-Whitney U test / Wilcoxon rank sum test

[p,h,stats] = ranksum(moved_out.avg,living_at_parents.avg,'method','exact'); 

h %The result h = 1 indicates a rejection of the null hypothesis, 
  %and h = 0 indicates a failure to reject the null hypothesis at the 5% significance level.
%% Results aerobic steps

median_moved_out=median(moved_out.avg);

median_living_at_parents=median(living_at_parents.avg);

%% BMI
pd_bmi_moved_out=fitdist(moved_out.bmi, 'Normal');
ci_bmi_moved_out=paramci(pd_bmi_moved_out);

pd_bmi_living_at_parents=fitdist(living_at_parents.bmi, 'Normal');
ci_bmi_living_at_parents=paramci(pd_bmi_living_at_parents);

%% Table 1 Demographics 
% 
Demographics = {'n'; 'Males (%)'; 'Females (%)'; 'Undefined (%)'};
Moved_out_dem = [37; 30; 59; 11];
Living_with_parents_dem = [50; 34; 56; 10];

T_1=table(Demographics, Moved_out_dem, Living_with_parents_dem);

%% Table 2 BMI comparison
BMI= {'Body Mass Index (BMI), kg*m^-2'};
Mean_1=[pd_bmi_moved_out.mu];
SD_1= [pd_bmi_moved_out.sigma];
CI_1_lower= [ci_bmi_moved_out(1,1)];
CI_1_upper= [ci_bmi_moved_out(2,1)];

Mean_2=[pd_bmi_living_at_parents.mu];
SD_2= [pd_bmi_living_at_parents.sigma];
CI_2_lower= [ci_bmi_living_at_parents(1,1)];
CI_2_upper= [ci_bmi_living_at_parents(2,1)];

Moved_out_bmi= table(Mean_1, SD_1,CI_1_lower,CI_1_upper);
Living_with_parents_bmi= table(Mean_2, SD_2,CI_2_lower,CI_2_upper);

[h_bmi,p_bmi] = ttest2(moved_out.bmi,living_at_parents.bmi,'Vartype','unequal');

p_bmi=[p_bmi];
test_bmi={'two-sample t-test'};

T_2= table(BMI,Moved_out_bmi,Living_with_parents_bmi,p_bmi,test_bmi);

%% Table 3 Statistical outcomes (aerobic steps)

Moved_out_aer= table(median_moved_out);
Living_with_parents_aer= table(median_living_at_parents);
p_aer=[p];
test_aer={'Mann-Whitney U test'};
Daily_aerobic_steps= {'Daily aerobic steps (median)'};
T_3= table(Daily_aerobic_steps,Moved_out_aer,Living_with_parents_aer,p_aer,test_aer);
