% epsilon is the upper bound from which the numbers below will be truncated to zero
% L is the number of bits used in the 'quantization process'
%	totalSamples is the number of samples to compress
function main(epsilon, L, totalSamples)
	for i = 1:totalSamples
		sample = readSample(i);
		recoveredFile = compress(sample, epsilon, L);
		writeSample = writeSample(recoveredFile, "_recovered", i);
	end
end

% varia l
%function rmse=main(epsilon)
%
%  rmse=zeros(1,8);
%
%	for i = 1:8
%		sample = readSample(1);
%		recoveredFile = compress(sample, epsilon, i);
%    
%    realPart = real(recoveredFile);
%		%writeSample = writeSample(realPart, "_recovered", 1);
%    
%    n=min(length(realPart),length(sample));
%    realPart=realPart(1:n);
%    sample=sample(1:n);
%    
%    rmse(i) = sqrt(mean((realPart - sample).^2));
%	end
%end

% varia epsilon
%function rmse=main()
%
%  rmse=zeros(1,10);
%  r=1;
%
%	for i = 0.1:0.1:1
%		sample = readSample(2);
%		recoveredFile = compress(sample, i, 4);
%    
%    realPart = real(recoveredFile);
%		%writeSample = writeSample(realPart, "_recovered", 1);
%    
%    n=min(length(realPart),length(sample));
%    realPart=realPart(1:n);
%    sample=sample(1:n);
%    
%    rmse(r) = sqrt(mean((realPart - sample).^2));
%    r=r+1;
%	end
%end
