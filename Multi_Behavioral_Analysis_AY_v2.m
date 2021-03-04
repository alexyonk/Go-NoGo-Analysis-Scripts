%%% -- This script is designed to analyze the output from the Multi_Behavior_Sort_AY script.



%                               *Created on 04_08_20 by AY*
%                               *Updated by AY on 3_4_21*

clear;
clc;

%Prompts user to select the appropriate directory
start_dir = uigetdir;
cd(start_dir);

%Load in the sorted data structure
load('Multi_Behavior_Sort.mat');

% Counts the number of sessions within the datastructure
count = numel(fieldnames(datastructure));
x = 1;

% Prompts user to input how each file will be analyze (e.g. no analysis,
% LED setting 1 analysis, or LED setting 2 analysis). Creates a variable
% that stores these choices
for i = 1:count
   Decision(1,x) = str2num(cell2mat(inputdlg('THIS MESSAGE WILL APPEAR UP TO 8 TIMES!!!!!! Each appearance represents a different session. Please input one number (0, 1, or 2) for each session! For no analysis, enter 0. For LED setting 1 (start on trial 101), enter 1. For LED setting 2 (start on trial 111), enter 2.')));
   x = x + 1; 
end

x = 1;

for i = 1:count
    if i == 1
        datastructure.Session1.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session1.BaseData = [];
            RTs = [sum(datastructure.Session1.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session1.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session1.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session1.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session1.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session1.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session1.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session1.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session1.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session1.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session1.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session1.FinalData(1,1) = ((datastructure.Session1.BaseData(1,1)) / (datastructure.Session1.BaseData(1,1) + datastructure.Session1.BaseData(3,1))) - 0.0001;
            datastructure.Session1.FinalData(1,2) = ((datastructure.Session1.BaseData(4,1)) / (datastructure.Session1.BaseData(4,1) + datastructure.Session1.BaseData(2,1))) + 0.0001;
            datastructure.Session1.FinalData(1,3) = (norminv(datastructure.Session1.FinalData(1,1)) - norminv(datastructure.Session1.FinalData(1,2)));
            datastructure.Session1.FinalData(1,4) = 0.5 * (norminv(datastructure.Session1.FinalData(1,1)) + norminv(datastructure.Session1.FinalData(1,2)));
            datastructure.Session1.FinalData(1,5) = datastructure.Session1.BaseData(5,1);
            datastructure.Session1.FinalData(1,6) = datastructure.Session1.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session1.BasePercData = [];
            RTs = [sum(datastructure.Session1.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session1.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session1.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session1.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session1.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session1.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session1.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session1.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session1.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session1.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session1.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session1.LedOff(Y:Z,:) = datastructure.Session1.DataAnalysis(112+X:121+X,:);
                datastructure.Session1.LedOn(Y:Z,:) = datastructure.Session1.DataAnalysis(102+X:111+X,:);
                datastructure.Session1.Offperc(L,1) = (sum(datastructure.Session1.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session1.Offperc(L,2) = (sum(datastructure.Session1.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session1.Offperc(L,3) = (sum(datastructure.Session1.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session1.Offperc(L,4) = (sum(datastructure.Session1.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,1) = (sum(datastructure.Session1.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,2) = (sum(datastructure.Session1.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,3) = (sum(datastructure.Session1.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,4) = (sum(datastructure.Session1.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session1.Offperc(L,5) = sum(datastructure.Session1.LedOff(B:C,6));
                datastructure.Session1.Offperc(L,6) = sum(datastructure.Session1.LedOff(B:C,11));
                datastructure.Session1.Onperc(L,5) = sum(datastructure.Session1.LedOn(B:C,6));
                datastructure.Session1.Onperc(L,6) = sum(datastructure.Session1.LedOn(B:C,11));
                datastructure.Session1.TotalOffRTs(L,1) = sum(datastructure.Session1.LedOff(B:C,6) > 0);
                datastructure.Session1.TotalOffRTs(L,2) = sum(datastructure.Session1.LedOff(B:C,11) > 0);
                datastructure.Session1.TotalOnRTs(L,1) = sum(datastructure.Session1.LedOn(B:C,6) > 0);
                datastructure.Session1.TotalOnRTs(L,2) = sum(datastructure.Session1.LedOn(B:C,11) > 0);
                datastructure.Session1.Offperc(L,5) = (datastructure.Session1.Offperc(L,5) / datastructure.Session1.TotalOffRTs(L,1));
                datastructure.Session1.Offperc(L,6) = (datastructure.Session1.Offperc(L,6) / datastructure.Session1.TotalOffRTs(L,2));
                datastructure.Session1.Onperc(L,5) = (datastructure.Session1.Onperc(L,5) / datastructure.Session1.TotalOnRTs(L,1));
                datastructure.Session1.Onperc(L,6) = (datastructure.Session1.Onperc(L,6) / datastructure.Session1.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session1.Offperc(isnan(datastructure.Session1.Offperc)) = 0;
            datastructure.Session1.Onperc(isnan(datastructure.Session1.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session1.OffData(L,1) = (datastructure.Session1.Offperc(M,1) / (datastructure.Session1.Offperc(M,1) + datastructure.Session1.Offperc(M,3)));
                datastructure.Session1.OffData(L,2) = (datastructure.Session1.Offperc(M,4) / (datastructure.Session1.Offperc(M,4) + datastructure.Session1.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session1.OffData(L,1) == 1
                    datastructure.Session1.OffData(L,1) = datastructure.Session1.OffData(L,1) - 0.0001;
                end
                if datastructure.Session1.OffData(L,1) == 0
                    datastructure.Session1.OffData(L,1) = datastructure.Session1.OffData(L,1) + 0.0001;
                end
                if datastructure.Session1.OffData(L,2) == 1
                    datastructure.Session1.OffData(L,2) = datastructure.Session1.OffData(L,2) - 0.0001;
                end
                if datastructure.Session1.OffData(L,2) == 0
                    datastructure.Session1.OffData(L,2) = datastructure.Session1.OffData(L,2) + 0.0001;
                end
                datastructure.Session1.OffData(L,3) = (norminv(datastructure.Session1.OffData(M,1)) - norminv(datastructure.Session1.OffData(M,2)));
                datastructure.Session1.OffData(L,4) = 0.5 * (norminv(datastructure.Session1.OffData(M,1)) + norminv(datastructure.Session1.OffData(M,2)));
                datastructure.Session1.OnData(L,1) = (datastructure.Session1.Onperc(M,1) / (datastructure.Session1.Onperc(M,1) + datastructure.Session1.Onperc(M,3)));
                datastructure.Session1.OnData(L,2) = (datastructure.Session1.Onperc(M,4) / (datastructure.Session1.Onperc(M,4) + datastructure.Session1.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session1.OnData(L,1) == 1
                    datastructure.Session1.OnData(L,1) = datastructure.Session1.OnData(L,1) - 0.0001;
                end
                if datastructure.Session1.OnData(L,1) == 0
                    datastructure.Session1.OnData(L,1) = datastructure.Session1.OnData(L,1) + 0.0001;
                end
                if datastructure.Session1.OnData(L,2) == 1
                    datastructure.Session1.OnData(L,2) = datastructure.Session1.OnData(L,2) - 0.0001;
                end
                if datastructure.Session1.OnData(L,2) == 0
                    datastructure.Session1.OnData(L,2) = datastructure.Session1.OnData(L,2) + 0.0001;
                end
                datastructure.Session1.OnData(L,3) = (norminv(datastructure.Session1.OnData(M,1)) - norminv(datastructure.Session1.OnData(M,2)));
                datastructure.Session1.OnData(L,4) = 0.5 * (norminv(datastructure.Session1.OnData(M,1)) + norminv(datastructure.Session1.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session1.FinalData = [datastructure.Session1.OffData datastructure.Session1.Offperc(:,5:6) datastructure.Session1.OnData datastructure.Session1.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session1.BasePercData = [];
            RTs = [sum(datastructure.Session1.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session1.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session1.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session1.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session1.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session1.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session1.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session1.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session1.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session1.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session1.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART]
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session1.LedOff(1:10,1:12) = datastructure.Session1.DataAnalysis(102:111,1:12);
            datastructure.Session1.LedOff(11:20,1:12) = datastructure.Session1.DataAnalysis(122:131,1:12);
            datastructure.Session1.LedOff(21:40,1:12) = datastructure.Session1.DataAnalysis(142:161,1:12);
            datastructure.Session1.LedOff(41:50,1:12) = datastructure.Session1.DataAnalysis(172:181,1:12);
            datastructure.Session1.LedOff(51:60,1:12) = datastructure.Session1.DataAnalysis(192:201,1:12);
            datastructure.Session1.LedOn(1:10,1:12) = datastructure.Session1.DataAnalysis(112:121,1:12);
            datastructure.Session1.LedOn(11:20,1:12) = datastructure.Session1.DataAnalysis(132:141,1:12);
            datastructure.Session1.LedOn(21:30,1:12) = datastructure.Session1.DataAnalysis(162:171,1:12);
            datastructure.Session1.LedOn(31:40,1:12) = datastructure.Session1.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session1.Offperc(L,1) = (sum(datastructure.Session1.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session1.Offperc(L,2) = (sum(datastructure.Session1.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session1.Offperc(L,3) = (sum(datastructure.Session1.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session1.Offperc(L,4) = (sum(datastructure.Session1.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session1.Offperc(L,5) = sum(datastructure.Session1.LedOff(B:C,6));
                datastructure.Session1.Offperc(L,6) = sum(datastructure.Session1.LedOff(B:C,11));
                datastructure.Session1.TotalOffRTs(L,1) = sum(datastructure.Session1.LedOff(B:C,6) > 0);
                datastructure.Session1.TotalOffRTs(L,2) = sum(datastructure.Session1.LedOff(B:C,11) > 0);
                datastructure.Session1.Offperc(L,5) = (datastructure.Session1.Offperc(L,5) / datastructure.Session1.TotalOffRTs(L,1));
                datastructure.Session1.Offperc(L,6) = (datastructure.Session1.Offperc(L,6) / datastructure.Session1.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session1.Onperc(L,1) = (sum(datastructure.Session1.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,2) = (sum(datastructure.Session1.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,3) = (sum(datastructure.Session1.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,4) = (sum(datastructure.Session1.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session1.Onperc(L,5) = sum(datastructure.Session1.LedOn(B:C,6));
                datastructure.Session1.Onperc(L,6) = sum(datastructure.Session1.LedOn(B:C,11));
                datastructure.Session1.TotalOnRTs(L,1) = sum(datastructure.Session1.LedOn(B:C,6) > 0);
                datastructure.Session1.TotalOnRTs(L,2) = sum(datastructure.Session1.LedOn(B:C,11) > 0);
                datastructure.Session1.Onperc(L,5) = (datastructure.Session1.Onperc(L,5) / datastructure.Session1.TotalOnRTs(L,1));
                datastructure.Session1.Onperc(L,6) = (datastructure.Session1.Onperc(L,6) / datastructure.Session1.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session1.Offperc(isnan(datastructure.Session1.Offperc)) = 0;
            datastructure.Session1.Onperc(isnan(datastructure.Session1.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session1.OffData(L,1) = (datastructure.Session1.Offperc(M,1) / (datastructure.Session1.Offperc(M,1) + datastructure.Session1.Offperc(M,3)));
                datastructure.Session1.OffData(L,2) = (datastructure.Session1.Offperc(M,4) / (datastructure.Session1.Offperc(M,4) + datastructure.Session1.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session1.OffData(L,1) == 1
                    datastructure.Session1.OffData(L,1) = datastructure.Session1.OffData(L,1) - 0.0001;
                end
                if datastructure.Session1.OffData(L,1) == 0
                    datastructure.Session1.OffData(L,1) = datastructure.Session1.OffData(L,1) + 0.0001;
                end
                if datastructure.Session1.OffData(L,2) == 1
                    datastructure.Session1.OffData(L,2) = datastructure.Session1.OffData(L,2) - 0.0001;
                end
                if datastructure.Session1.OffData(L,2) == 0
                    datastructure.Session1.OffData(L,2) = datastructure.Session1.OffData(L,2) + 0.0001;
                end
                datastructure.Session1.OffData(L,3) = (norminv(datastructure.Session1.OffData(M,1)) - norminv(datastructure.Session1.OffData(M,2)));
                datastructure.Session1.OffData(L,4) = 0.5 * (norminv(datastructure.Session1.OffData(M,1)) + norminv(datastructure.Session1.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session1.OnData(L,1) = (datastructure.Session1.Onperc(M,1) / (datastructure.Session1.Onperc(M,1) + datastructure.Session1.Onperc(M,3)));
                datastructure.Session1.OnData(L,2) = (datastructure.Session1.Onperc(M,4) / (datastructure.Session1.Onperc(M,4) + datastructure.Session1.Onperc(M,2)));
                if datastructure.Session1.OnData(L,1) == 1
                    datastructure.Session1.OnData(L,1) = datastructure.Session1.OnData(L,1) - 0.0001;
                end
                if datastructure.Session1.OnData(L,1) == 0
                    datastructure.Session1.OnData(L,1) = datastructure.Session1.OnData(L,1) + 0.0001;
                end
                if datastructure.Session1.OnData(L,2) == 1
                    datastructure.Session1.OnData(L,2) = datastructure.Session1.OnData(L,2) - 0.0001;
                end
                if datastructure.Session1.OnData(L,2) == 0
                    datastructure.Session1.OnData(L,2) = datastructure.Session1.OnData(L,2) + 0.0001;
                end
                datastructure.Session1.OnData(L,3) = (norminv(datastructure.Session1.OnData(M,1)) - norminv(datastructure.Session1.OnData(M,2)));
                datastructure.Session1.OnData(L,4) = 0.5 * (norminv(datastructure.Session1.OnData(M,1)) + norminv(datastructure.Session1.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session1.FinalData = [datastructure.Session1.OffData(1:4,:) datastructure.Session1.Offperc(1:4,5:6) datastructure.Session1.OnData datastructure.Session1.Onperc(1:4,5:6)];
            x = x + 1;   
        end
        

%% Start Session 2





        
    elseif i == 2
        datastructure.Session2.AnalysisSetting = Decision(1,x);
        
        if Decision(1,x) == 0
            datastructure.Session2.BaseData = [];
            RTs = [sum(datastructure.Session2.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session2.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session2.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session2.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session2.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session2.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session2.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session2.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session2.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session2.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session2.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];

            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 2
            datastructure.Session2.FinalData(1,1) = ((datastructure.Session2.BaseData(1,1)) / (datastructure.Session2.BaseData(1,1) + datastructure.Session2.BaseData(3,1))) - 0.0001;
            datastructure.Session2.FinalData(1,2) = ((datastructure.Session2.BaseData(4,1)) / (datastructure.Session2.BaseData(4,1) + datastructure.Session2.BaseData(2,1))) + 0.0001;
            datastructure.Session2.FinalData(1,3) = (norminv(datastructure.Session2.FinalData(1,1)) - norminv(datastructure.Session2.FinalData(1,2)));
            datastructure.Session2.FinalData(1,4) = 0.5 * (norminv(datastructure.Session2.FinalData(1,1)) + norminv(datastructure.Session2.FinalData(1,2)));
            datastructure.Session2.FinalData(1,5) = datastructure.Session2.BaseData(5,1);
            datastructure.Session2.FinalData(1,6) = datastructure.Session2.BaseData(6,1);
            x = x + 1;

        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session2.BasePercData = [];
            RTs = [sum(datastructure.Session2.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session2.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session2.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session2.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session2.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session2.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session2.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session2.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session2.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session2.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session2.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session2.LedOff(Y:Z,:) = datastructure.Session2.DataAnalysis(112+X:121+X,:);
                datastructure.Session2.LedOn(Y:Z,:) = datastructure.Session2.DataAnalysis(102+X:111+X,:);
                datastructure.Session2.Offperc(L,1) = (sum(datastructure.Session2.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session2.Offperc(L,2) = (sum(datastructure.Session2.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session2.Offperc(L,3) = (sum(datastructure.Session2.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session2.Offperc(L,4) = (sum(datastructure.Session2.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session2.Onperc(L,1) = (sum(datastructure.Session2.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session2.Onperc(L,2) = (sum(datastructure.Session2.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session2.Onperc(L,3) = (sum(datastructure.Session2.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session2.Onperc(L,4) = (sum(datastructure.Session2.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session2.Offperc(L,5) = sum(datastructure.Session2.LedOff(B:C,6));
                datastructure.Session2.Offperc(L,6) = sum(datastructure.Session2.LedOff(B:C,11));
                datastructure.Session2.Onperc(L,5) = sum(datastructure.Session2.LedOn(B:C,6));
                datastructure.Session2.Onperc(L,6) = sum(datastructure.Session2.LedOn(B:C,11));
                datastructure.Session2.TotalOffRTs(L,1) = sum(datastructure.Session2.LedOff(B:C,6) > 0);
                datastructure.Session2.TotalOffRTs(L,2) = sum(datastructure.Session2.LedOff(B:C,11) > 0);
                datastructure.Session2.TotalOnRTs(L,1) = sum(datastructure.Session2.LedOn(B:C,6) > 0);
                datastructure.Session2.TotalOnRTs(L,2) = sum(datastructure.Session2.LedOn(B:C,11) > 0);
                datastructure.Session2.Offperc(L,5) = (datastructure.Session2.Offperc(L,5) / datastructure.Session2.TotalOffRTs(L,1));
                datastructure.Session2.Offperc(L,6) = (datastructure.Session2.Offperc(L,6) / datastructure.Session2.TotalOffRTs(L,2));
                datastructure.Session2.Onperc(L,5) = (datastructure.Session2.Onperc(L,5) / datastructure.Session2.TotalOnRTs(L,1));
                datastructure.Session2.Onperc(L,6) = (datastructure.Session2.Onperc(L,6) / datastructure.Session2.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session2.Offperc(isnan(datastructure.Session2.Offperc)) = 0;
            datastructure.Session2.Onperc(isnan(datastructure.Session2.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session2.OffData(L,1) = (datastructure.Session2.Offperc(M,1) / (datastructure.Session2.Offperc(M,1) + datastructure.Session2.Offperc(M,3)));
                datastructure.Session2.OffData(L,2) = (datastructure.Session2.Offperc(M,4) / (datastructure.Session2.Offperc(M,4) + datastructure.Session2.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session2.OffData(L,1) == 1
                    datastructure.Session2.OffData(L,1) = datastructure.Session2.OffData(L,1) - 0.0001;
                end
                if datastructure.Session2.OffData(L,1) == 0
                    datastructure.Session2.OffData(L,1) = datastructure.Session2.OffData(L,1) + 0.0001;
                end
                if datastructure.Session2.OffData(L,2) == 1
                    datastructure.Session2.OffData(L,2) = datastructure.Session2.OffData(L,2) - 0.0001;
                end
                if datastructure.Session2.OffData(L,2) == 0
                    datastructure.Session2.OffData(L,2) = datastructure.Session2.OffData(L,2) + 0.0001;
                end
                datastructure.Session2.OffData(L,3) = (norminv(datastructure.Session2.OffData(M,1)) - norminv(datastructure.Session2.OffData(M,2)));
                datastructure.Session2.OffData(L,4) = 0.5 * (norminv(datastructure.Session2.OffData(M,1)) + norminv(datastructure.Session2.OffData(M,2)));
                datastructure.Session2.OnData(L,1) = (datastructure.Session2.Onperc(M,1) / (datastructure.Session2.Onperc(M,1) + datastructure.Session2.Onperc(M,3)));
                datastructure.Session2.OnData(L,2) = (datastructure.Session2.Onperc(M,4) / (datastructure.Session2.Onperc(M,4) + datastructure.Session2.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session2.OnData(L,1) == 1
                    datastructure.Session2.OnData(L,1) = datastructure.Session2.OnData(L,1) - 0.0001;
                end
                if datastructure.Session2.OnData(L,1) == 0
                    datastructure.Session2.OnData(L,1) = datastructure.Session2.OnData(L,1) + 0.0001;
                end
                if datastructure.Session2.OnData(L,2) == 1
                    datastructure.Session2.OnData(L,2) = datastructure.Session2.OnData(L,2) - 0.0001;
                end
                if datastructure.Session2.OnData(L,2) == 0
                    datastructure.Session2.OnData(L,2) = datastructure.Session2.OnData(L,2) + 0.0001;
                end
                datastructure.Session2.OnData(L,3) = (norminv(datastructure.Session2.OnData(M,1)) - norminv(datastructure.Session2.OnData(M,2)));
                datastructure.Session2.OnData(L,4) = 0.5 * (norminv(datastructure.Session2.OnData(M,1)) + norminv(datastructure.Session2.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session2.FinalData = [datastructure.Session2.OffData datastructure.Session2.Offperc(:,5:6) datastructure.Session2.OnData datastructure.Session2.Onperc(:,5:6)];
            x = x + 1;
            
    else Decision(1,x) = 2;
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session2.BasePercData = [];
            RTs = [sum(datastructure.Session2.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session2.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session2.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session2.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session2.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session2.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session2.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session2.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session2.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session2.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session2.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session2.LedOff(1:10,1:12) = datastructure.Session2.DataAnalysis(102:111,1:12);
            datastructure.Session2.LedOff(11:20,1:12) = datastructure.Session2.DataAnalysis(122:131,1:12);
            datastructure.Session2.LedOff(21:40,1:12) = datastructure.Session2.DataAnalysis(142:161,1:12);
            datastructure.Session2.LedOff(41:50,1:12) = datastructure.Session2.DataAnalysis(172:181,1:12);
            datastructure.Session2.LedOff(51:60,1:12) = datastructure.Session2.DataAnalysis(192:201,1:12);
            datastructure.Session2.LedOn(1:10,1:12) = datastructure.Session2.DataAnalysis(112:121,1:12);
            datastructure.Session2.LedOn(11:20,1:12) = datastructure.Session2.DataAnalysis(132:141,1:12);
            datastructure.Session2.LedOn(21:30,1:12) = datastructure.Session2.DataAnalysis(162:171,1:12);
            datastructure.Session2.LedOn(31:40,1:12) = datastructure.Session2.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session2.Offperc(L,1) = (sum(datastructure.Session2.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session2.Offperc(L,2) = (sum(datastructure.Session2.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session2.Offperc(L,3) = (sum(datastructure.Session2.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session2.Offperc(L,4) = (sum(datastructure.Session2.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session2.Offperc(L,5) = sum(datastructure.Session2.LedOff(B:C,6));
                datastructure.Session2.Offperc(L,6) = sum(datastructure.Session2.LedOff(B:C,11));
                datastructure.Session2.TotalOffRTs(L,1) = sum(datastructure.Session2.LedOff(B:C,6) > 0);
                datastructure.Session2.TotalOffRTs(L,2) = sum(datastructure.Session2.LedOff(B:C,11) > 0);
                datastructure.Session2.Offperc(L,5) = (datastructure.Session2.Offperc(L,5) / datastructure.Session2.TotalOffRTs(L,1));
                datastructure.Session2.Offperc(L,6) = (datastructure.Session2.Offperc(L,6) / datastructure.Session2.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session2.Onperc(L,1) = (sum(datastructure.Session2.LedOn(J:K,7) == 1) / 10) * 100;
                datastructure.Session2.Onperc(L,2) = (sum(datastructure.Session2.LedOn(J:K,8) == 1) / 10) * 100;
                datastructure.Session2.Onperc(L,3) = (sum(datastructure.Session2.LedOn(J:K,9) == 1) / 10) * 100;
                datastructure.Session2.Onperc(L,4) = (sum(datastructure.Session2.LedOn(J:K,10) == 1) / 10) * 100;
                datastructure.Session2.Onperc(L,5) = sum(datastructure.Session2.LedOn(B:C,6));
                datastructure.Session2.Onperc(L,6) = sum(datastructure.Session2.LedOn(B:C,11));
                datastructure.Session2.TotalOnRTs(L,1) = sum(datastructure.Session2.LedOn(B:C,6) > 0);
                datastructure.Session2.TotalOnRTs(L,2) = sum(datastructure.Session2.LedOn(B:C,11) > 0);
                datastructure.Session2.Onperc(L,5) = (datastructure.Session2.Onperc(L,5) / datastructure.Session2.TotalOnRTs(L,1));
                datastructure.Session2.Onperc(L,6) = (datastructure.Session2.Onperc(L,6) / datastructure.Session2.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session2.Offperc(isnan(datastructure.Session2.Offperc)) = 0;
            datastructure.Session2.Onperc(isnan(datastructure.Session2.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session2.OffData(L,1) = (datastructure.Session2.Offperc(M,1) / (datastructure.Session2.Offperc(M,1) + datastructure.Session2.Offperc(M,3)));
                datastructure.Session2.OffData(L,2) = (datastructure.Session2.Offperc(M,4) / (datastructure.Session2.Offperc(M,4) + datastructure.Session2.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session2.OffData(L,1) == 1
                    datastructure.Session2.OffData(L,1) = datastructure.Session2.OffData(L,1) - 0.0001;
                end
                if datastructure.Session2.OffData(L,1) == 0
                    datastructure.Session2.OffData(L,1) = datastructure.Session2.OffData(L,1) + 0.0001;
                end
                if datastructure.Session2.OffData(L,2) == 1
                    datastructure.Session2.OffData(L,2) = datastructure.Session2.OffData(L,2) - 0.0001;
                end
                if datastructure.Session2.OffData(L,2) == 0
                    datastructure.Session2.OffData(L,2) = datastructure.Session2.OffData(L,2) + 0.0001;
                end
                datastructure.Session2.OffData(L,3) = (norminv(datastructure.Session2.OffData(M,1)) - norminv(datastructure.Session2.OffData(M,2)));
                datastructure.Session2.OffData(L,4) = 0.5 * (norminv(datastructure.Session2.OffData(M,1)) + norminv(datastructure.Session2.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session2.OnData(L,1) = (datastructure.Session2.Onperc(M,1) / (datastructure.Session2.Onperc(M,1) + datastructure.Session2.Onperc(M,3)));
                datastructure.Session2.OnData(L,2) = (datastructure.Session2.Onperc(M,4) / (datastructure.Session2.Onperc(M,4) + datastructure.Session2.Onperc(M,2)));
                if datastructure.Session2.OnData(L,1) == 1
                    datastructure.Session2.OnData(L,1) = datastructure.Session2.OnData(L,1) - 0.0001;
                end
                if datastructure.Session2.OnData(L,1) == 0
                    datastructure.Session2.OnData(L,1) = datastructure.Session2.OnData(L,1) + 0.0001;
                end
                if datastructure.Session2.OnData(L,2) == 1
                    datastructure.Session2.OnData(L,2) = datastructure.Session2.OnData(L,2) - 0.0001;
                end
                if datastructure.Session2.OnData(L,2) == 0
                    datastructure.Session2.OnData(L,2) = datastructure.Session2.OnData(L,2) + 0.0001;
                end
                datastructure.Session2.OnData(L,3) = (norminv(datastructure.Session2.OnData(M,1)) - norminv(datastructure.Session2.OnData(M,2)));
                datastructure.Session2.OnData(L,4) = 0.5 * (norminv(datastructure.Session2.OnData(M,1)) + norminv(datastructure.Session2.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session2.FinalData = [datastructure.Session2.OffData(1:4,:) datastructure.Session2.Offperc(1:4,5:6) datastructure.Session2.OnData datastructure.Session2.Onperc(1:4,5:6)];
            x = x + 1;
        end
        
%% Start Session 3





    elseif i == 3
        
        datastructure.Session3.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session3.BaseData = [];
            RTs = [sum(datastructure.Session3.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session3.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session3.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session3.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session3.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session3.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session3.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session3.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session3.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session3.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session3.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session3.FinalData(1,1) = ((datastructure.Session3.BaseData(1,1)) / (datastructure.Session3.BaseData(1,1) + datastructure.Session3.BaseData(3,1))) - 0.0001;
            datastructure.Session3.FinalData(1,2) = ((datastructure.Session3.BaseData(4,1)) / (datastructure.Session3.BaseData(4,1) + datastructure.Session3.BaseData(2,1))) + 0.0001;
            datastructure.Session3.FinalData(1,3) = (norminv(datastructure.Session3.FinalData(1,1)) - norminv(datastructure.Session3.FinalData(1,2)));
            datastructure.Session3.FinalData(1,4) = 0.5 * (norminv(datastructure.Session3.FinalData(1,1)) + norminv(datastructure.Session3.FinalData(1,2)));
            datastructure.Session3.FinalData(1,5) = datastructure.Session3.BaseData(5,1);
            datastructure.Session3.FinalData(1,6) = datastructure.Session3.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session3.BasePercData = [];
            RTs = [sum(datastructure.Session3.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session3.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session3.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session3.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session3.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session3.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session3.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session3.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session3.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session3.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session3.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session3.LedOff(Y:Z,:) = datastructure.Session3.DataAnalysis(112+X:121+X,:);
                datastructure.Session3.LedOn(Y:Z,:) = datastructure.Session3.DataAnalysis(102+X:111+X,:);
                datastructure.Session3.Offperc(L,1) = (sum(datastructure.Session3.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session3.Offperc(L,2) = (sum(datastructure.Session3.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session3.Offperc(L,3) = (sum(datastructure.Session3.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session3.Offperc(L,4) = (sum(datastructure.Session3.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,1) = (sum(datastructure.Session3.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,2) = (sum(datastructure.Session3.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,3) = (sum(datastructure.Session3.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,4) = (sum(datastructure.Session3.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session3.Offperc(L,5) = sum(datastructure.Session3.LedOff(B:C,6));
                datastructure.Session3.Offperc(L,6) = sum(datastructure.Session3.LedOff(B:C,11));
                datastructure.Session3.Onperc(L,5) = sum(datastructure.Session3.LedOn(B:C,6));
                datastructure.Session3.Onperc(L,6) = sum(datastructure.Session3.LedOn(B:C,11));
                datastructure.Session3.TotalOffRTs(L,1) = sum(datastructure.Session3.LedOff(B:C,6) > 0);
                datastructure.Session3.TotalOffRTs(L,2) = sum(datastructure.Session3.LedOff(B:C,11) > 0);
                datastructure.Session3.TotalOnRTs(L,1) = sum(datastructure.Session3.LedOn(B:C,6) > 0);
                datastructure.Session3.TotalOnRTs(L,2) = sum(datastructure.Session3.LedOn(B:C,11) > 0);
                datastructure.Session3.Offperc(L,5) = (datastructure.Session3.Offperc(L,5) / datastructure.Session3.TotalOffRTs(L,1));
                datastructure.Session3.Offperc(L,6) = (datastructure.Session3.Offperc(L,6) / datastructure.Session3.TotalOffRTs(L,2));
                datastructure.Session3.Onperc(L,5) = (datastructure.Session3.Onperc(L,5) / datastructure.Session3.TotalOnRTs(L,1));
                datastructure.Session3.Onperc(L,6) = (datastructure.Session3.Onperc(L,6) / datastructure.Session3.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session3.Offperc(isnan(datastructure.Session3.Offperc)) = 0;
            datastructure.Session3.Onperc(isnan(datastructure.Session3.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session3.OffData(L,1) = (datastructure.Session3.Offperc(M,1) / (datastructure.Session3.Offperc(M,1) + datastructure.Session3.Offperc(M,3)));
                datastructure.Session3.OffData(L,2) = (datastructure.Session3.Offperc(M,4) / (datastructure.Session3.Offperc(M,4) + datastructure.Session3.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session3.OffData(L,1) == 1
                    datastructure.Session3.OffData(L,1) = datastructure.Session3.OffData(L,1) - 0.0001;
                end
                if datastructure.Session3.OffData(L,1) == 0
                    datastructure.Session3.OffData(L,1) = datastructure.Session3.OffData(L,1) + 0.0001;
                end
                if datastructure.Session3.OffData(L,2) == 1
                    datastructure.Session3.OffData(L,2) = datastructure.Session3.OffData(L,2) - 0.0001;
                end
                if datastructure.Session3.OffData(L,2) == 0
                    datastructure.Session3.OffData(L,2) = datastructure.Session3.OffData(L,2) + 0.0001;
                end
                datastructure.Session3.OffData(L,3) = (norminv(datastructure.Session3.OffData(M,1)) - norminv(datastructure.Session3.OffData(M,2)));
                datastructure.Session3.OffData(L,4) = 0.5 * (norminv(datastructure.Session3.OffData(M,1)) + norminv(datastructure.Session3.OffData(M,2)));
                datastructure.Session3.OnData(L,1) = (datastructure.Session3.Onperc(M,1) / (datastructure.Session3.Onperc(M,1) + datastructure.Session3.Onperc(M,3)));
                datastructure.Session3.OnData(L,2) = (datastructure.Session3.Onperc(M,4) / (datastructure.Session3.Onperc(M,4) + datastructure.Session3.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session3.OnData(L,1) == 1
                    datastructure.Session3.OnData(L,1) = datastructure.Session3.OnData(L,1) - 0.0001;
                end
                if datastructure.Session3.OnData(L,1) == 0
                    datastructure.Session3.OnData(L,1) = datastructure.Session3.OnData(L,1) + 0.0001;
                end
                if datastructure.Session3.OnData(L,2) == 1
                    datastructure.Session3.OnData(L,2) = datastructure.Session3.OnData(L,2) - 0.0001;
                end
                if datastructure.Session3.OnData(L,2) == 0
                    datastructure.Session3.OnData(L,2) = datastructure.Session3.OnData(L,2) + 0.0001;
                end
                datastructure.Session3.OnData(L,3) = (norminv(datastructure.Session3.OnData(M,1)) - norminv(datastructure.Session3.OnData(M,2)));
                datastructure.Session3.OnData(L,4) = 0.5 * (norminv(datastructure.Session3.OnData(M,1)) + norminv(datastructure.Session3.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session3.FinalData = [datastructure.Session3.OffData datastructure.Session3.Offperc(:,5:6) datastructure.Session3.OnData datastructure.Session3.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2;
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session3.BasePercData = [];
            RTs = [sum(datastructure.Session3.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session3.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session3.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session3.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session3.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session3.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session3.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session3.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session3.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session3.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session3.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session3.LedOff(1:10,1:12) = datastructure.Session3.DataAnalysis(102:111,1:12);
            datastructure.Session3.LedOff(11:20,1:12) = datastructure.Session3.DataAnalysis(122:131,1:12);
            datastructure.Session3.LedOff(21:40,1:12) = datastructure.Session3.DataAnalysis(142:161,1:12);
            datastructure.Session3.LedOff(41:50,1:12) = datastructure.Session3.DataAnalysis(172:181,1:12);
            datastructure.Session3.LedOff(51:60,1:12) = datastructure.Session3.DataAnalysis(192:201,1:12);
            datastructure.Session3.LedOn(1:10,1:12) = datastructure.Session3.DataAnalysis(112:121,1:12);
            datastructure.Session3.LedOn(11:20,1:12) = datastructure.Session3.DataAnalysis(132:141,1:12);
            datastructure.Session3.LedOn(21:30,1:12) = datastructure.Session3.DataAnalysis(162:171,1:12);
            datastructure.Session3.LedOn(31:40,1:12) = datastructure.Session3.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session3.Offperc(L,1) = (sum(datastructure.Session3.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session3.Offperc(L,2) = (sum(datastructure.Session3.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session3.Offperc(L,3) = (sum(datastructure.Session3.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session3.Offperc(L,4) = (sum(datastructure.Session3.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session3.Offperc(L,5) = sum(datastructure.Session3.LedOff(B:C,6));
                datastructure.Session3.Offperc(L,6) = sum(datastructure.Session3.LedOff(B:C,11));
                datastructure.Session3.TotalOffRTs(L,1) = sum(datastructure.Session3.LedOff(B:C,6) > 0);
                datastructure.Session3.TotalOffRTs(L,2) = sum(datastructure.Session3.LedOff(B:C,11) > 0);
                datastructure.Session3.Offperc(L,5) = (datastructure.Session3.Offperc(L,5) / datastructure.Session3.TotalOffRTs(L,1));
                datastructure.Session3.Offperc(L,6) = (datastructure.Session3.Offperc(L,6) / datastructure.Session3.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session3.Onperc(L,1) = (sum(datastructure.Session3.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,2) = (sum(datastructure.Session3.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,3) = (sum(datastructure.Session3.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,4) = (sum(datastructure.Session3.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session3.Onperc(L,5) = sum(datastructure.Session3.LedOn(B:C,6));
                datastructure.Session3.Onperc(L,6) = sum(datastructure.Session3.LedOn(B:C,11));
                datastructure.Session3.TotalOnRTs(L,1) = sum(datastructure.Session3.LedOn(B:C,6) > 0);
                datastructure.Session3.TotalOnRTs(L,2) = sum(datastructure.Session3.LedOn(B:C,11) > 0);
                datastructure.Session3.Onperc(L,5) = (datastructure.Session3.Onperc(L,5) / datastructure.Session3.TotalOnRTs(L,1));
                datastructure.Session3.Onperc(L,6) = (datastructure.Session3.Onperc(L,6) / datastructure.Session3.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session3.Offperc(isnan(datastructure.Session3.Offperc)) = 0;
            datastructure.Session3.Onperc(isnan(datastructure.Session3.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session3.OffData(L,1) = (datastructure.Session3.Offperc(M,1) / (datastructure.Session3.Offperc(M,1) + datastructure.Session3.Offperc(M,3)));
                datastructure.Session3.OffData(L,2) = (datastructure.Session3.Offperc(M,4) / (datastructure.Session3.Offperc(M,4) + datastructure.Session3.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session3.OffData(L,1) == 1
                    datastructure.Session3.OffData(L,1) = datastructure.Session3.OffData(L,1) - 0.0001;
                end
                if datastructure.Session3.OffData(L,1) == 0
                    datastructure.Session3.OffData(L,1) = datastructure.Session3.OffData(L,1) + 0.0001;
                end
                if datastructure.Session3.OffData(L,2) == 1
                    datastructure.Session3.OffData(L,2) = datastructure.Session3.OffData(L,2) - 0.0001;
                end
                if datastructure.Session3.OffData(L,2) == 0
                    datastructure.Session3.OffData(L,2) = datastructure.Session3.OffData(L,2) + 0.0001;
                end
                datastructure.Session3.OffData(L,3) = (norminv(datastructure.Session3.OffData(M,1)) - norminv(datastructure.Session3.OffData(M,2)));
                datastructure.Session3.OffData(L,4) = 0.5 * (norminv(datastructure.Session3.OffData(M,1)) + norminv(datastructure.Session3.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session3.OnData(L,1) = (datastructure.Session3.Onperc(M,1) / (datastructure.Session3.Onperc(M,1) + datastructure.Session3.Onperc(M,3)));
                datastructure.Session3.OnData(L,2) = (datastructure.Session3.Onperc(M,4) / (datastructure.Session3.Onperc(M,4) + datastructure.Session3.Onperc(M,2)));
                if datastructure.Session3.OnData(L,1) == 1
                    datastructure.Session3.OnData(L,1) = datastructure.Session3.OnData(L,1) - 0.0001;
                end
                if datastructure.Session3.OnData(L,1) == 0
                    datastructure.Session3.OnData(L,1) = datastructure.Session3.OnData(L,1) + 0.0001;
                end
                if datastructure.Session3.OnData(L,2) == 1
                    datastructure.Session3.OnData(L,2) = datastructure.Session3.OnData(L,2) - 0.0001;
                end
                if datastructure.Session3.OnData(L,2) == 0
                    datastructure.Session3.OnData(L,2) = datastructure.Session3.OnData(L,2) + 0.0001;
                end
                datastructure.Session3.OnData(L,3) = (norminv(datastructure.Session3.OnData(M,1)) - norminv(datastructure.Session3.OnData(M,2)));
                datastructure.Session3.OnData(L,4) = 0.5 * (norminv(datastructure.Session3.OnData(M,1)) + norminv(datastructure.Session3.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session3.FinalData = [datastructure.Session3.OffData(1:4,:) datastructure.Session3.Offperc(1:4,5:6) datastructure.Session3.OnData datastructure.Session3.Onperc(1:4,5:6)];
            x = x + 1;   
        end
        
%% Start Session 4






    elseif i == 4
        
        datastructure.Session4.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session4.BaseData = [];
            RTs = [sum(datastructure.Session4.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session4.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session4.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session4.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session4.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session4.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session4.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session4.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session4.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session4.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session4.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session4.FinalData(1,1) = ((datastructure.Session4.BaseData(1,1)) / (datastructure.Session4.BaseData(1,1) + datastructure.Session4.BaseData(3,1))) - 0.0001;
            datastructure.Session4.FinalData(1,2) = ((datastructure.Session4.BaseData(4,1)) / (datastructure.Session4.BaseData(4,1) + datastructure.Session4.BaseData(2,1))) + 0.0001;
            datastructure.Session4.FinalData(1,3) = (norminv(datastructure.Session4.FinalData(1,1)) - norminv(datastructure.Session4.FinalData(1,2)));
            datastructure.Session4.FinalData(1,4) = 0.5 * (norminv(datastructure.Session4.FinalData(1,1)) + norminv(datastructure.Session4.FinalData(1,2)));
            datastructure.Session4.FinalData(1,5) = datastructure.Session4.BaseData(5,1);
            datastructure.Session4.FinalData(1,6) = datastructure.Session4.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session4.BasePercData = [];
            RTs = [sum(datastructure.Session4.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session4.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session4.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session4.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session4.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session4.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session4.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session4.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session4.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session4.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session4.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session4.LedOff(Y:Z,:) = datastructure.Session4.DataAnalysis(112+X:121+X,:);
                datastructure.Session4.LedOn(Y:Z,:) = datastructure.Session4.DataAnalysis(102+X:111+X,:);
                datastructure.Session4.Offperc(L,1) = (sum(datastructure.Session4.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session4.Offperc(L,2) = (sum(datastructure.Session4.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session4.Offperc(L,3) = (sum(datastructure.Session4.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session4.Offperc(L,4) = (sum(datastructure.Session4.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,1) = (sum(datastructure.Session4.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,2) = (sum(datastructure.Session4.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,3) = (sum(datastructure.Session4.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,4) = (sum(datastructure.Session4.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session4.Offperc(L,5) = sum(datastructure.Session4.LedOff(B:C,6));
                datastructure.Session4.Offperc(L,6) = sum(datastructure.Session4.LedOff(B:C,11));
                datastructure.Session4.Onperc(L,5) = sum(datastructure.Session4.LedOn(B:C,6));
                datastructure.Session4.Onperc(L,6) = sum(datastructure.Session4.LedOn(B:C,11));
                datastructure.Session4.TotalOffRTs(L,1) = sum(datastructure.Session4.LedOff(B:C,6) > 0);
                datastructure.Session4.TotalOffRTs(L,2) = sum(datastructure.Session4.LedOff(B:C,11) > 0);
                datastructure.Session4.TotalOnRTs(L,1) = sum(datastructure.Session4.LedOn(B:C,6) > 0);
                datastructure.Session4.TotalOnRTs(L,2) = sum(datastructure.Session4.LedOn(B:C,11) > 0);
                datastructure.Session4.Offperc(L,5) = (datastructure.Session4.Offperc(L,5) / datastructure.Session4.TotalOffRTs(L,1));
                datastructure.Session4.Offperc(L,6) = (datastructure.Session4.Offperc(L,6) / datastructure.Session4.TotalOffRTs(L,2));
                datastructure.Session4.Onperc(L,5) = (datastructure.Session4.Onperc(L,5) / datastructure.Session4.TotalOnRTs(L,1));
                datastructure.Session4.Onperc(L,6) = (datastructure.Session4.Onperc(L,6) / datastructure.Session4.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session4.Offperc(isnan(datastructure.Session4.Offperc)) = 0;
            datastructure.Session4.Onperc(isnan(datastructure.Session4.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session4.OffData(L,1) = (datastructure.Session4.Offperc(M,1) / (datastructure.Session4.Offperc(M,1) + datastructure.Session4.Offperc(M,3)));
                datastructure.Session4.OffData(L,2) = (datastructure.Session4.Offperc(M,4) / (datastructure.Session4.Offperc(M,4) + datastructure.Session4.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session4.OffData(L,1) == 1
                    datastructure.Session4.OffData(L,1) = datastructure.Session4.OffData(L,1) - 0.0001;
                end
                if datastructure.Session4.OffData(L,1) == 0
                    datastructure.Session4.OffData(L,1) = datastructure.Session4.OffData(L,1) + 0.0001;
                end
                if datastructure.Session4.OffData(L,2) == 1
                    datastructure.Session4.OffData(L,2) = datastructure.Session4.OffData(L,2) - 0.0001;
                end
                if datastructure.Session4.OffData(L,2) == 0
                    datastructure.Session4.OffData(L,2) = datastructure.Session4.OffData(L,2) + 0.0001;
                end
                datastructure.Session4.OffData(L,3) = (norminv(datastructure.Session4.OffData(M,1)) - norminv(datastructure.Session4.OffData(M,2)));
                datastructure.Session4.OffData(L,4) = 0.5 * (norminv(datastructure.Session4.OffData(M,1)) + norminv(datastructure.Session4.OffData(M,2)));
                datastructure.Session4.OnData(L,1) = (datastructure.Session4.Onperc(M,1) / (datastructure.Session4.Onperc(M,1) + datastructure.Session4.Onperc(M,3)));
                datastructure.Session4.OnData(L,2) = (datastructure.Session4.Onperc(M,4) / (datastructure.Session4.Onperc(M,4) + datastructure.Session4.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session4.OnData(L,1) == 1
                    datastructure.Session4.OnData(L,1) = datastructure.Session4.OnData(L,1) - 0.0001;
                end
                if datastructure.Session4.OnData(L,1) == 0
                    datastructure.Session4.OnData(L,1) = datastructure.Session4.OnData(L,1) + 0.0001;
                end
                if datastructure.Session4.OnData(L,2) == 1
                    datastructure.Session4.OnData(L,2) = datastructure.Session4.OnData(L,2) - 0.0001;
                end
                if datastructure.Session4.OnData(L,2) == 0
                    datastructure.Session4.OnData(L,2) = datastructure.Session4.OnData(L,2) + 0.0001;
                end
                datastructure.Session4.OnData(L,3) = (norminv(datastructure.Session4.OnData(M,1)) - norminv(datastructure.Session4.OnData(M,2)));
                datastructure.Session4.OnData(L,4) = 0.5 * (norminv(datastructure.Session4.OnData(M,1)) + norminv(datastructure.Session4.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session4.FinalData = [datastructure.Session4.OffData datastructure.Session4.Offperc(:,5:6) datastructure.Session4.OnData datastructure.Session4.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session4.BasePercData = [];
            RTs = [sum(datastructure.Session4.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session4.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session4.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session4.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session4.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session4.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session4.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session4.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session4.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session4.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session4.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session4.LedOff(1:10,1:12) = datastructure.Session4.DataAnalysis(102:111,1:12);
            datastructure.Session4.LedOff(11:20,1:12) = datastructure.Session4.DataAnalysis(122:131,1:12);
            datastructure.Session4.LedOff(21:40,1:12) = datastructure.Session4.DataAnalysis(142:161,1:12);
            datastructure.Session4.LedOff(41:50,1:12) = datastructure.Session4.DataAnalysis(172:181,1:12);
            datastructure.Session4.LedOff(51:60,1:12) = datastructure.Session4.DataAnalysis(192:201,1:12);
            datastructure.Session4.LedOn(1:10,1:12) = datastructure.Session4.DataAnalysis(112:121,1:12);
            datastructure.Session4.LedOn(11:20,1:12) = datastructure.Session4.DataAnalysis(132:141,1:12);
            datastructure.Session4.LedOn(21:30,1:12) = datastructure.Session4.DataAnalysis(162:171,1:12);
            datastructure.Session4.LedOn(31:40,1:12) = datastructure.Session4.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session4.Offperc(L,1) = (sum(datastructure.Session4.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session4.Offperc(L,2) = (sum(datastructure.Session4.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session4.Offperc(L,3) = (sum(datastructure.Session4.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session4.Offperc(L,4) = (sum(datastructure.Session4.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session4.Offperc(L,5) = sum(datastructure.Session4.LedOff(B:C,6));
                datastructure.Session4.Offperc(L,6) = sum(datastructure.Session4.LedOff(B:C,11));
                datastructure.Session4.TotalOffRTs(L,1) = sum(datastructure.Session4.LedOff(B:C,6) > 0);
                datastructure.Session4.TotalOffRTs(L,2) = sum(datastructure.Session4.LedOff(B:C,11) > 0);
                datastructure.Session4.Offperc(L,5) = (datastructure.Session4.Offperc(L,5) / datastructure.Session4.TotalOffRTs(L,1));
                datastructure.Session4.Offperc(L,6) = (datastructure.Session4.Offperc(L,6) / datastructure.Session4.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session4.Onperc(L,1) = (sum(datastructure.Session4.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,2) = (sum(datastructure.Session4.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,3) = (sum(datastructure.Session4.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,4) = (sum(datastructure.Session4.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session4.Onperc(L,5) = sum(datastructure.Session4.LedOn(B:C,6));
                datastructure.Session4.Onperc(L,6) = sum(datastructure.Session4.LedOn(B:C,11));
                datastructure.Session4.TotalOnRTs(L,1) = sum(datastructure.Session4.LedOn(B:C,6) > 0);
                datastructure.Session4.TotalOnRTs(L,2) = sum(datastructure.Session4.LedOn(B:C,11) > 0);
                datastructure.Session4.Onperc(L,5) = (datastructure.Session4.Onperc(L,5) / datastructure.Session4.TotalOnRTs(L,1));
                datastructure.Session4.Onperc(L,6) = (datastructure.Session4.Onperc(L,6) / datastructure.Session4.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session4.Offperc(isnan(datastructure.Session4.Offperc)) = 0;
            datastructure.Session4.Onperc(isnan(datastructure.Session4.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session4.OffData(L,1) = (datastructure.Session4.Offperc(M,1) / (datastructure.Session4.Offperc(M,1) + datastructure.Session4.Offperc(M,3)));
                datastructure.Session4.OffData(L,2) = (datastructure.Session4.Offperc(M,4) / (datastructure.Session4.Offperc(M,4) + datastructure.Session4.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session4.OffData(L,1) == 1
                    datastructure.Session4.OffData(L,1) = datastructure.Session4.OffData(L,1) - 0.0001;
                end
                if datastructure.Session4.OffData(L,1) == 0
                    datastructure.Session4.OffData(L,1) = datastructure.Session4.OffData(L,1) + 0.0001;
                end
                if datastructure.Session4.OffData(L,2) == 1
                    datastructure.Session4.OffData(L,2) = datastructure.Session4.OffData(L,2) - 0.0001;
                end
                if datastructure.Session4.OffData(L,2) == 0
                    datastructure.Session4.OffData(L,2) = datastructure.Session4.OffData(L,2) + 0.0001;
                end
                datastructure.Session4.OffData(L,3) = (norminv(datastructure.Session4.OffData(M,1)) - norminv(datastructure.Session4.OffData(M,2)));
                datastructure.Session4.OffData(L,4) = 0.5 * (norminv(datastructure.Session4.OffData(M,1)) + norminv(datastructure.Session4.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session4.OnData(L,1) = (datastructure.Session4.Onperc(M,1) / (datastructure.Session4.Onperc(M,1) + datastructure.Session4.Onperc(M,3)));
                datastructure.Session4.OnData(L,2) = (datastructure.Session4.Onperc(M,4) / (datastructure.Session4.Onperc(M,4) + datastructure.Session4.Onperc(M,2)));
                if datastructure.Session4.OnData(L,1) == 1
                    datastructure.Session4.OnData(L,1) = datastructure.Session4.OnData(L,1) - 0.0001;
                end
                if datastructure.Session4.OnData(L,1) == 0
                    datastructure.Session4.OnData(L,1) = datastructure.Session4.OnData(L,1) + 0.0001;
                end
                if datastructure.Session4.OnData(L,2) == 1
                    datastructure.Session4.OnData(L,2) = datastructure.Session4.OnData(L,2) - 0.0001;
                end
                if datastructure.Session4.OnData(L,2) == 0
                    datastructure.Session4.OnData(L,2) = datastructure.Session4.OnData(L,2) + 0.0001;
                end
                datastructure.Session4.OnData(L,3) = (norminv(datastructure.Session4.OnData(M,1)) - norminv(datastructure.Session4.OnData(M,2)));
                datastructure.Session4.OnData(L,4) = 0.5 * (norminv(datastructure.Session4.OnData(M,1)) + norminv(datastructure.Session4.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session4.FinalData = [datastructure.Session4.OffData(1:4,:) datastructure.Session4.Offperc(1:4,5:6) datastructure.Session4.OnData datastructure.Session4.Onperc(1:4,5:6)];
            x = x + 1;   
        end
%% Start Session 5





    elseif i == 5
        
        datastructure.Session5.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session5.BaseData = [];
            RTs = [sum(datastructure.Session5.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session5.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session5.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session5.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session5.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session5.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session5.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session5.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session5.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session5.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session5.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session5.FinalData(1,1) = ((datastructure.Session5.BaseData(1,1)) / (datastructure.Session5.BaseData(1,1) + datastructure.Session5.BaseData(3,1))) - 0.0001;
            datastructure.Session5.FinalData(1,2) = ((datastructure.Session5.BaseData(4,1)) / (datastructure.Session5.BaseData(4,1) + datastructure.Session5.BaseData(2,1))) + 0.0001;
            datastructure.Session5.FinalData(1,3) = (norminv(datastructure.Session5.FinalData(1,1)) - norminv(datastructure.Session5.FinalData(1,2)));
            datastructure.Session5.FinalData(1,4) = 0.5 * (norminv(datastructure.Session5.FinalData(1,1)) + norminv(datastructure.Session5.FinalData(1,2)));
            datastructure.Session5.FinalData(1,5) = datastructure.Session5.BaseData(5,1);
            datastructure.Session5.FinalData(1,6) = datastructure.Session5.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session5.BasePercData = [];
            RTs = [sum(datastructure.Session5.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session5.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session5.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session5.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session5.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session5.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session5.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session5.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session5.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session5.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session5.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session5.LedOff(Y:Z,:) = datastructure.Session5.DataAnalysis(112+X:121+X,:);
                datastructure.Session5.LedOn(Y:Z,:) = datastructure.Session5.DataAnalysis(102+X:111+X,:);
                datastructure.Session5.Offperc(L,1) = (sum(datastructure.Session5.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session5.Offperc(L,2) = (sum(datastructure.Session5.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session5.Offperc(L,3) = (sum(datastructure.Session5.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session5.Offperc(L,4) = (sum(datastructure.Session5.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,1) = (sum(datastructure.Session5.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,2) = (sum(datastructure.Session5.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,3) = (sum(datastructure.Session5.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,4) = (sum(datastructure.Session5.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session5.Offperc(L,5) = sum(datastructure.Session5.LedOff(B:C,6));
                datastructure.Session5.Offperc(L,6) = sum(datastructure.Session5.LedOff(B:C,11));
                datastructure.Session5.Onperc(L,5) = sum(datastructure.Session5.LedOn(B:C,6));
                datastructure.Session5.Onperc(L,6) = sum(datastructure.Session5.LedOn(B:C,11));
                datastructure.Session5.TotalOffRTs(L,1) = sum(datastructure.Session5.LedOff(B:C,6) > 0);
                datastructure.Session5.TotalOffRTs(L,2) = sum(datastructure.Session5.LedOff(B:C,11) > 0);
                datastructure.Session5.TotalOnRTs(L,1) = sum(datastructure.Session5.LedOn(B:C,6) > 0);
                datastructure.Session5.TotalOnRTs(L,2) = sum(datastructure.Session5.LedOn(B:C,11) > 0);
                datastructure.Session5.Offperc(L,5) = (datastructure.Session5.Offperc(L,5) / datastructure.Session5.TotalOffRTs(L,1));
                datastructure.Session5.Offperc(L,6) = (datastructure.Session5.Offperc(L,6) / datastructure.Session5.TotalOffRTs(L,2));
                datastructure.Session5.Onperc(L,5) = (datastructure.Session5.Onperc(L,5) / datastructure.Session5.TotalOnRTs(L,1));
                datastructure.Session5.Onperc(L,6) = (datastructure.Session5.Onperc(L,6) / datastructure.Session5.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session5.Offperc(isnan(datastructure.Session5.Offperc)) = 0;
            datastructure.Session5.Onperc(isnan(datastructure.Session5.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session5.OffData(L,1) = (datastructure.Session5.Offperc(M,1) / (datastructure.Session5.Offperc(M,1) + datastructure.Session5.Offperc(M,3)));
                datastructure.Session5.OffData(L,2) = (datastructure.Session5.Offperc(M,4) / (datastructure.Session5.Offperc(M,4) + datastructure.Session5.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session5.OffData(L,1) == 1
                    datastructure.Session5.OffData(L,1) = datastructure.Session5.OffData(L,1) - 0.0001;
                end
                if datastructure.Session5.OffData(L,1) == 0
                    datastructure.Session5.OffData(L,1) = datastructure.Session5.OffData(L,1) + 0.0001;
                end
                if datastructure.Session5.OffData(L,2) == 1
                    datastructure.Session5.OffData(L,2) = datastructure.Session5.OffData(L,2) - 0.0001;
                end
                if datastructure.Session5.OffData(L,2) == 0
                    datastructure.Session5.OffData(L,2) = datastructure.Session5.OffData(L,2) + 0.0001;
                end
                datastructure.Session5.OffData(L,3) = (norminv(datastructure.Session5.OffData(M,1)) - norminv(datastructure.Session5.OffData(M,2)));
                datastructure.Session5.OffData(L,4) = 0.5 * (norminv(datastructure.Session5.OffData(M,1)) + norminv(datastructure.Session5.OffData(M,2)));
                datastructure.Session5.OnData(L,1) = (datastructure.Session5.Onperc(M,1) / (datastructure.Session5.Onperc(M,1) + datastructure.Session5.Onperc(M,3)));
                datastructure.Session5.OnData(L,2) = (datastructure.Session5.Onperc(M,4) / (datastructure.Session5.Onperc(M,4) + datastructure.Session5.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session5.OnData(L,1) == 1
                    datastructure.Session5.OnData(L,1) = datastructure.Session5.OnData(L,1) - 0.0001;
                end
                if datastructure.Session5.OnData(L,1) == 0
                    datastructure.Session5.OnData(L,1) = datastructure.Session5.OnData(L,1) + 0.0001;
                end
                if datastructure.Session5.OnData(L,2) == 1
                    datastructure.Session5.OnData(L,2) = datastructure.Session5.OnData(L,2) - 0.0001;
                end
                if datastructure.Session5.OnData(L,2) == 0
                    datastructure.Session5.OnData(L,2) = datastructure.Session5.OnData(L,2) + 0.0001;
                end
                datastructure.Session5.OnData(L,3) = (norminv(datastructure.Session5.OnData(M,1)) - norminv(datastructure.Session5.OnData(M,2)));
                datastructure.Session5.OnData(L,4) = 0.5 * (norminv(datastructure.Session5.OnData(M,1)) + norminv(datastructure.Session5.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session5.FinalData = [datastructure.Session5.OffData datastructure.Session5.Offperc(:,5:6) datastructure.Session5.OnData datastructure.Session5.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session5.BasePercData = [];
            RTs = [sum(datastructure.Session5.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session5.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session5.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session5.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session5.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session5.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session5.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session5.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session5.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session5.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session5.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session5.LedOff(1:10,1:12) = datastructure.Session5.DataAnalysis(102:111,1:12);
            datastructure.Session5.LedOff(11:20,1:12) = datastructure.Session5.DataAnalysis(122:131,1:12);
            datastructure.Session5.LedOff(21:40,1:12) = datastructure.Session5.DataAnalysis(142:161,1:12);
            datastructure.Session5.LedOff(41:50,1:12) = datastructure.Session5.DataAnalysis(172:181,1:12);
            datastructure.Session5.LedOff(51:60,1:12) = datastructure.Session5.DataAnalysis(192:201,1:12);
            datastructure.Session5.LedOn(1:10,1:12) = datastructure.Session5.DataAnalysis(112:121,1:12);
            datastructure.Session5.LedOn(11:20,1:12) = datastructure.Session5.DataAnalysis(132:141,1:12);
            datastructure.Session5.LedOn(21:30,1:12) = datastructure.Session5.DataAnalysis(162:171,1:12);
            datastructure.Session5.LedOn(31:40,1:12) = datastructure.Session5.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session5.Offperc(L,1) = (sum(datastructure.Session5.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session5.Offperc(L,2) = (sum(datastructure.Session5.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session5.Offperc(L,3) = (sum(datastructure.Session5.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session5.Offperc(L,4) = (sum(datastructure.Session5.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session5.Offperc(L,5) = sum(datastructure.Session5.LedOff(B:C,6));
                datastructure.Session5.Offperc(L,6) = sum(datastructure.Session5.LedOff(B:C,11));
                datastructure.Session5.TotalOffRTs(L,1) = sum(datastructure.Session5.LedOff(B:C,6) > 0);
                datastructure.Session5.TotalOffRTs(L,2) = sum(datastructure.Session5.LedOff(B:C,11) > 0);
                datastructure.Session5.Offperc(L,5) = (datastructure.Session5.Offperc(L,5) / datastructure.Session5.TotalOffRTs(L,1));
                datastructure.Session5.Offperc(L,6) = (datastructure.Session5.Offperc(L,6) / datastructure.Session5.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session5.Onperc(L,1) = (sum(datastructure.Session5.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,2) = (sum(datastructure.Session5.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,3) = (sum(datastructure.Session5.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,4) = (sum(datastructure.Session5.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session5.Onperc(L,5) = sum(datastructure.Session5.LedOn(B:C,6));
                datastructure.Session5.Onperc(L,6) = sum(datastructure.Session5.LedOn(B:C,11));
                datastructure.Session5.TotalOnRTs(L,1) = sum(datastructure.Session5.LedOn(B:C,6) > 0);
                datastructure.Session5.TotalOnRTs(L,2) = sum(datastructure.Session5.LedOn(B:C,11) > 0);
                datastructure.Session5.Onperc(L,5) = (datastructure.Session5.Onperc(L,5) / datastructure.Session5.TotalOnRTs(L,1));
                datastructure.Session5.Onperc(L,6) = (datastructure.Session5.Onperc(L,6) / datastructure.Session5.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session5.Offperc(isnan(datastructure.Session5.Offperc)) = 0;
            datastructure.Session5.Onperc(isnan(datastructure.Session5.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session5.OffData(L,1) = (datastructure.Session5.Offperc(M,1) / (datastructure.Session5.Offperc(M,1) + datastructure.Session5.Offperc(M,3)));
                datastructure.Session5.OffData(L,2) = (datastructure.Session5.Offperc(M,4) / (datastructure.Session5.Offperc(M,4) + datastructure.Session5.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session5.OffData(L,1) == 1
                    datastructure.Session5.OffData(L,1) = datastructure.Session5.OffData(L,1) - 0.0001;
                end
                if datastructure.Session5.OffData(L,1) == 0
                    datastructure.Session5.OffData(L,1) = datastructure.Session5.OffData(L,1) + 0.0001;
                end
                if datastructure.Session5.OffData(L,2) == 1
                    datastructure.Session5.OffData(L,2) = datastructure.Session5.OffData(L,2) - 0.0001;
                end
                if datastructure.Session5.OffData(L,2) == 0
                    datastructure.Session5.OffData(L,2) = datastructure.Session5.OffData(L,2) + 0.0001;
                end
                datastructure.Session5.OffData(L,3) = (norminv(datastructure.Session5.OffData(M,1)) - norminv(datastructure.Session5.OffData(M,2)));
                datastructure.Session5.OffData(L,4) = 0.5 * (norminv(datastructure.Session5.OffData(M,1)) + norminv(datastructure.Session5.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session5.OnData(L,1) = (datastructure.Session5.Onperc(M,1) / (datastructure.Session5.Onperc(M,1) + datastructure.Session5.Onperc(M,3)));
                datastructure.Session5.OnData(L,2) = (datastructure.Session5.Onperc(M,4) / (datastructure.Session5.Onperc(M,4) + datastructure.Session5.Onperc(M,2)));
                if datastructure.Session5.OnData(L,1) == 1
                    datastructure.Session5.OnData(L,1) = datastructure.Session5.OnData(L,1) - 0.0001;
                end
                if datastructure.Session5.OnData(L,1) == 0
                    datastructure.Session5.OnData(L,1) = datastructure.Session5.OnData(L,1) + 0.0001;
                end
                if datastructure.Session5.OnData(L,2) == 1
                    datastructure.Session5.OnData(L,2) = datastructure.Session5.OnData(L,2) - 0.0001;
                end
                if datastructure.Session5.OnData(L,2) == 0
                    datastructure.Session5.OnData(L,2) = datastructure.Session5.OnData(L,2) + 0.0001;
                end
                datastructure.Session5.OnData(L,3) = (norminv(datastructure.Session5.OnData(M,1)) - norminv(datastructure.Session5.OnData(M,2)));
                datastructure.Session5.OnData(L,4) = 0.5 * (norminv(datastructure.Session5.OnData(M,1)) + norminv(datastructure.Session5.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session5.FinalData = [datastructure.Session5.OffData(1:4,:) datastructure.Session5.Offperc(1:4,5:6) datastructure.Session5.OnData datastructure.Session5.Onperc(1:4,5:6)];
            x = x + 1;   
        end
        
%% Start Session 6        






    elseif i == 6
        
        datastructure.Session6.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session6.BaseData = [];
            RTs = [sum(datastructure.Session6.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session6.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session6.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session6.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session6.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session6.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session6.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session6.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session6.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session6.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session6.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session6.FinalData(1,1) = ((datastructure.Session6.BaseData(1,1)) / (datastructure.Session6.BaseData(1,1) + datastructure.Session6.BaseData(3,1))) - 0.0001;
            datastructure.Session6.FinalData(1,2) = ((datastructure.Session6.BaseData(4,1)) / (datastructure.Session6.BaseData(4,1) + datastructure.Session6.BaseData(2,1))) + 0.0001;
            datastructure.Session6.FinalData(1,3) = (norminv(datastructure.Session6.FinalData(1,1)) - norminv(datastructure.Session6.FinalData(1,2)));
            datastructure.Session6.FinalData(1,4) = 0.5 * (norminv(datastructure.Session6.FinalData(1,1)) + norminv(datastructure.Session6.FinalData(1,2)));
            datastructure.Session6.FinalData(1,5) = datastructure.Session6.BaseData(5,1);
            datastructure.Session6.FinalData(1,6) = datastructure.Session6.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session6.BasePercData = [];
            RTs = [sum(datastructure.Session6.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session6.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session6.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session6.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session6.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session6.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session6.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session6.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session6.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session6.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session6.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session6.LedOff(Y:Z,:) = datastructure.Session6.DataAnalysis(112+X:121+X,:);
                datastructure.Session6.LedOn(Y:Z,:) = datastructure.Session6.DataAnalysis(102+X:111+X,:);
                datastructure.Session6.Offperc(L,1) = (sum(datastructure.Session6.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session6.Offperc(L,2) = (sum(datastructure.Session6.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session6.Offperc(L,3) = (sum(datastructure.Session6.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session6.Offperc(L,4) = (sum(datastructure.Session6.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,1) = (sum(datastructure.Session6.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,2) = (sum(datastructure.Session6.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,3) = (sum(datastructure.Session6.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,4) = (sum(datastructure.Session6.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session6.Offperc(L,5) = sum(datastructure.Session6.LedOff(B:C,6));
                datastructure.Session6.Offperc(L,6) = sum(datastructure.Session6.LedOff(B:C,11));
                datastructure.Session6.Onperc(L,5) = sum(datastructure.Session6.LedOn(B:C,6));
                datastructure.Session6.Onperc(L,6) = sum(datastructure.Session6.LedOn(B:C,11));
                datastructure.Session6.TotalOffRTs(L,1) = sum(datastructure.Session6.LedOff(B:C,6) > 0);
                datastructure.Session6.TotalOffRTs(L,2) = sum(datastructure.Session6.LedOff(B:C,11) > 0);
                datastructure.Session6.TotalOnRTs(L,1) = sum(datastructure.Session6.LedOn(B:C,6) > 0);
                datastructure.Session6.TotalOnRTs(L,2) = sum(datastructure.Session6.LedOn(B:C,11) > 0);
                datastructure.Session6.Offperc(L,5) = (datastructure.Session6.Offperc(L,5) / datastructure.Session6.TotalOffRTs(L,1));
                datastructure.Session6.Offperc(L,6) = (datastructure.Session6.Offperc(L,6) / datastructure.Session6.TotalOffRTs(L,2));
                datastructure.Session6.Onperc(L,5) = (datastructure.Session6.Onperc(L,5) / datastructure.Session6.TotalOnRTs(L,1));
                datastructure.Session6.Onperc(L,6) = (datastructure.Session6.Onperc(L,6) / datastructure.Session6.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session6.Offperc(isnan(datastructure.Session6.Offperc)) = 0;
            datastructure.Session6.Onperc(isnan(datastructure.Session6.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session6.OffData(L,1) = (datastructure.Session6.Offperc(M,1) / (datastructure.Session6.Offperc(M,1) + datastructure.Session6.Offperc(M,3)));
                datastructure.Session6.OffData(L,2) = (datastructure.Session6.Offperc(M,4) / (datastructure.Session6.Offperc(M,4) + datastructure.Session6.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session6.OffData(L,1) == 1
                    datastructure.Session6.OffData(L,1) = datastructure.Session6.OffData(L,1) - 0.0001;
                end
                if datastructure.Session6.OffData(L,1) == 0
                    datastructure.Session6.OffData(L,1) = datastructure.Session6.OffData(L,1) + 0.0001;
                end
                if datastructure.Session6.OffData(L,2) == 1
                    datastructure.Session6.OffData(L,2) = datastructure.Session6.OffData(L,2) - 0.0001;
                end
                if datastructure.Session6.OffData(L,2) == 0
                    datastructure.Session6.OffData(L,2) = datastructure.Session6.OffData(L,2) + 0.0001;
                end
                datastructure.Session6.OffData(L,3) = (norminv(datastructure.Session6.OffData(M,1)) - norminv(datastructure.Session6.OffData(M,2)));
                datastructure.Session6.OffData(L,4) = 0.5 * (norminv(datastructure.Session6.OffData(M,1)) + norminv(datastructure.Session6.OffData(M,2)));
                datastructure.Session6.OnData(L,1) = (datastructure.Session6.Onperc(M,1) / (datastructure.Session6.Onperc(M,1) + datastructure.Session6.Onperc(M,3)));
                datastructure.Session6.OnData(L,2) = (datastructure.Session6.Onperc(M,4) / (datastructure.Session6.Onperc(M,4) + datastructure.Session6.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session6.OnData(L,1) == 1
                    datastructure.Session6.OnData(L,1) = datastructure.Session6.OnData(L,1) - 0.0001;
                end
                if datastructure.Session6.OnData(L,1) == 0
                    datastructure.Session6.OnData(L,1) = datastructure.Session6.OnData(L,1) + 0.0001;
                end
                if datastructure.Session6.OnData(L,2) == 1
                    datastructure.Session6.OnData(L,2) = datastructure.Session6.OnData(L,2) - 0.0001;
                end
                if datastructure.Session6.OnData(L,2) == 0
                    datastructure.Session6.OnData(L,2) = datastructure.Session6.OnData(L,2) + 0.0001;
                end
                datastructure.Session6.OnData(L,3) = (norminv(datastructure.Session6.OnData(M,1)) - norminv(datastructure.Session6.OnData(M,2)));
                datastructure.Session6.OnData(L,4) = 0.5 * (norminv(datastructure.Session6.OnData(M,1)) + norminv(datastructure.Session6.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session6.FinalData = [datastructure.Session6.OffData datastructure.Session6.Offperc(:,5:6) datastructure.Session6.OnData datastructure.Session6.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session6.BasePercData = [];
            RTs = [sum(datastructure.Session6.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session6.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session6.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session6.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session6.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session6.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session6.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session6.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session6.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session6.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session6.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session6.LedOff(1:10,1:12) = datastructure.Session6.DataAnalysis(102:111,1:12);
            datastructure.Session6.LedOff(11:20,1:12) = datastructure.Session6.DataAnalysis(122:131,1:12);
            datastructure.Session6.LedOff(21:40,1:12) = datastructure.Session6.DataAnalysis(142:161,1:12);
            datastructure.Session6.LedOff(41:50,1:12) = datastructure.Session6.DataAnalysis(172:181,1:12);
            datastructure.Session6.LedOff(51:60,1:12) = datastructure.Session6.DataAnalysis(192:201,1:12);
            datastructure.Session6.LedOn(1:10,1:12) = datastructure.Session6.DataAnalysis(112:121,1:12);
            datastructure.Session6.LedOn(11:20,1:12) = datastructure.Session6.DataAnalysis(132:141,1:12);
            datastructure.Session6.LedOn(21:30,1:12) = datastructure.Session6.DataAnalysis(162:171,1:12);
            datastructure.Session6.LedOn(31:40,1:12) = datastructure.Session6.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session6.Offperc(L,1) = (sum(datastructure.Session6.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session6.Offperc(L,2) = (sum(datastructure.Session6.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session6.Offperc(L,3) = (sum(datastructure.Session6.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session6.Offperc(L,4) = (sum(datastructure.Session6.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session6.Offperc(L,5) = sum(datastructure.Session6.LedOff(B:C,6));
                datastructure.Session6.Offperc(L,6) = sum(datastructure.Session6.LedOff(B:C,11));
                datastructure.Session6.TotalOffRTs(L,1) = sum(datastructure.Session6.LedOff(B:C,6) > 0);
                datastructure.Session6.TotalOffRTs(L,2) = sum(datastructure.Session6.LedOff(B:C,11) > 0);
                datastructure.Session6.Offperc(L,5) = (datastructure.Session6.Offperc(L,5) / datastructure.Session6.TotalOffRTs(L,1));
                datastructure.Session6.Offperc(L,6) = (datastructure.Session6.Offperc(L,6) / datastructure.Session6.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session6.Onperc(L,1) = (sum(datastructure.Session6.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,2) = (sum(datastructure.Session6.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,3) = (sum(datastructure.Session6.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,4) = (sum(datastructure.Session6.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session6.Onperc(L,5) = sum(datastructure.Session6.LedOn(B:C,6));
                datastructure.Session6.Onperc(L,6) = sum(datastructure.Session6.LedOn(B:C,11));
                datastructure.Session6.TotalOnRTs(L,1) = sum(datastructure.Session6.LedOn(B:C,6) > 0);
                datastructure.Session6.TotalOnRTs(L,2) = sum(datastructure.Session6.LedOn(B:C,11) > 0);
                datastructure.Session6.Onperc(L,5) = (datastructure.Session6.Onperc(L,5) / datastructure.Session6.TotalOnRTs(L,1));
                datastructure.Session6.Onperc(L,6) = (datastructure.Session6.Onperc(L,6) / datastructure.Session6.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session6.Offperc(isnan(datastructure.Session6.Offperc)) = 0;
            datastructure.Session6.Onperc(isnan(datastructure.Session6.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session6.OffData(L,1) = (datastructure.Session6.Offperc(M,1) / (datastructure.Session6.Offperc(M,1) + datastructure.Session6.Offperc(M,3)));
                datastructure.Session6.OffData(L,2) = (datastructure.Session6.Offperc(M,4) / (datastructure.Session6.Offperc(M,4) + datastructure.Session6.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session6.OffData(L,1) == 1
                    datastructure.Session6.OffData(L,1) = datastructure.Session6.OffData(L,1) - 0.0001;
                end
                if datastructure.Session6.OffData(L,1) == 0
                    datastructure.Session6.OffData(L,1) = datastructure.Session6.OffData(L,1) + 0.0001;
                end
                if datastructure.Session6.OffData(L,2) == 1
                    datastructure.Session6.OffData(L,2) = datastructure.Session6.OffData(L,2) - 0.0001;
                end
                if datastructure.Session6.OffData(L,2) == 0
                    datastructure.Session6.OffData(L,2) = datastructure.Session6.OffData(L,2) + 0.0001;
                end
                datastructure.Session6.OffData(L,3) = (norminv(datastructure.Session6.OffData(M,1)) - norminv(datastructure.Session6.OffData(M,2)));
                datastructure.Session6.OffData(L,4) = 0.5 * (norminv(datastructure.Session6.OffData(M,1)) + norminv(datastructure.Session6.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session6.OnData(L,1) = (datastructure.Session6.Onperc(M,1) / (datastructure.Session6.Onperc(M,1) + datastructure.Session6.Onperc(M,3)));
                datastructure.Session6.OnData(L,2) = (datastructure.Session6.Onperc(M,4) / (datastructure.Session6.Onperc(M,4) + datastructure.Session6.Onperc(M,2)));
                if datastructure.Session6.OnData(L,1) == 1
                    datastructure.Session6.OnData(L,1) = datastructure.Session6.OnData(L,1) - 0.0001;
                end
                if datastructure.Session6.OnData(L,1) == 0
                    datastructure.Session6.OnData(L,1) = datastructure.Session6.OnData(L,1) + 0.0001;
                end
                if datastructure.Session6.OnData(L,2) == 1
                    datastructure.Session6.OnData(L,2) = datastructure.Session6.OnData(L,2) - 0.0001;
                end
                if datastructure.Session6.OnData(L,2) == 0
                    datastructure.Session6.OnData(L,2) = datastructure.Session6.OnData(L,2) + 0.0001;
                end
                datastructure.Session6.OnData(L,3) = (norminv(datastructure.Session6.OnData(M,1)) - norminv(datastructure.Session6.OnData(M,2)));
                datastructure.Session6.OnData(L,4) = 0.5 * (norminv(datastructure.Session6.OnData(M,1)) + norminv(datastructure.Session6.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session6.FinalData = [datastructure.Session6.OffData(1:4,:) datastructure.Session6.Offperc(1:4,5:6) datastructure.Session6.OnData datastructure.Session6.Onperc(1:4,5:6)];
            x = x + 1;   
        end
        
%% Start Session 7





    elseif i == 7
        
        datastructure.Session7.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session7.BaseData = [];
            RTs = [sum(datastructure.Session7.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session7.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session7.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session7.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session7.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session7.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session7.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session7.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session7.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session7.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session7.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session7.FinalData(1,1) = ((datastructure.Session7.BaseData(1,1)) / (datastructure.Session7.BaseData(1,1) + datastructure.Session7.BaseData(3,1))) - 0.0001;
            datastructure.Session7.FinalData(1,2) = ((datastructure.Session7.BaseData(4,1)) / (datastructure.Session7.BaseData(4,1) + datastructure.Session7.BaseData(2,1))) + 0.0001;
            datastructure.Session7.FinalData(1,3) = (norminv(datastructure.Session7.FinalData(1,1)) - norminv(datastructure.Session7.FinalData(1,2)));
            datastructure.Session7.FinalData(1,4) = 0.5 * (norminv(datastructure.Session7.FinalData(1,1)) + norminv(datastructure.Session7.FinalData(1,2)));
            datastructure.Session7.FinalData(1,5) = datastructure.Session7.BaseData(5,1);
            datastructure.Session7.FinalData(1,6) = datastructure.Session7.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session7.BasePercData = [];
            RTs = [sum(datastructure.Session7.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session7.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session7.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session7.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session7.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session7.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session7.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session7.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session7.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session7.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session7.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session7.LedOff(Y:Z,:) = datastructure.Session7.DataAnalysis(112+X:121+X,:);
                datastructure.Session7.LedOn(Y:Z,:) = datastructure.Session7.DataAnalysis(102+X:111+X,:);
                datastructure.Session7.Offperc(L,1) = (sum(datastructure.Session7.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session7.Offperc(L,2) = (sum(datastructure.Session7.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session7.Offperc(L,3) = (sum(datastructure.Session7.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session7.Offperc(L,4) = (sum(datastructure.Session7.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,1) = (sum(datastructure.Session7.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,2) = (sum(datastructure.Session7.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,3) = (sum(datastructure.Session7.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,4) = (sum(datastructure.Session7.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session7.Offperc(L,5) = sum(datastructure.Session7.LedOff(B:C,6));
                datastructure.Session7.Offperc(L,6) = sum(datastructure.Session7.LedOff(B:C,11));
                datastructure.Session7.Onperc(L,5) = sum(datastructure.Session7.LedOn(B:C,6));
                datastructure.Session7.Onperc(L,6) = sum(datastructure.Session7.LedOn(B:C,11));
                datastructure.Session7.TotalOffRTs(L,1) = sum(datastructure.Session7.LedOff(B:C,6) > 0);
                datastructure.Session7.TotalOffRTs(L,2) = sum(datastructure.Session7.LedOff(B:C,11) > 0);
                datastructure.Session7.TotalOnRTs(L,1) = sum(datastructure.Session7.LedOn(B:C,6) > 0);
                datastructure.Session7.TotalOnRTs(L,2) = sum(datastructure.Session7.LedOn(B:C,11) > 0);
                datastructure.Session7.Offperc(L,5) = (datastructure.Session7.Offperc(L,5) / datastructure.Session7.TotalOffRTs(L,1));
                datastructure.Session7.Offperc(L,6) = (datastructure.Session7.Offperc(L,6) / datastructure.Session7.TotalOffRTs(L,2));
                datastructure.Session7.Onperc(L,5) = (datastructure.Session7.Onperc(L,5) / datastructure.Session7.TotalOnRTs(L,1));
                datastructure.Session7.Onperc(L,6) = (datastructure.Session7.Onperc(L,6) / datastructure.Session7.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session7.Offperc(isnan(datastructure.Session7.Offperc)) = 0;
            datastructure.Session7.Onperc(isnan(datastructure.Session7.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session7.OffData(L,1) = (datastructure.Session7.Offperc(M,1) / (datastructure.Session7.Offperc(M,1) + datastructure.Session7.Offperc(M,3)));
                datastructure.Session7.OffData(L,2) = (datastructure.Session7.Offperc(M,4) / (datastructure.Session7.Offperc(M,4) + datastructure.Session7.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session7.OffData(L,1) == 1
                    datastructure.Session7.OffData(L,1) = datastructure.Session7.OffData(L,1) - 0.0001;
                end
                if datastructure.Session7.OffData(L,1) == 0
                    datastructure.Session7.OffData(L,1) = datastructure.Session7.OffData(L,1) + 0.0001;
                end
                if datastructure.Session7.OffData(L,2) == 1
                    datastructure.Session7.OffData(L,2) = datastructure.Session7.OffData(L,2) - 0.0001;
                end
                if datastructure.Session7.OffData(L,2) == 0
                    datastructure.Session7.OffData(L,2) = datastructure.Session7.OffData(L,2) + 0.0001;
                end
                datastructure.Session7.OffData(L,3) = (norminv(datastructure.Session7.OffData(M,1)) - norminv(datastructure.Session7.OffData(M,2)));
                datastructure.Session7.OffData(L,4) = 0.5 * (norminv(datastructure.Session7.OffData(M,1)) + norminv(datastructure.Session7.OffData(M,2)));
                datastructure.Session7.OnData(L,1) = (datastructure.Session7.Onperc(M,1) / (datastructure.Session7.Onperc(M,1) + datastructure.Session7.Onperc(M,3)));
                datastructure.Session7.OnData(L,2) = (datastructure.Session7.Onperc(M,4) / (datastructure.Session7.Onperc(M,4) + datastructure.Session7.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session7.OnData(L,1) == 1
                    datastructure.Session7.OnData(L,1) = datastructure.Session7.OnData(L,1) - 0.0001;
                end
                if datastructure.Session7.OnData(L,1) == 0
                    datastructure.Session7.OnData(L,1) = datastructure.Session7.OnData(L,1) + 0.0001;
                end
                if datastructure.Session7.OnData(L,2) == 1
                    datastructure.Session7.OnData(L,2) = datastructure.Session7.OnData(L,2) - 0.0001;
                end
                if datastructure.Session7.OnData(L,2) == 0
                    datastructure.Session7.OnData(L,2) = datastructure.Session7.OnData(L,2) + 0.0001;
                end
                datastructure.Session7.OnData(L,3) = (norminv(datastructure.Session7.OnData(M,1)) - norminv(datastructure.Session7.OnData(M,2)));
                datastructure.Session7.OnData(L,4) = 0.5 * (norminv(datastructure.Session7.OnData(M,1)) + norminv(datastructure.Session7.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session7.FinalData = [datastructure.Session7.OffData datastructure.Session7.Offperc(:,5:6) datastructure.Session7.OnData datastructure.Session7.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session7.BasePercData = [];
            RTs = [sum(datastructure.Session7.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session7.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session7.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session7.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session7.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session7.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session7.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session7.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session7.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session7.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session7.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session7.LedOff(1:10,1:12) = datastructure.Session7.DataAnalysis(102:111,1:12);
            datastructure.Session7.LedOff(11:20,1:12) = datastructure.Session7.DataAnalysis(122:131,1:12);
            datastructure.Session7.LedOff(21:40,1:12) = datastructure.Session7.DataAnalysis(142:161,1:12);
            datastructure.Session7.LedOff(41:50,1:12) = datastructure.Session7.DataAnalysis(172:181,1:12);
            datastructure.Session7.LedOff(51:60,1:12) = datastructure.Session7.DataAnalysis(192:201,1:12);
            datastructure.Session7.LedOn(1:10,1:12) = datastructure.Session7.DataAnalysis(112:121,1:12);
            datastructure.Session7.LedOn(11:20,1:12) = datastructure.Session7.DataAnalysis(132:141,1:12);
            datastructure.Session7.LedOn(21:30,1:12) = datastructure.Session7.DataAnalysis(162:171,1:12);
            datastructure.Session7.LedOn(31:40,1:12) = datastructure.Session7.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session7.Offperc(L,1) = (sum(datastructure.Session7.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session7.Offperc(L,2) = (sum(datastructure.Session7.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session7.Offperc(L,3) = (sum(datastructure.Session7.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session7.Offperc(L,4) = (sum(datastructure.Session7.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session7.Offperc(L,5) = sum(datastructure.Session7.LedOff(B:C,6));
                datastructure.Session7.Offperc(L,6) = sum(datastructure.Session7.LedOff(B:C,11));
                datastructure.Session7.TotalOffRTs(L,1) = sum(datastructure.Session7.LedOff(B:C,6) > 0);
                datastructure.Session7.TotalOffRTs(L,2) = sum(datastructure.Session7.LedOff(B:C,11) > 0);
                datastructure.Session7.Offperc(L,5) = (datastructure.Session7.Offperc(L,5) / datastructure.Session7.TotalOffRTs(L,1));
                datastructure.Session7.Offperc(L,6) = (datastructure.Session7.Offperc(L,6) / datastructure.Session7.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session7.Onperc(L,1) = (sum(datastructure.Session7.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,2) = (sum(datastructure.Session7.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,3) = (sum(datastructure.Session7.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,4) = (sum(datastructure.Session7.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session7.Onperc(L,5) = sum(datastructure.Session7.LedOn(B:C,6));
                datastructure.Session7.Onperc(L,6) = sum(datastructure.Session7.LedOn(B:C,11));
                datastructure.Session7.TotalOnRTs(L,1) = sum(datastructure.Session7.LedOn(B:C,6) > 0);
                datastructure.Session7.TotalOnRTs(L,2) = sum(datastructure.Session7.LedOn(B:C,11) > 0);
                datastructure.Session7.Onperc(L,5) = (datastructure.Session7.Onperc(L,5) / datastructure.Session7.TotalOnRTs(L,1));
                datastructure.Session7.Onperc(L,6) = (datastructure.Session7.Onperc(L,6) / datastructure.Session7.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session7.Offperc(isnan(datastructure.Session7.Offperc)) = 0;
            datastructure.Session7.Onperc(isnan(datastructure.Session7.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session7.OffData(L,1) = (datastructure.Session7.Offperc(M,1) / (datastructure.Session7.Offperc(M,1) + datastructure.Session7.Offperc(M,3)));
                datastructure.Session7.OffData(L,2) = (datastructure.Session7.Offperc(M,4) / (datastructure.Session7.Offperc(M,4) + datastructure.Session7.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session7.OffData(L,1) == 1
                    datastructure.Session7.OffData(L,1) = datastructure.Session7.OffData(L,1) - 0.0001;
                end
                if datastructure.Session7.OffData(L,1) == 0
                    datastructure.Session7.OffData(L,1) = datastructure.Session7.OffData(L,1) + 0.0001;
                end
                if datastructure.Session7.OffData(L,2) == 1
                    datastructure.Session7.OffData(L,2) = datastructure.Session7.OffData(L,2) - 0.0001;
                end
                if datastructure.Session7.OffData(L,2) == 0
                    datastructure.Session7.OffData(L,2) = datastructure.Session7.OffData(L,2) + 0.0001;
                end
                datastructure.Session7.OffData(L,3) = (norminv(datastructure.Session7.OffData(M,1)) - norminv(datastructure.Session7.OffData(M,2)));
                datastructure.Session7.OffData(L,4) = 0.5 * (norminv(datastructure.Session7.OffData(M,1)) + norminv(datastructure.Session7.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session7.OnData(L,1) = (datastructure.Session7.Onperc(M,1) / (datastructure.Session7.Onperc(M,1) + datastructure.Session7.Onperc(M,3)));
                datastructure.Session7.OnData(L,2) = (datastructure.Session7.Onperc(M,4) / (datastructure.Session7.Onperc(M,4) + datastructure.Session7.Onperc(M,2)));
                if datastructure.Session7.OnData(L,1) == 1
                    datastructure.Session7.OnData(L,1) = datastructure.Session7.OnData(L,1) - 0.0001;
                end
                if datastructure.Session7.OnData(L,1) == 0
                    datastructure.Session7.OnData(L,1) = datastructure.Session7.OnData(L,1) + 0.0001;
                end
                if datastructure.Session7.OnData(L,2) == 1
                    datastructure.Session7.OnData(L,2) = datastructure.Session7.OnData(L,2) - 0.0001;
                end
                if datastructure.Session7.OnData(L,2) == 0
                    datastructure.Session7.OnData(L,2) = datastructure.Session7.OnData(L,2) + 0.0001;
                end
                datastructure.Session7.OnData(L,3) = (norminv(datastructure.Session7.OnData(M,1)) - norminv(datastructure.Session7.OnData(M,2)));
                datastructure.Session7.OnData(L,4) = 0.5 * (norminv(datastructure.Session7.OnData(M,1)) + norminv(datastructure.Session7.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session7.FinalData = [datastructure.Session7.OffData(1:4,:) datastructure.Session7.Offperc(1:4,5:6) datastructure.Session7.OnData datastructure.Session7.Onperc(1:4,5:6)];
            x = x + 1;   
        end
        
%% Start Session 8







    else i = 8;
        
        datastructure.Session8.AnalysisSetting = Decision(1,x);
        if Decision(1,x) == 0
            datastructure.Session8.BaseData = [];
            RTs = [sum(datastructure.Session8.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session8.DataAnalysis(2:end,11) > 0.001)];
            BaseTrials = size(datastructure.Session8.DataAnalysis);
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session8.DataAnalysis(2:end,12)));
            perc_Gos = (sum(datastructure.Session8.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
            perc_NoGos = ((sum(datastructure.Session8.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session8.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session8.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session8.DataAnalysis(2:end,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session8.DataAnalysis(2:end,11) / RTs(1,2)));
            datastructure.Session8.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
            datastructure.Session8.FinalData(1,1) = ((datastructure.Session8.BaseData(1,1)) / (datastructure.Session8.BaseData(1,1) + datastructure.Session8.BaseData(3,1))) - 0.0001;
            datastructure.Session8.FinalData(1,2) = ((datastructure.Session8.BaseData(4,1)) / (datastructure.Session8.BaseData(4,1) + datastructure.Session8.BaseData(2,1))) + 0.0001;
            datastructure.Session8.FinalData(1,3) = (norminv(datastructure.Session8.FinalData(1,1)) - norminv(datastructure.Session8.FinalData(1,2)));
            datastructure.Session8.FinalData(1,4) = 0.5 * (norminv(datastructure.Session8.FinalData(1,1)) + norminv(datastructure.Session8.FinalData(1,2)));
            datastructure.Session8.FinalData(1,5) = datastructure.Session8.BaseData(5,1);
            datastructure.Session8.FinalData(1,6) = datastructure.Session8.BaseData(6,1);

            x = x + 1;
     
        elseif Decision(1,x) == 1
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session8.BasePercData = [];
            RTs = [sum(datastructure.Session8.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session8.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session8.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session8.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session8.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session8.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session8.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session8.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session8.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session8.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session8.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            X = 0;
            Y = 1;
            Z = 10;
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both types of RTs
            for a = 1:5
                datastructure.Session8.LedOff(Y:Z,:) = datastructure.Session8.DataAnalysis(112+X:121+X,:);
                datastructure.Session8.LedOn(Y:Z,:) = datastructure.Session8.DataAnalysis(102+X:111+X,:);
                datastructure.Session8.Offperc(L,1) = (sum(datastructure.Session8.LedOff(J:K,7) == 1) / 10)* 100;
                datastructure.Session8.Offperc(L,2) = (sum(datastructure.Session8.LedOff(J:K,8) == 1) / 10 )* 100;
                datastructure.Session8.Offperc(L,3) = (sum(datastructure.Session8.LedOff(J:K,9) == 1) / 10)* 100;
                datastructure.Session8.Offperc(L,4) = (sum(datastructure.Session8.LedOff(J:K,10) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,1) = (sum(datastructure.Session8.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,2) = (sum(datastructure.Session8.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,3) = (sum(datastructure.Session8.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,4) = (sum(datastructure.Session8.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session8.Offperc(L,5) = sum(datastructure.Session8.LedOff(B:C,6));
                datastructure.Session8.Offperc(L,6) = sum(datastructure.Session8.LedOff(B:C,11));
                datastructure.Session8.Onperc(L,5) = sum(datastructure.Session8.LedOn(B:C,6));
                datastructure.Session8.Onperc(L,6) = sum(datastructure.Session8.LedOn(B:C,11));
                datastructure.Session8.TotalOffRTs(L,1) = sum(datastructure.Session8.LedOff(B:C,6) > 0);
                datastructure.Session8.TotalOffRTs(L,2) = sum(datastructure.Session8.LedOff(B:C,11) > 0);
                datastructure.Session8.TotalOnRTs(L,1) = sum(datastructure.Session8.LedOn(B:C,6) > 0);
                datastructure.Session8.TotalOnRTs(L,2) = sum(datastructure.Session8.LedOn(B:C,11) > 0);
                datastructure.Session8.Offperc(L,5) = (datastructure.Session8.Offperc(L,5) / datastructure.Session8.TotalOffRTs(L,1));
                datastructure.Session8.Offperc(L,6) = (datastructure.Session8.Offperc(L,6) / datastructure.Session8.TotalOffRTs(L,2));
                datastructure.Session8.Onperc(L,5) = (datastructure.Session8.Onperc(L,5) / datastructure.Session8.TotalOnRTs(L,1));
                datastructure.Session8.Onperc(L,6) = (datastructure.Session8.Onperc(L,6) / datastructure.Session8.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
                X = X + 20;
                Y = Y + 10;
                Z = Z + 10;
            end
            
            %This bit of code changes any NaNs present for GoRT/FART (if
            %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session8.Offperc(isnan(datastructure.Session8.Offperc)) = 0;
            datastructure.Session8.Onperc(isnan(datastructure.Session8.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off/On trials
            L = 1;
            M = 1;
            for a = 1:5
                datastructure.Session8.OffData(L,1) = (datastructure.Session8.Offperc(M,1) / (datastructure.Session8.Offperc(M,1) + datastructure.Session8.Offperc(M,3)));
                datastructure.Session8.OffData(L,2) = (datastructure.Session8.Offperc(M,4) / (datastructure.Session8.Offperc(M,4) + datastructure.Session8.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session8.OffData(L,1) == 1
                    datastructure.Session8.OffData(L,1) = datastructure.Session8.OffData(L,1) - 0.0001;
                end
                if datastructure.Session8.OffData(L,1) == 0
                    datastructure.Session8.OffData(L,1) = datastructure.Session8.OffData(L,1) + 0.0001;
                end
                if datastructure.Session8.OffData(L,2) == 1
                    datastructure.Session8.OffData(L,2) = datastructure.Session8.OffData(L,2) - 0.0001;
                end
                if datastructure.Session8.OffData(L,2) == 0
                    datastructure.Session8.OffData(L,2) = datastructure.Session8.OffData(L,2) + 0.0001;
                end
                datastructure.Session8.OffData(L,3) = (norminv(datastructure.Session8.OffData(M,1)) - norminv(datastructure.Session8.OffData(M,2)));
                datastructure.Session8.OffData(L,4) = 0.5 * (norminv(datastructure.Session8.OffData(M,1)) + norminv(datastructure.Session8.OffData(M,2)));
                datastructure.Session8.OnData(L,1) = (datastructure.Session8.Onperc(M,1) / (datastructure.Session8.Onperc(M,1) + datastructure.Session8.Onperc(M,3)));
                datastructure.Session8.OnData(L,2) = (datastructure.Session8.Onperc(M,4) / (datastructure.Session8.Onperc(M,4) + datastructure.Session8.Onperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session8.OnData(L,1) == 1
                    datastructure.Session8.OnData(L,1) = datastructure.Session8.OnData(L,1) - 0.0001;
                end
                if datastructure.Session8.OnData(L,1) == 0
                    datastructure.Session8.OnData(L,1) = datastructure.Session8.OnData(L,1) + 0.0001;
                end
                if datastructure.Session8.OnData(L,2) == 1
                    datastructure.Session8.OnData(L,2) = datastructure.Session8.OnData(L,2) - 0.0001;
                end
                if datastructure.Session8.OnData(L,2) == 0
                    datastructure.Session8.OnData(L,2) = datastructure.Session8.OnData(L,2) + 0.0001;
                end
                datastructure.Session8.OnData(L,3) = (norminv(datastructure.Session8.OnData(M,1)) - norminv(datastructure.Session8.OnData(M,2)));
                datastructure.Session8.OnData(L,4) = 0.5 * (norminv(datastructure.Session8.OnData(M,1)) + norminv(datastructure.Session8.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session8.FinalData = [datastructure.Session8.OffData datastructure.Session8.Offperc(:,5:6) datastructure.Session8.OnData datastructure.Session8.Onperc(:,5:6)];
            x = x + 1;
       
        else Decision(x,1) = 2
            %Added in baseline data (for first 100 trials) for LED
            %Settings 1 and 2 for all Sessions (1-8)
            %Modified on 3/4/21 by AY
            
            %Calculate percent of trials dedicated to Hit/FA/Miss/NoGo and
            %mean GoRT/FART
            datastructure.Session8.BasePercData = [];
            RTs = [sum(datastructure.Session8.DataAnalysis(2:101,6) >= 0.001), sum(datastructure.Session8.DataAnalysis(2:101,11) > 0.001)];
            BaseTrials = size(datastructure.Session8.DataAnalysis(2:101,:));
            BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session8.DataAnalysis(2:101,12)));
            perc_Gos = (sum(datastructure.Session8.DataAnalysis(2:101,7)) / BaseTrials(1,1) * 100);
            perc_NoGos = ((sum(datastructure.Session8.DataAnalysis(2:101,8)) / BaseTrials(1,1)) * 100);
            perc_FAs = ((sum(datastructure.Session8.DataAnalysis(2:101,10)) / BaseTrials(1,1)) * 100);
            perc_Miss = ((sum(datastructure.Session8.DataAnalysis(2:101,9)) / BaseTrials(1,1)) * 100);
            meanGoRT = (sum(datastructure.Session8.DataAnalysis(2:101,6) / RTs(1,1)));
            meanFART = (sum(datastructure.Session8.DataAnalysis(2:101,11) / RTs(1,2)));
            datastructure.Session8.BasePercData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
            
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Selects trials to be used for LED Off and On analysis
            datastructure.Session8.LedOff(1:10,1:12) = datastructure.Session8.DataAnalysis(102:111,1:12);
            datastructure.Session8.LedOff(11:20,1:12) = datastructure.Session8.DataAnalysis(122:131,1:12);
            datastructure.Session8.LedOff(21:40,1:12) = datastructure.Session8.DataAnalysis(142:161,1:12);
            datastructure.Session8.LedOff(41:50,1:12) = datastructure.Session8.DataAnalysis(172:181,1:12);
            datastructure.Session8.LedOff(51:60,1:12) = datastructure.Session8.DataAnalysis(192:201,1:12);
            datastructure.Session8.LedOn(1:10,1:12) = datastructure.Session8.DataAnalysis(112:121,1:12);
            datastructure.Session8.LedOn(11:20,1:12) = datastructure.Session8.DataAnalysis(132:141,1:12);
            datastructure.Session8.LedOn(21:30,1:12) = datastructure.Session8.DataAnalysis(162:171,1:12);
            datastructure.Session8.LedOn(31:40,1:12) = datastructure.Session8.DataAnalysis(182:191,1:12);
            %Calculate the percentage of Gos, FAs, Misses, NoGos, and both
            %types of RTs for the Off blocks
            for a = 1:6
                datastructure.Session8.Offperc(L,1) = (sum(datastructure.Session8.LedOff(J:K,7) == 1) / 10) * 100;
                datastructure.Session8.Offperc(L,2) = (sum(datastructure.Session8.LedOff(J:K,8) == 1) / 10) * 100;
                datastructure.Session8.Offperc(L,3) = (sum(datastructure.Session8.LedOff(J:K,9) == 1) / 10) * 100;
                datastructure.Session8.Offperc(L,4) = (sum(datastructure.Session8.LedOff(J:K,10) == 1) / 10) * 100;
                datastructure.Session8.Offperc(L,5) = sum(datastructure.Session8.LedOff(B:C,6));
                datastructure.Session8.Offperc(L,6) = sum(datastructure.Session8.LedOff(B:C,11));
                datastructure.Session8.TotalOffRTs(L,1) = sum(datastructure.Session8.LedOff(B:C,6) > 0);
                datastructure.Session8.TotalOffRTs(L,2) = sum(datastructure.Session8.LedOff(B:C,11) > 0);
                datastructure.Session8.Offperc(L,5) = (datastructure.Session8.Offperc(L,5) / datastructure.Session8.TotalOffRTs(L,1));
                datastructure.Session8.Offperc(L,6) = (datastructure.Session8.Offperc(L,6) / datastructure.Session8.TotalOffRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            B = 1;
            C = 10;
            L = 1;
            J = 1;
            K = 10;
            %Calculate same percentages as above for the On blocks
            for a = 1:4
                datastructure.Session8.Onperc(L,1) = (sum(datastructure.Session8.LedOn(J:K,7) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,2) = (sum(datastructure.Session8.LedOn(J:K,8) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,3) = (sum(datastructure.Session8.LedOn(J:K,9) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,4) = (sum(datastructure.Session8.LedOn(J:K,10) == 1) / 10)* 100;
                datastructure.Session8.Onperc(L,5) = sum(datastructure.Session8.LedOn(B:C,6));
                datastructure.Session8.Onperc(L,6) = sum(datastructure.Session8.LedOn(B:C,11));
                datastructure.Session8.TotalOnRTs(L,1) = sum(datastructure.Session8.LedOn(B:C,6) > 0);
                datastructure.Session8.TotalOnRTs(L,2) = sum(datastructure.Session8.LedOn(B:C,11) > 0);
                datastructure.Session8.Onperc(L,5) = (datastructure.Session8.Onperc(L,5) / datastructure.Session8.TotalOnRTs(L,1));
                datastructure.Session8.Onperc(L,6) = (datastructure.Session8.Onperc(L,6) / datastructure.Session8.TotalOnRTs(L,2));
                B = B + 10;
                C = C + 10;
                L = L + 1;
                J = J + 10;
                K = K + 10;
            end
            %This bit of code changes any NaNs present for GoRT/FART (if %the animal did not commit any Hits/FAs in a block) with a 0
            datastructure.Session8.Offperc(isnan(datastructure.Session8.Offperc)) = 0;
            datastructure.Session8.Onperc(isnan(datastructure.Session8.Onperc)) = 0;
            
            %For loop calculates Hit Rate, FA Rate, Sensitivity, and Bias for each
            %block of 10 Off trials
            L = 1;
            M = 1;
            for a = 1:6
                datastructure.Session8.OffData(L,1) = (datastructure.Session8.Offperc(M,1) / (datastructure.Session8.Offperc(M,1) + datastructure.Session8.Offperc(M,3)));
                datastructure.Session8.OffData(L,2) = (datastructure.Session8.Offperc(M,4) / (datastructure.Session8.Offperc(M,4) + datastructure.Session8.Offperc(M,2)));
                %These for loops examine if the Hit Rate/FA Rate are either
                %0 or 1 and manipulate the value to provide usable d' and
                %bias measurements
                if datastructure.Session8.OffData(L,1) == 1
                    datastructure.Session8.OffData(L,1) = datastructure.Session8.OffData(L,1) - 0.0001;
                end
                if datastructure.Session8.OffData(L,1) == 0
                    datastructure.Session8.OffData(L,1) = datastructure.Session8.OffData(L,1) + 0.0001;
                end
                if datastructure.Session8.OffData(L,2) == 1
                    datastructure.Session8.OffData(L,2) = datastructure.Session8.OffData(L,2) - 0.0001;
                end
                if datastructure.Session8.OffData(L,2) == 0
                    datastructure.Session8.OffData(L,2) = datastructure.Session8.OffData(L,2) + 0.0001;
                end
                datastructure.Session8.OffData(L,3) = (norminv(datastructure.Session8.OffData(M,1)) - norminv(datastructure.Session8.OffData(M,2)));
                datastructure.Session8.OffData(L,4) = 0.5 * (norminv(datastructure.Session8.OffData(M,1)) + norminv(datastructure.Session8.OffData(M,2)));
                L = L + 1;
                M = M + 1;
            end

            L = 1;
            M = 1;
            for a = 1:4
                datastructure.Session8.OnData(L,1) = (datastructure.Session8.Onperc(M,1) / (datastructure.Session8.Onperc(M,1) + datastructure.Session8.Onperc(M,3)));
                datastructure.Session8.OnData(L,2) = (datastructure.Session8.Onperc(M,4) / (datastructure.Session8.Onperc(M,4) + datastructure.Session8.Onperc(M,2)));
                if datastructure.Session8.OnData(L,1) == 1
                    datastructure.Session8.OnData(L,1) = datastructure.Session8.OnData(L,1) - 0.0001;
                end
                if datastructure.Session8.OnData(L,1) == 0
                    datastructure.Session8.OnData(L,1) = datastructure.Session8.OnData(L,1) + 0.0001;
                end
                if datastructure.Session8.OnData(L,2) == 1
                    datastructure.Session8.OnData(L,2) = datastructure.Session8.OnData(L,2) - 0.0001;
                end
                if datastructure.Session8.OnData(L,2) == 0
                    datastructure.Session8.OnData(L,2) = datastructure.Session8.OnData(L,2) + 0.0001;
                end
                datastructure.Session8.OnData(L,3) = (norminv(datastructure.Session8.OnData(M,1)) - norminv(datastructure.Session8.OnData(M,2)));
                datastructure.Session8.OnData(L,4) = 0.5 * (norminv(datastructure.Session8.OnData(M,1)) + norminv(datastructure.Session8.OnData(M,2)));
                L = L + 1;
                M = M + 1;
            end
            datastructure.Session8.FinalData = [datastructure.Session8.OffData(1:4,:) datastructure.Session8.Offperc(1:4,5:6) datastructure.Session8.OnData datastructure.Session8.Onperc(1:4,5:6)];
            x = x + 1;   
        end
    end
end

save('Multi_Behavioral_Analysis.mat','datastructure');