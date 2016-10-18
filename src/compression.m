% sample is the file to compress
% epsilon is the upper bound from which the numbers below will be truncated to zero
% L is the number of bits used in the 'cuantification process'
function compress(sample, epsilon, L)
	% Transform methods
	coefficients = fft(sample); % Return FFT coefficients, function is from Octave

	% Save only half + 1 coefficients, the rest can be discarded
	% because they are repeated.
	% uniqueCoefficients = unique(coefficients); % octave's fft returns unique values

	% Threshold and quantization
	uniqueCoefficients = threshold(coefficients, epsilon);
	quantizationTable = quantize(uniqueCoefficients, L);

	% Huffman encoding
	compressedSize = huffmanEncoding(coefficients, uniqueCoefficients, quantizationTable, L)
end

function coefficients = threshold(coefficients, epsilon)
	for i = 1:length(coefficients)
		if abs(coefficients(i)) < epsilon % Complex value module
			coefficients(i) = 0;
		end
	end
end

% coefficientsTable are the real and imaginary parts of the coefficients divided in two columns respectively
% quantizationTable are the real and imaginary parts of the quantized coefficients
function [coefficientsTable quantizationTable] = quantize(coefficients, L)
	% Coefficients in their real part and complex part
	% so the minimum and maximum values can be calculated
	realPartCoefficients = real(coefficients);
	imaginaryPartCoefficients = imag(coefficients);

	% Get the (min max) bounds of the real and imaginary parts
	% of the coefficients
	realBounds = [min(realPartCoefficients) max(realPartCoefficients)];
	imaginaryBounds = [min(imaginaryPartCoefficients) max(imaginaryPartCoefficients)];

	% Get the steps to build the quantization table
	realStep = calculateStep(realBounds, L);
	imaginaryStep = calculateStep(imaginaryBounds, L);

	realQuantizationTable = [realBounds(1):realStep:realBounds(2)];
	imaginaryQuantizationTable = [realBounds(1):imaginaryStep:realBounds(2)];

	coefficientsTable = [realPartCoefficients imaginaryPartCoefficients];
	quantizationTable = [realQuantizationTable imaginaryQuantizationTable];
end

function compressedSize = huffmanEncoding(coefficients, uniqueCoefficients, quantizationTable, L)
	uniqueCoefficients = unique(quantizationTable);

	% Calculate the coefficients probability of occurrence in the sample
	coefficientsFrequency = hist(quantizationTable, uniqueCoefficients);
	totalFrequency = sum(coefficientsFrequency);
	coefficientsProbability = coefficientsFrequency/totalFrequency

	sampleDictionary = huffmandict(quantizationTable, coefficientsProbability);

	% Calculate the size of the compressed file (we don't need the file to
	% determine its size)
	compressedSize = calculateCompressedSize(uniqueCoefficients, coefficientsProbability, sampleDictionary, L);
end

function compressedSize = calculateCompressedSize(uniqueCoefficients, coefficientsProbability, sampleDictionary, L)
	coefficientsNumber = length(uniqueCoefficients);
	compressedSize = L * coefficientsNumber;

	for i=1:coefficientsNumber
		compressedSize += length(sampleDictionary{i});
	end

	compressedSize += 2 * 64;

	compressedSize += 32;

	compressedSize += 8;

	for i=1:coefficientsNumber
		compressedSize += coefficientsProbability(i) * length(sampleDictionary{i});
	end
end



% Calculate the step in the Quantization process
% The bounds are assumed to be recieved in the order: min and max
function step = calculateStep(bounds, L)
	step = (bounds(2) - bounds(1))/L;
end
