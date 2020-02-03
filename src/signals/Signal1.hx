package signals;

import haxe.extern.EitherType;
import signals.Signal.BaseSignal;

typedef Func0or1<T> = EitherType<()->Void, (T)->Void>;

@:expose("Signal1")
class Signal1<T> extends BaseSignal<Func0or1<T>> {
	public var value:T;

	override public function new(){
		super();
		this.valence = 1;
	}

	public function dispatch(value1:T) {
		sortPriority();
		this.value = value1;
		dispatchCallbacks();
		value = null;
	}

	override function dispatchCallback(callback:()->Void) {
		callback();
	}

	override function dispatchCallback1(callback:(Dynamic)->Void) {
		callback(value);
	}

	override function dispatchCallback2(callback:(Dynamic,Dynamic)->Void) {
		throw "Use Signal 2";
	}

	override function dispatchCallback3(callback:(Dynamic, Dynamic, Dynamic)->Void) {
		throw "Use Signal 3";
	}
}

// Void->Void // T->Void
