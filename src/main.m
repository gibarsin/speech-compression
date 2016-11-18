% epsilon is the upper bound from which the numbers below will be truncated to zero
% L is the number of bits used in the 'quantization process'
%	totalSamples is the number of samples to compress

function main(epsilon, L, i)
 	sample = readSample(i);
	recoveredFile = compress(sample, epsilon, 2**L);
	writeSample = writeSample(recoveredFile, "_recovered", i);
end

%{
function rmse=main()

  rmse=zeros(2,8);
  b=1;

  [sample, filesize] = readSample(3);
  
	for a = 1:1:8
		[recoveredFile, compressedSize] = compress(sample, 0.1, 2**a);
    
    realPart = real(recoveredFile);
		%writeSample = writeSample(realPart, "_recovered", 1);
    
    n=min(length(realPart),length(sample));
    realPart=realPart(1:n);
    sample=sample(1:n);
    
    rmse(1,b) = sqrt(mean((realPart - sample).^2));
    rmse(2,b) = compressedSize/filesize;

    b=b+1
	end
end
}%

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
