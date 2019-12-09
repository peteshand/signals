package signals;

import signals.Signal.BaseSignal;

@:expose("Signal1")
#if (haxe_ver >= 4.0)
class Signal1<T> extends BaseSignal<(T) -> Void>
#else
class Signal1<T> extends BaseSignal<T->Void>
#end
{
	public var value:T;

	public function dispatch(value1:T) {
		sortPriority();
		this.value = value1;
		dispatchCallbacks();
		value = null;
	}

	override function dispatchCallback(callback:(T) -> Void) {
		callback(value);
	}
}
