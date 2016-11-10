function sample = writeSample(sample, sampleType, sampleNumber)
	persistent sampleFolder = "../samples/";
	persistent sampleName = "sample";
	persistent sampleFormat =  ".wav";
	sampleNumber = num2str(sampleNumber);

	samplePath = [sampleFolder sampleName sampleNumber sampleType sampleFormat];

	wavwrite(sample, samplePath);
end
