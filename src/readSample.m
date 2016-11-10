function sample = readSample(sampleNumber, sampleType = "")
	persistent sampleFolder = "../samples/";
	persistent sampleName = ["sample" sampleType];
	persistent sampleFormat = ".wav";
	sampleNumber = num2str(sampleNumber);

	samplePath = [sampleFolder sampleName sampleNumber sampleFormat];

	sample = wavread(samplePath);
end
