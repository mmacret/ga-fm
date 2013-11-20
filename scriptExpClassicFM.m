%All the sounds have to be in the 'sounds' folder
%Run 3 set of experiments of 3 subexperiments for each sounds of the folder.

close all;
%Storage
experiments = {};

%System setting
gfs= 44100;

%Analysis parameters
gNs=500;
gNharm= 18;
gBw= 200;

cd sounds;
filesList = dir;
soundsList = filesList(find(~cellfun(@isdir,{filesList.name})));
soundsList = {soundsList.name};
soundsList = soundsList(find(~strcmp(soundsList,'.DS_Store')));
cd ..;


for i= 1:1:length(soundsList)
    
    targetWav = char(soundsList(i))
    subExperiments = {};
    
    if(~strcmp(targetWav , '.DS_Store')) 
        
        for k = 1:3 %Experiment set
    
            switch k
                case 1
                    gNcarriers = 2;
                case 2
                    gNcarriers = 4;
                case 3
                    gNcarriers = 6;
            end;
                
            subExperiments{k} = GAClassicFM(targetWav,gfs,gNcarriers,gNharm,gBw,gNs,i,k);    

            end
            experiments{i} = subExperiments;%End subExperiment


        
    end

end
