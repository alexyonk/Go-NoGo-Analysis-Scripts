% -- This script is designed to sort multiple (up to 8!) behavioral text
% files simultaneously. The script needs to be amended for any additional
% files. While it is designed to deal with 8 text files simultaneously, it also
% works with any variety of 1-8 files. NOTE: Requires the subdir folder to
% be present in the path!!!!!


%To be used in conjuction with the Multi_Behavioral_Analysis_AY script


%                       *Created on 7_14_20 by AY*
%                       *Updated by AY on 12_9_20*

clear;
clc;
%Allows user to select the directory
start_dir = uigetdir;
cd(start_dir);
%Performs a recursive search for a specific file extension (.txt) in the
%assigned directory
txtfiles = subdir('*.txt');

%Sets up variable used in the following for loop and creates a structure to
%store all data
x = 1;
datastructure = struct();

%For loop reads in each text file from the subdirectory, changes the
%Event/Time information to cells, and organizes it into the nested
%structure. It also sorts the data accordingly before inserting it into the
%appropriate nested data structure
for i = 1:size(txtfiles)
    tdfread(txtfiles(x).name);
    Event = cellstr(Event);
    Time = cellstr(Time);
    Data = [];
    digitsFromEnd = 6;
    id = 1;
    
    if i == 1
        datastructure = setfield(datastructure,'Session1','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session1','Events',[Event]);
        datastructure = setfield(datastructure,'Session1','Time',[Time]);
        datastructure = setfield(datastructure,'Session1','Trials',[Trial]);
        
        digitsTime = strlength(datastructure.Session1.Time(1,1));
        
        for i = 1:size(datastructure.Session1.Events)
        if strcmp(datastructure.Session1.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session1.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session1.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session1.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session1.Events(i),'End Trial')
            time = datastructure.Session1.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session1.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session1.Events{i};
        elseif strfind(datastructure.Session1.Events{i},'Go') == 1
            if strfind(datastructure.Session1.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session1.Events{i-2};
            else
                Data{id,5} = datastructure.Session1.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session1.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session1.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session1.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session1.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session1.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session1.Events{i},'No') == 1
            Data{id,5} = datastructure.Session1.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session1.Events{i},'In') == 1
            Data{id,5} = datastructure.Session1.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session1.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session1.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session1.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session1.Data = Data;
    datastructure.Session1.DataAnalysis = str2double(Data);
    datastructure.Session1.DataAnalysis(2,1:2) = 1;
    datastructure.Session1.DataAnalysis(isnan(datastructure.Session1.DataAnalysis)) = 0;
    x = x + 1;
    
%% -- Session 2 Start


    elseif i == 2
        datastructure = setfield(datastructure,'Session2','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session2','Events',[Event]);
        datastructure = setfield(datastructure,'Session2','Time',[Time]);
        datastructure = setfield(datastructure,'Session2','Trials',[Trial]);
        digitsTime = strlength(datastructure.Session2.Time(1,1));
        
        for i = 1:size(datastructure.Session2.Events)
        if strcmp(datastructure.Session2.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session2.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session2.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session2.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session2.Events(i),'End Trial')
            time = datastructure.Session2.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session2.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session2.Events{i};
        elseif strfind(datastructure.Session2.Events{i},'Go') == 1
            if strfind(datastructure.Session2.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session2.Events{i-2};
            else
                Data{id,5} = datastructure.Session2.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session2.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session2.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session2.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session2.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session2.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session2.Events{i},'No') == 1
            Data{id,5} = datastructure.Session2.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session2.Events{i},'In') == 1
            Data{id,5} = datastructure.Session2.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session2.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session2.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session2.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
   
    datastructure.Session2.Data = Data;
    datastructure.Session2.DataAnalysis = str2double(Data);
    datastructure.Session2.DataAnalysis(2,1:2) = 1;
    datastructure.Session2.DataAnalysis(isnan(datastructure.Session2.DataAnalysis)) = 0;
    x = x + 1;
    
    
%% -- Session 3 Start


    elseif i == 3
        datastructure = setfield(datastructure,'Session3','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session3','Events',[Event]);
        datastructure = setfield(datastructure,'Session3','Time',[Time]);
        datastructure = setfield(datastructure,'Session3','Trials',[Trial]);
                digitsTime = strlength(datastructure.Session3.Time(1,1));
        
        for i = 1:size(datastructure.Session3.Events)
        if strcmp(datastructure.Session3.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session3.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session3.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session3.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session3.Events(i),'End Trial')
            time = datastructure.Session3.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session3.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session3.Events{i};
        elseif strfind(datastructure.Session3.Events{i},'Go') == 1
            if strfind(datastructure.Session3.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session3.Events{i-2};
            else
                Data{id,5} = datastructure.Session3.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session3.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session3.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session3.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session3.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session3.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session3.Events{i},'No') == 1
            Data{id,5} = datastructure.Session3.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session3.Events{i},'In') == 1
            Data{id,5} = datastructure.Session3.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session3.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session3.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session3.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session3.Data = Data;
    datastructure.Session3.DataAnalysis = str2double(Data);
    datastructure.Session3.DataAnalysis(2,1:2) = 1;
    datastructure.Session3.DataAnalysis(isnan(datastructure.Session3.DataAnalysis)) = 0;
    x = x + 1;
    
    
