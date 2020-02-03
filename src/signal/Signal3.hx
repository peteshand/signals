package signal;

/*
 * Due to incompatibilities with the CPP Mac target the
 * "signal" package has been deprecated in favour of "signals",
 *
 * Warning: The "signal" package will be removed in a future release, it is recommended
 * to switch to the "signals" package to avoid future incompatibility issues.
 */
import signals.Signal3 as Signal3_;

@:deprecated typedef Signal3<T, K, I> = Signal3_<T, K, I>;
