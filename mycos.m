function y = mycos(f0,phi, Ns, fs )
%MYCOS My cosine function
%   MYCOS(F0, phi, Ns,FS) returns a cosinus where F0 is the frequency en Hz,
%   Ns is the total number of samples, phi the phase and FS is the sample rate in Hz


Ts=1/fs;
nTs= 0:1:Ns-1;
nTs = Ts*nTs;
w0=2*pi*f0;
y=cos(w0.*nTs+phi);

end

