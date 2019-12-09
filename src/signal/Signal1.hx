package signal;

/*
 * Due to incompatibilities with the CPP Mac target the
 * "signal" package has been deprecated in favour of "signals",
 *
 * Warning: The "signal" package will be removed in a future release, it is recommended
 * to switch to the "signals" package to avoid future incompatibility issues.
 */
import signals.Signal1 as Signal1_;

@:deprecated typedef Signal1<T> = Signal1_<T>;
