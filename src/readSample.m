function sample = readSample(sampleNumber, sampleType = "")
	persistent sampleFolder = "../samples/";
	persistent sampleName = "sample";
	persistent sampleFormat = ".wav";
	sampleNumber = num2str(sampleNumber);

	samplePath = [sampleFolder sampleName sampleNumber sampleType sampleFormat];

	sample = wavread(samplePath);
end
