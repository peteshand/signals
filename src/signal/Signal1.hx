package signal;

/*
 * Due to incompatibilities with the CPP Mac target the 
 * "signal" package has been deprecated in favour of "signals",
 * 
 * Warning: The "signal" package will be removed in a future release, it is recommended 
 * to switch to the "signals" package to avoid future incompatibility issues.
*/

import signals.Signal1 as Signal1_;

typedef Signal1<T> = Signal1_<T>;

/*
 * It would be nice to be able to use an abstract with a warning, 
 * however seeing as you can't extend abstract this isn't feasible
*/
/*
@:forward
abstract Signal1<T>(Signal1_<T>) from Signal1_<T> to Signal1_<T>
{
	public inline function new(value:Signal1_<T>)
	{
		trace('Warning: The "signal" package will be removed in a future release,\nPlease which to the "signals" package to avoid incompatibility issues.');
		this = value;
	}
}
*/