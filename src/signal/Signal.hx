package signal;

/*
 * Due to incompatibilities with the CPP Mac target the 
 * "signal" package has been deprecated in favour of "signals",
 * 
 * Warning: The "signal" package will be removed in a future release, it is recommended 
 * to switch to the "signals" package to avoid future incompatibility issues.
*/

import signals.Signal as Signal_;
import signals.Signal.BaseSignal as BaseSignal_;
import signals.Signal.Signal0 as Signal0;

typedef Signal = Signal_;
typedef Signal0 = Signal_;
typedef BaseSignal<Callback> = BaseSignal_<Callback>;

/*
 * It would be nice to be able to use an abstract with a warning, 
 * however seeing as you can't extend abstract this isn't feasible
*/
/*
@:forward
abstract Signal(Signal_) from Signal_ to Signal_
{
	public inline function new(value:Signal_)
	{
		trace('Warning: The "signal" package will be removed in a future release,\nPlease which to the "signals" package to avoid incompatibility issues.');
		this = value;
	}
}
*/
