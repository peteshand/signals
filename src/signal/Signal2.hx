package signal;

/*
 * Due to incompatibilities with the CPP Mac target the 
 * "signal" package has been deprecated in favour of "signals",
 * 
 * Warning: The "signal" package will be removed in a future release, it is recommended 
 * to switch to the "signals" package to avoid future incompatibility issues.
*/

import signals.Signal2 as Signal2_;

typedef Signal2<T, K> = Signal2_<T, K>;

/*
 * It would be nice to be able to use an abstract with a warning, 
 * however seeing as you can't extend abstract this isn't feasible
*/
/*
@:forward
abstract Signal2<T, K>(Signal2_<T, K>) from Signal2_<T, K> to Signal2_<T, K>
{
	public inline function new(value:Signal2_<T, K>)
	{
		trace('Warning: The "signal" package will be removed in a future release,\nPlease which to the "signals" package to avoid incompatibility issues.');
		this = value;
	}
}
*/