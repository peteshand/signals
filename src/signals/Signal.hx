/*
	Copyright 2018 P.J.Shand
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
	FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package signals;

import haxe.extern.EitherType;

/**
 *  The API is based off massiveinteractive's msignal and Robert Penner’s AS3 Signals, however is greatly simplified.
 */
@:expose("Signal")
class Signal extends BaseSignal<()->Void> {

	public function new(?fireOnAdd:Bool = false) {
		super(fireOnAdd);
	}

	public function dispatch() {
		sortPriority();
		dispatchCallbacks();
	}

	override function dispatchCallback(callback:()->Void) {
		callback();
	}

	override function dispatchCallback1(callback:(Dynamic)->Void) {
		throw "Use Signal 1";
	}

	override function dispatchCallback2(callback:(Dynamic, Dynamic)->Void) {
		throw "Use Signal 2";
	}

	override function dispatchCallback3(callback:(Dynamic, Dynamic, Dynamic)->Void) {
		throw "Use Signal 3";
	}
}

@:expose("BaseSignal")
class BaseSignal<Callback> {
	#if js
	@:noCompletion private static function __init__() {
		untyped Object.defineProperties(BaseSignal.prototype, {
			"numListeners": {
				get: untyped __js__("function () { return this.get_numListeners (); }"),
				set: untyped __js__("function (v) { return this.set_numListeners (v); }")
			},
			"hasListeners": {
				get: untyped __js__("function () { return this.get_hasListeners (); }"),
				set: untyped __js__("function (v) { return this.set_hasListeners (v); }")
			},
		});
	}
	#end

	public var numListeners(get, null):Int;
	public var hasListeners(get, null):Bool;

	public var _fireOnAdd:Bool = false;

	var currentCallback:SignalCallbackData;
	var callbacks:Array<SignalCallbackData> = [];
	var toTrigger:Array<SignalCallbackData> = [];
	var requiresSort:Bool = false;

	var valence:Int = 0;

	public function new(?fireOnAdd:Bool = false) {
		this._fireOnAdd = fireOnAdd;
	}

	inline function sortPriority() {
		if (requiresSort) {
			callbacks.sort(sortCallbacks);
			requiresSort = false;
		}
	}

	inline function dispatchCallbacks() {
		var i:Int = 0;
		while (i < callbacks.length) {
			var callbackData = callbacks[i];
			if (callbackData.repeat < 0 || callbackData.callCount <= callbackData.repeat) {
				toTrigger.push(callbackData);
			} else {
				callbackData.remove = true;
			}
			callbackData.callCount++;
			i++;
		}

		// remove single dispatchers
		var j:Int = callbacks.length - 1;
		while (j >= 0) {
			var callbackData = callbacks[j];
			if (callbackData.remove == true) {
				callbacks.splice(j, 1);
			}
			j--;
		}

		for (l in 0...toTrigger.length) {
			if (toTrigger[l] != null) {
				toTrigger[l].dispatchMethod(toTrigger[l].callback);
			}
		}
		toTrigger = [];
	}

	function dispatchCallback(callback:()->Void) {
		throw "implement in override";
	}

	function dispatchCallback1(callback:(Dynamic)->Void) {
		throw "implement in override";
	}

	function dispatchCallback2(callback:(Dynamic, Dynamic)->Void) {
		throw "implement in override";
	}

	function dispatchCallback3(callback:(Dynamic, Dynamic, Dynamic)->Void) {
		throw "implement in override";
	}

	function sortCallbacks(s1:SignalCallbackData, s2:SignalCallbackData):Int {
		if (s1.priority > s2.priority)
			return -1;
		else if (s1.priority < s2.priority)
			return 1;
		else
			return 0;
	}

	function get_numListeners() {
		return callbacks.length;
	}

	function get_hasListeners() {
		return numListeners > 0;
	}

	/**
	 * Use the .add method to register callbacks to be fired upon signal.dispatch
	 *
	 * @param callback A callback function which will be called when the signal's ditpatch method is fired.
	 * @param fireOnAdd An optional Bool that if set to true will immediately call the callback. The default value is false.
	 * @param repeat An optional Int that defines the number of times the callback should be triggered before removing itself. Default value = -1 which means it will not remove itself.
	 * @param priority An optional Int that specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function add(callback:Callback, ?fireOnce:Bool = false, ?priority:Int = 0, ?fireOnAdd:Null<Bool> = null):BaseSignal<Callback> {
		if (fireOnce != false || priority != 0 || fireOnAdd != null) {
			var warningMessage:String = "\nWARNING: fireOnce, priority and fireOnAdd params will be removed from 'Signals' in a future release\nInstead use daisy chain methods, eg: obj.add(callback).repeat(5).priority(1000).fireOnAdd();";
			#if js
			untyped __js__('console.warn(warningMessage)');
			#else
			trace(warningMessage);
			#end
		}

		var numParams:Int = getNumParams(callback);
		var repeat:Int = -1;
		if (fireOnce == true)
			repeat = 0;
		currentCallback = {
			params: numParams,
			callback: callback,
			callCount: 0,
			repeat: repeat,
			priority: priority,
			remove: false
		}
		if (numParams == 0) {
			currentCallback.dispatchMethod = dispatchCallback;
		} else if (numParams == 1) {
			currentCallback.dispatchMethod = dispatchCallback1;
		} else if (numParams == 2) {
			currentCallback.dispatchMethod = dispatchCallback2;
		} else if(numParams == 3){
			currentCallback.dispatchMethod = dispatchCallback3;
		}

		callbacks.push(currentCallback);

		if (priority != 0)
			requiresSort = true;

		if (fireOnAdd == true || this._fireOnAdd == true) {
			currentCallback.dispatchMethod(callback);
		}

		return this;
	}

	function getNumParams(callback:Callback):Int {
		#if(!static)
		var length:Null<Int> = Reflect.getProperty(callback, 'length');
		if (length != null) {
			return length;
		}
		#end
		return this.valence;
	}

	/**
	 * Use the .priority method to specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @param value An optional Int that specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function priority(value:Int):BaseSignal<Callback> {
		if (currentCallback == null)
			return this;
		currentCallback.priority = value;
		// priorityUsed = true;
		requiresSort = true;
		return this;
	}

	/**
	 * Use the .repeat method to define the number of times the callback should be triggered before removing itself. Default value = -1 which means it will not remove itself.
	 *
	 * @param value An Int that specifies the number of repeats before automatically removing itself.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function repeat(value:Int = -1):BaseSignal<Callback> {
		if (currentCallback == null)
			return this;
		currentCallback.repeat = value;
		return this;
	}

	/**
	 * Use the .fireOnAdd method that if called will immediately call the most recently added callback.
	 *
	 * @return Void
	 */
	public function fireOnAdd():Void {
		if (currentCallback == null)
			return;
		currentCallback.callCount++;
		currentCallback.dispatchMethod(currentCallback.callback);
	}

	public function remove(callback:EitherType<Bool, Callback> = false):Void {
		if (callback == true) {
			callbacks = [];
		} else {
			var j:Int = 0;
			while (j < callbacks.length) {
				if (callbacks[j].callback == callback) {
					callbacks.splice(j, 1);
				} else {
					j++;
				}
			}
		}
	}
}

typedef SignalCallbackData = {
	callback:Dynamic,
	callCount:Int,
	params:Int,
	repeat:Int,
	priority:Int,
	remove:Bool,
	?dispatchMethod:(Dynamic)->Void
}

typedef Signal0 = Signal
