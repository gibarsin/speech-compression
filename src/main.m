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