%% -- Session 4 Start    


    elseif i == 4
        datastructure = setfield(datastructure,'Session4','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session4','Events',[Event]);
        datastructure = setfield(datastructure,'Session4','Time',[Time]);
        datastructure = setfield(datastructure,'Session4','Trials',[Trial]);
                digitsTime = strlength(datastructure.Session4.Time(1,1));
        
        for i = 1:size(datastructure.Session4.Events)
        if strcmp(datastructure.Session4.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session4.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session4.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session4.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session4.Events(i),'End Trial')
            time = datastructure.Session4.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session4.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session4.Events{i};
        elseif strfind(datastructure.Session4.Events{i},'Go') == 1
            if strfind(datastructure.Session4.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session4.Events{i-2};
            else
                Data{id,5} = datastructure.Session4.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session4.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session4.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session4.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session4.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session4.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session4.Events{i},'No') == 1
            Data{id,5} = datastructure.Session4.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session4.Events{i},'In') == 1
            Data{id,5} = datastructure.Session4.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session4.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session4.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session4.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session4.Data = Data;
    datastructure.Session4.DataAnalysis = str2double(Data);
    datastructure.Session4.DataAnalysis(2,1:2) = 1;
    datastructure.Session4.DataAnalysis(isnan(datastructure.Session4.DataAnalysis)) = 0;
    x = x + 1;
    
    
%% -- Session 5 Start


    elseif i == 5
        datastructure = setfield(datastructure,'Session5','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session5','Events',[Event]);
        datastructure = setfield(datastructure,'Session5','Time',[Time]);
        datastructure = setfield(datastructure,'Session5','Trials',[Trial]);
        
                digitsTime = strlength(datastructure.Session5.Time(1,1));
        
        for i = 1:size(datastructure.Session5.Events)
        if strcmp(datastructure.Session5.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session5.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session5.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session5.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session5.Events(i),'End Trial')
            time = datastructure.Session5.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session5.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session5.Events{i};
        elseif strfind(datastructure.Session5.Events{i},'Go') == 1
            if strfind(datastructure.Session5.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session5.Events{i-2};
            else
                Data{id,5} = datastructure.Session5.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session5.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session5.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session5.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session5.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session5.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session5.Events{i},'No') == 1
            Data{id,5} = datastructure.Session5.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session5.Events{i},'In') == 1
            Data{id,5} = datastructure.Session5.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session5.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session5.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session5.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session5.Data = Data;
    datastructure.Session5.DataAnalysis = str2double(Data);
    datastructure.Session5.DataAnalysis(2,1:2) = 1;
    datastructure.Session5.DataAnalysis(isnan(datastructure.Session5.DataAnalysis)) = 0;
    x = x + 1;
    
    
%% -- Session 6 Start


    elseif i == 6
        datastructure = setfield(datastructure,'Session6','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session6','Events',[Event]);
        datastructure = setfield(datastructure,'Session6','Time',[Time]);
        datastructure = setfield(datastructure,'Session6','Trials',[Trial]);
        
                digitsTime = strlength(datastructure.Session6.Time(1,1));
        
        for i = 1:size(datastructure.Session6.Events)
        if strcmp(datastructure.Session6.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session6.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session6.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session6.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session6.Events(i),'End Trial')
            time = datastructure.Session6.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session6.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session6.Events{i};
        elseif strfind(datastructure.Session6.Events{i},'Go') == 1
            if strfind(datastructure.Session6.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session6.Events{i-2};
            else
                Data{id,5} = datastructure.Session6.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session6.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session6.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session6.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session6.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session6.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session6.Events{i},'No') == 1
            Data{id,5} = datastructure.Session6.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session6.Events{i},'In') == 1
            Data{id,5} = datastructure.Session6.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session6.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session6.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session6.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session6.Data = Data;
    datastructure.Session6.DataAnalysis = str2double(Data);
    datastructure.Session6.DataAnalysis(2,1:2) = 1;
    datastructure.Session6.DataAnalysis(isnan(datastructure.Session6.DataAnalysis)) = 0;
    x = x + 1;
    
