package signals;

import signals.Signal.BaseSignal;

@:expose("Signal3")
class Signal3<T, K, I> extends BaseSignal<T->K->I->Void> {
	public var value1:T;
	public var value2:K;
	public var value3:I;

	public function dispatch(value1:T, value2:K, value3:I) {
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		this.value3 = value3;
		dispatchCallbacks();
		value1 = null;
		value2 = null;
		value3 = null;
	}

	override function dispatchCallback(callback:Void->Void) {
		callback();
	}

	override function dispatchCallback1(callback:T->Void) {
		callback(value1);
	}

	override function dispatchCallback2(callback:T->K->Void) {
		callback(value1, value2);
	}

	override function dispatchCallback3(callback:T->K->I->Void) {
		callback(value1, value2, value3);
	}
}
