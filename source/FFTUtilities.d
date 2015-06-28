import std.range.primitives;

bool isPowerOfTwo(size_t num)
{
    import core.bitop : bsf, bsr;
    return bsr(num) == bsf(num);
}

size_t roundUpToPowerOf2(size_t num)
{
    import core.bitop : bsr;
    if (isPowerOfTwo(num))
    	return num;
    return (2 << bsr(num));
}

size_t residualPowerOf2(size_t num)
{
	return roundUpToPowerOf2(num) - num;
}



auto autoCorrelation(R)(R range)
        if (isRandomAccessRange!R)
{

	import std.numeric : fft, inverseFft;
	import std.range : chain, repeat, zip, dropBack;
	import std.algorithm : map;
	import std.complex;
	
	auto residual = residualPowerOf2(range.length);
	auto fftResult = range.chain(repeat(0, residual)).fft();
	auto autoCorrResult = fftResult.zip(fftResult.map!(a => a.conj())).
							map!( a=> a[0] * a[1] ).
							inverseFft().
							dropBack(residual).
							map!( a => a.re ); 
				
	return autoCorrResult;
}	