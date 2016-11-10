% sample is the file to compress
% epsilon is the upper bound from which the numbers below will be truncated to zero
% L is the number of bits used in the 'quantization process'
function recoveredFile = compress(sample, epsilon, L)
	% Transform methods
	coefficients = fft(sample); % Return FFT coefficients, function is from Octave

	% Save only half + 1 coefficients, the rest can be discarded
	% because they are repeated.
	N = length(coefficients);
	coefficients = coefficients(1:floor(N/2) + 1);

	% Threshold values below epsilon
	coefficients = threshold(coefficients, epsilon);

	% Quantization of real and complex parts
	realPartCoefficients = real(coefficients);
	imaginaryPartCoefficients = imag(coefficients);
	realQuantizationTable = quantize(realPartCoefficients, L);
	imaginaryQuantizationTable = quantize(imaginaryPartCoefficients, L);

	quantizationTable = [realQuantizationTable imaginaryQuantizationTable];

	% Huffman encoding size approximate size
	compressedSize = huffmanEncoding(quantizationTable, L)/8;

	% Recover file from the quantified values
	expandedCoefficients = addMissingFrequences(realQuantizationTable + imaginaryQuantizationTable*j);
	recoveredFile = ifft(expandedCoefficients);
end

function coefficients = threshold(coefficients, epsilon)
	for i = 1:length(coefficients)
		if abs(coefficients(i)) < epsilon % Complex value module
			coefficients(i) = 0;
		end
	end
end

% quantizationTable are the real and imaginary parts of the quantized coefficients
function quantizationTable = quantize(coefficients, L)
	% Get the (min max) bounds of the coefficients
	minFrequency = min(coefficients);
	maxFrequency = max(coefficients);

	% Get the step to build the quantization table
	step = calculateStep(minFrequency, maxFrequency, L);
	quantizationIndex =  floor((coefficients - minFrequency) / step);
	quantizationTable = quantizationIndex * step + step/2 + minFrequency;
end

function compressedSize = huffmanEncoding(coefficients, L)
	uniqueCoefficients = unique(coefficients);

	% Calculate the coefficients relative frequency of occurrence in the sample
	coefficientsFrequency = hist(coefficients, uniqueCoefficients);
	totalFrequency = sum(coefficientsFrequency);
	coeffRelativeFrequency = coefficientsFrequency./totalFrequency;

	sampleDictionary = huffmandict(coefficients, coeffRelativeFrequency);

	% Calculate the size of the compressed file (we don't need the file to
	% determine its size)
	compressedSize = calculateCompressedSize(uniqueCoefficients, coefficientsFrequency, sampleDictionary, L);
end

function compressedSize = calculateCompressedSize(uniqueCoefficients, coefficientsFrequency, sampleDictionary, L)
	coefficientsNumber = length(uniqueCoefficients);
	compressedSize = L * coefficientsNumber;

	for i=1:coefficientsNumber
		compressedSize += length(sampleDictionary{i});
	end

	compressedSize += 2 * 64;

	compressedSize += 32;

	compressedSize += 8;

	for i=1:coefficientsNumber
		compressedSize += coefficientsFrequency(i) * length(sampleDictionary{i});
	end
end

function coefficients = addMissingFrequences(coefficients)
    n = length(coefficients);
    n = 2 * (n-1);
    for i = 1:(n/2)
        coefficients(n - i) = conj(coefficients(i));
    end
end

% Calculate the step in the Quantization process
% The bounds are assumed to be recieved in the order: min and max
function step = calculateStep(minFrequency, maxFrequency, L)
	step = (maxFrequency - minFrequency)/L;
end
