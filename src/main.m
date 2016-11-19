% epsilon is the upper bound from which the numbers below will be truncated to zero
% L is the number of bits used in the 'quantization process'
%	totalSamples is the number of samples to compress


function [compressionRate, distorsion] = main(epsilon, L, i)
 	[sample, filesize] = readSample(i);
	[recoveredFile, compressedSize] = compress(sample, epsilon, L);
	writeSample = writeSample(recoveredFile, "_recovered", i);
	realPart = real(recoveredFile);
	n=min(length(realPart),length(sample));
    realPart=realPart(1:n);
    sample=sample(1:n);
    compressionRate = compressedSize/filesize;
	distorsion = sqrt(mean((realPart - sample).^2));
end

