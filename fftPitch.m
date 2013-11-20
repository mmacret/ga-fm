function [ harmonicsFreq,harmonicsValues ] = fftPitch(x,bandwith,thresholdCoeff,fs)
%fftPitch Extract the frequency and energy values of the harmonics
%
%[ harmonicsFreq,harmonicsValues ] = fftPitch(x,bandwith,thresholdCoeff,fs)
%   -x is a the vector containing the signal to be analyzed.
%   -fs is the sampling frequency.
%   -thresholdCoeff is the coefficient used to compute the detection threshold for the harmonics.
%   -harmonicsFreq is a vector containing all the harmonics frequencies.
%   -harmonicsValues is a vector containing all the harmonics energy values.


xpad= [x,zeros(1,1*length(x))];
N= length(xpad);
fk= fs/N;
S= abs(fft(xpad));
S= S(1:length(S)/2);


maxValue = max(S);
meanValue = mean(S);

threshold = maxValue / thresholdCoeff;
%threshold = meanValue;


harmonicsId = find(S > threshold);

%Find a more intelligent way to do that
m= 1;
while m*fk < bandwith
m= m+1;
end
m;
tolerance = round(m /2);
%tolerance = 50;


harmonicsValues = [];
harmonicsFreq = [];
j=1;
while j ~= (length(harmonicsId)-1)
    i=j;
    
    samples = [(harmonicsId(i)):(harmonicsId(i)+tolerance)];
    test = (harmonicsId(i+1) == samples);
    result = find(test == 1);
   
    while length(result) ~= 0 && i ~= (length(harmonicsId)-2)
       i = i+1;
       samples = [(harmonicsId(i)):(harmonicsId(i)+tolerance)];
       test = (harmonicsId(i+1) == samples);
       result = find(test == 1);
    end

harmonicsValues = [harmonicsValues, max(S(harmonicsId(j:i)))];

maxid = find( S == max(S(harmonicsId(j:i))));
harmonicsFreq = [harmonicsFreq,maxid(1) * fk];
i=i+1;
j=i;
end




end

