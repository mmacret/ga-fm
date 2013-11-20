function [A] = extractSpecHarm(X,f0,nbHarm,Nwind,bw,fs)
%EXTRACSPECHARM extracts the nbHarm harmonics of the signal X
%
%[A] = extractSpecHarm(X,f0,nbHarm,Nwind,bw,fs)
% -f0 is the fundamental frequency,
% -nbHarm is the number of harmonic to extract,
% -Nwind is the number of samples per windows for the spectrogram function.
% -bw is the size of the windows to use to extract the harmonics
% -fs is the sampling frequency.

[S,F,T,P] = spectrogram(X,Nwind,Nwind/2,4*Nwind,fs);

harmTab={};
A=[];
    for i=1:nbHarm
        selection = (F > (i*f0 - bw/2) & F < (i*f0 + bw/2));
        selectionId = find(selection);     

        Sharm = [];
        for k=1:length(T)
   
        Sharm = [Sharm,max(abs(S(selectionId,k)))];
        end
        A = [A;Sharm];
        
    end
   
end 
    



