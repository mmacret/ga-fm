function subExperiments = GAClassicFM(targetWav,fs,nbCarriers,nbHarm,Bw,Ns,idExp,idSubExp)
%GAClassicFM Classic FM model optimization using Genetic Algorithm
%   GAClassicFM generates a waveform using the general equation of the FM
%   synthesis method.
%
%subExperiments = GAClassicFM(targetWav,fs,nbCarriers,nbHarm,Bw,Ns,idExp,idSubExp)
% -targetWav is a string containing the name of the target sound (this sound
%  should be in the 'sounds' folder),
% -nbCarriers is the number of carriers to use,
% -nbHarm is the number of harmonics to take into account.
% -Bw is the size of the windows to use to extract the harmonics
% -Ns is the number of samples per windows for the spectrogram function.
% -idExp is the id for the experiment
% -idSubExp is the id for the subexperiment
% -subExperiments is a structure containing stats about the evolution and
%  also the result and target signals and harmonics list. 

    subExperiments = {};
         
            %Bounds
            LB = [];
            UB = [];
            intConst = [];

            %Target Parameter generation
            subExperiments.target = targetWav;

            index = 1;
            for l= 1: 2*nbCarriers
                if mod(l,2) == 0
                    %subExperiments.targetSynth(l) = unifrnd(0,20);
                    LB(l) = 0;
                    UB(l) =20;
                else
                    %subExperiments.targetSynth(l) = randi([0,10]);
                    LB(l) = 0;
                    UB(l) = 10;

                    intConst(index) = l;
                    index = index+1;
                end 
            end
            cd sounds;
           
            target = wavread(targetWav);
            target = target(:,1)';
            
            cd ..;

            %gfm generation
            peaks = fftPitch(target,400,40,44100);

            if ((peaks(1) < 1) && (length(peaks) > 1))
            fm = peaks(2);
            else
                fm = peaks(1);
            end

            subExperiments.fm = fm;


            %Normalization
            %target = target/max(target);

            nbSamples = length(target);

            %Extract target harmonics
            subExperiments.targetHarm = extractSpecHarm(target,fm,nbHarm,Ns,Bw,fs);
            targetHarm = subExperiments.targetHarm;

            %Compute best fitness

            subExperiments.bestFit = 0.05;

            %GA
            initRange = [LB;UB];

            options = gaoptimset('PopInitRange',initRange,'FitnessLimit',subExperiments.bestFit,'Generations',300,'Display','iter','PlotFcns',{@gaplotbestf},'PopulationSize',100,'TolFun',1E-8,'UseParallel','always','Vectorized','off'); 
            
            [subExperiments.resultSynth,subExperiments.fval,subExperiments.exitflag,subExperiments.output] = ga(@ClassicFMsimplefitness5_par,2*nbCarriers,[],[],[],[],LB,UB,[],intConst,options)

            function [result,output,W,harmCar] = ClassicFMsimplefitness5_par( params )
                %ClassicFMsimplefitness Compute the fitness of a individual
                %   Some global variable have to be declared and initialized:
                %   - gtarget is the shorttime spectrum of the target sound,
                %   - gfs is the sampling rate,
                %   - gNcarriers is the number of carriers,
                %   - gfm is the modulation frequency,
                %   - gZpad is the zero padding factor for the short time fourier transform,
                %   - gns is the number of samples per window.
                %
                %params is a vector of size 2*gNcarriers. Each couple is (multiplier for frequency 
                %modulation , modulation index).
                %
                %Outputs:
                %   - result is the fitness score,
                %   - output is the synthesized signal corresponding to the individual,
                %   - harmCar is the harmonics energy value of the carriers,
                %   - W is the weight matrix. 

              

                %Temporal carriers

                T=[];
                S={};

            

                for k=1:nbCarriers
                    T= [T ; FMSynth(params(2*k-1)*fm,fm,1,params(2*k),nbSamples,fs)];
                    [S{k},freq,time] = spectrogram(T(k,:),Ns,Ns/2,4*Ns,44100);%modifier
                end


                W=[];
                fitness=0;

                    %Harmonic extraction
                    harmCar = {}; 
                    for k=1:nbCarriers

                        A= [];
                        %Extracting harmonic energy
                        for h=1:nbHarm

                            selection = (freq > (h*fm - Bw/2) & freq < (h*fm + Bw/2));
                            selectionId = find(selection);

                            H= [];

                            for m=1:size(S{k},2)%number of windows

                            H = [H,max(abs(S{k}(selectionId,m)))];
                            end

                            A = [A;H];
                        end
                       harmCar{k} = A;
                    end

                    %Least-squares approximation
                    for f=1:size(targetHarm,2)

                        A= [];
                        for k=1:nbCarriers
                        A = [A,harmCar{k}(:,f)];
                        end
                    
                    LS = A\targetHarm(:,f);
                    
                    fitness = fitness + euclDist(A*LS,targetHarm(:,f));

                    W= [W,LS];
                    end

                    %Sound reconstruction
                    Wsamples = [];

                        for k=1:size(targetHarm,2)
                        if (k==1)
                            Wsamples=[Wsamples,W(:,1)*ones(1,Ns/2)];

                            else
                                Wtemp = [];
                                for i=1:nbCarriers
                                Wtemp=[Wtemp;mean(W(i,k-1:k))];%because of overlapping
                                end
                                Wsamples=[Wsamples,Wtemp*ones(1,Ns/2)];
                        end
                        end

                %Size check        
                diffsize = length(T)-length(Wsamples);

                if(diffsize > 0)
                    Wsamples= [Wsamples,zeros(nbCarriers,diffsize)];
                else T = [T,zeros(nbCarriers,diffsize)];
                end

                %Smoothing

                [b,a]=butter(4,0.001);
                for i=1:nbCarriers
                   Wsamples(i,:) = filtfilt(b,a,Wsamples(i,:));
                end



                output= ones(1,nbCarriers) *( T.*Wsamples);%Signal formation
                %output= output/max(output);

                result = fitness;
                W = Wsamples;

                for i=1:size(W,1)
                W(i,:) = W(i,:)/max(W(i,:));
                end



                end
            
            
            [subExperiments.fitResult,resultSound,subExperiments.resultEnv,harmCar] = ClassicFMsimplefitness5_par( subExperiments.resultSynth );

            %Extraction result Harmonics
            subExperiments.resultHarm = extractSpecHarm(resultSound,fm,nbHarm,Ns,Bw,fs);

            %Storage and wav writing
            fileName = strcat('resultExp',int2str(idExp),'Sub',int2str(idSubExp));
            wavwrite(resultSound,44100,32,fileName);

            %Store figure
            fileName = strcat('gaExp',int2str(idExp),'Sub',int2str(idSubExp),'.fig');
            saveas(gcf,fileName);




end
