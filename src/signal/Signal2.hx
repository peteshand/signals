package signal;

/*
 * Due to incompatibilities with the CPP Mac target the
 * "signal" package has been deprecated in favour of "signals",
 *
 * Warning: The "signal" package will be removed in a future release, it is recommended
 * to switch to the "signals" package to avoid future incompatibility issues.
 */
import signals.Signal2 as Signal2_;

@:deprecated typedef Signal2<T, K> = Signal2_<T, K>;