%% -- Session 7 Start


    elseif i == 7
        datastructure = setfield(datastructure,'Session7','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session7','Events',[Event]);
        datastructure = setfield(datastructure,'Session7','Time',[Time]);
        datastructure = setfield(datastructure,'Session7','Trials',[Trial]);
        
                digitsTime = strlength(datastructure.Session7.Time(1,1));
        
        for i = 1:size(datastructure.Session7.Events)
        if strcmp(datastructure.Session7.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session7.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session7.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session7.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session7.Events(i),'End Trial')
            time = datastructure.Session7.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session7.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session7.Events{i};
        elseif strfind(datastructure.Session7.Events{i},'Go') == 1
            if strfind(datastructure.Session7.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session7.Events{i-2};
            else
                Data{id,5} = datastructure.Session7.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session7.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session7.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session7.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session7.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session7.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session7.Events{i},'No') == 1
            Data{id,5} = datastructure.Session7.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session7.Events{i},'In') == 1
            Data{id,5} = datastructure.Session7.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session7.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session7.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session7.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session7.Data = Data;
    datastructure.Session7.DataAnalysis = str2double(Data);
    datastructure.Session7.DataAnalysis(2,1:2) = 1;
    datastructure.Session7.DataAnalysis(isnan(datastructure.Session7.DataAnalysis)) = 0;
    x = x + 1;
    
%% -- Start Session 8   


    else i = 8;
        datastructure = setfield(datastructure,'Session8','Filename',[txtfiles(x).name(end-18:end)]);
        datastructure = setfield(datastructure,'Session8','Events',[Event]);
        datastructure = setfield(datastructure,'Session8','Time',[Time]);
        datastructure = setfield(datastructure,'Session8','Trials',[Trial]);
        
                digitsTime = strlength(datastructure.Session8.Time(1,1));
        
        for i = 1:size(datastructure.Session8.Events)
        if strcmp(datastructure.Session8.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Session8.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Session8.Events(i),'Begin Trial / Recording')
            item = {num2str(id) num2str(datastructure.Session8.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
            Data = [Data; item];
            id = id + 1;
        elseif strcmp(datastructure.Session8.Events(i),'End Trial')
            time = datastructure.Session8.Time{i};
            time = char(time);
            time = time(1:8);
            Data{id,3} = time;
        elseif strfind(datastructure.Session8.Events{i},'Te') == 1
            Data{id,4} = datastructure.Session8.Events{i};
        elseif strfind(datastructure.Session8.Events{i},'Go') == 1
            if strfind(datastructure.Session8.Events{i-2},'Auto Reward') == 1
            Data{id,12} = '1';
            Data{id,5} = datastructure.Session8.Events{i-2};
            else
                Data{id,5} = datastructure.Session8.Events(i);
                Data{id,7} = '1';
                tGo = datastructure.Session8.Time{i,1};
                tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
                for j = i-4:i
                    if strfind(datastructure.Session8.Events{j},'Stimulus') == 1
                        tStim = datastructure.Session8.Time{j,1};
                        break
                    end
                end
                tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
                GoTime = tGo-tStim;
                if GoTime < 0
                    tStim = 60 - tStim;
                    GoTime = tGo + tStim;
                end
                Data{id,6} = num2str(GoTime);
            end
        elseif strfind(datastructure.Session8.Events{i},'Re') == 4
            Data{id,5} = datastructure.Session8.Events{i};
            Data{id,9} = '1';
        elseif strfind(datastructure.Session8.Events{i},'No') == 1
            Data{id,5} = datastructure.Session8.Events{i};
            Data{id,8} = '1';
        elseif strfind(datastructure.Session8.Events{i},'In') == 1
            Data{id,5} = datastructure.Session8.Events{i};
            Data{id,10} = '1';
            tFA = datastructure.Session8.Time{i,1};
            tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
            for j = i-3:i
                if strfind(datastructure.Session8.Events{j},'Stimulus') == 1
                    tStim = datastructure.Session8.Time{j,1};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
            FAtime = tFA - tStim;
            if FAtime < 0
                tStim = 60 - tStim;
                FAtime = tFA + tStim;
            end
            Data{id,11} = num2str(FAtime);
        end
    end
    
    datastructure.Session8.Data = Data;
    datastructure.Session8.DataAnalysis = str2double(Data);
    datastructure.Session8.DataAnalysis(2,1:2) = 1;
    datastructure.Session8.DataAnalysis(isnan(datastructure.Session8.DataAnalysis)) = 0;
      
    end
end

save('Multi_Behavior_Sort.mat','datastructure');