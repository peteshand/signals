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

@:deprecated typedef Signal = Signal_;
@:deprecated typedef Signal0 = Signal_;
@:deprecated typedef BaseSignal<Callback> = BaseSignal_<Callback>;
