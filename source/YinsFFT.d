import FFTUtilities;


final class YinsFFT
{
	import std.stdio : writeln;
	import std.algorithm : reduce, map, topNIndex;
	import std.array : array;
	import std.range.primitives : isRandomAccessRange;

public:

	this ( size_t sampleRate, double thresHold, bool isDebugOpen, int maxFrequency )
	{
		m_sampleRate = sampleRate;
		m_thresHold = thresHold;
		m_isDebugOpen = isDebugOpen;
		m_maxFrequency = maxFrequency;
	}
	
	double differenceFunction(R)(R range, int timeIndex)
				if (isRandomAccessRange!R) 
	{
		auto halfRange = range[0..$/2];
		auto constant = halfRange.map!(a => a * a).reduce!((a,b) => a+b)();
		auto delayedConstant = constant;
		auto halfCorrelation = autoCorrelation(range)[0..$/2].array();
	
		for( int index = 0; index < halfRange.length; index++)
		{
			halfCorrelation[index] = (constant + delayedConstant) - halfCorrelation[index];
			delayedConstant -=  range[index] * range[index];
			delayedConstant +=  range[index + $/2] * range[index + $/2]; 
		}
		
		double sumCur = 0;
		halfCorrelation[0] = 1;
		foreach(index, ref elem; halfCorrelation[1..$])
		{
			sumCur += elem ;
			auto dividor = sumCur / (index + 1);
			elem /= dividor;
	
		}
	
		return getPitch(halfCorrelation, timeIndex);
	}
	
	
private:
	double getPitch(R)
				   (R range, int timeIndex = -1)
	{
		size_t indexResult = 0;
		int[] topIndex = new int[1];
		auto minRange = m_sampleRate / m_maxFrequency; 
		foreach ( index, elem ; range )
		{
			if ( elem < m_thresHold )
			{
				if (index + minRange > range.length)
					topNIndex( range[index..$], topIndex );
				else
					topNIndex(range[index..index+minRange], topIndex);
				topIndex[0] += index;		
				break;
			} 
		}
		
		if ( !topIndex[0] )
			topNIndex( range, topIndex );
		
		auto finalResult = 44100.0  / topIndex[0];
		
		if (m_isDebugOpen)
		{
			auto curTimeIndex = range.length / 44100.0 * timeIndex;
			if (finalResult < 0 || finalResult > m_maxFrequency)
				writeln( curTimeIndex, " : --" );
			else
				writeln( curTimeIndex, " : ", finalResult );
		}
			
		return 	finalResult;
	}
	
	double m_thresHold = 0.1;
	size_t m_sampleRate = 44100;
	bool   m_isDebugOpen = false;
	int    m_maxFrequency = 500;
}


