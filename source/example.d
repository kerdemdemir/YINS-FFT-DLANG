import std.stdio;
import YinsFFT;
import waved;

void openWav()
{
	Sound input = decodeWAV("C:/196971__margo-heston__i-see-five-lamps-f.wav");
	auto sampleRate = input.sampleRate;
	auto samplePerPacket = sampleRate * 20 / 1000;
	
	auto yinFft = new YinsFFT(input.sampleRate, 0.1, true, 500);
	auto chunkSize = input.data.length / samplePerPacket;
	for (int i = 0; i < chunkSize - 1; i++)
	{
		yinFft.differenceFunction(input.data[i*samplePerPacket..(i+2)*samplePerPacket], i);
	}
}  


  
void main(  string[] args )
{
	openWav();
}