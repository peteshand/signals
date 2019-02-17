package signal;

import signal.Signal.BaseSignal;

class Signal2<T, K> extends BaseSignal<(T, K) -> Void>
{
	public var value1:T;
    public var value2:K;

	public function dispatch(value1:T, value2:K)
	{
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		dispatchCallbacks();
		value1 = null;
		value2 = null;
	}

	override function dispatchCallback(callback:(T, K) -> Void)
	{
		callback(value1, value2);
	}
}