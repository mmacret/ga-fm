function y = FMSynth( fc, fm, A,I, Ns, fs )
%FMSynth FM synthesis function
%   FMSynth generates a waveform using the general equation of the FM synthesis method.
%   
%y = FMSynth( fc, fm, A,I, Ns, fs )
% -fc is the carrier frequency, 
% -fm is the modulation frequency, 
% -I is the modulation index (vector), 
% -A is the time varying amplitude (vector).
% -Ns is the number of samples and fs the sampling frequency.


y= A.*mycos(fc,I.*mycos(fm,0,Ns,fs),Ns,fs);


end

