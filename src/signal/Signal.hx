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

package signal;

class Signal extends BaseSignal<Void -> Void>
{
	public function dispatch()
	{
		sortPriority();
		dispatchCallbacks();
	}

	override function dispatchCallback(callback:Void -> Void)
	{
		callback();
	}
}

class BaseSignal<Callback>
{
	public var numListeners(get, null):Int;
	public var fireOnAdd:Bool = false;
	var callbacks:Array<SignalCallbackData> = [];
	var toTrigger:Array<Callback> = [];
	var requiresSort:Bool = false;
	var priorityUsed:Bool = false;
	
	public function new()
	{

	}

	inline function sortPriority()
	{
		if (requiresSort){
			callbacks.sort(sortCallbacks);
			requiresSort = false;
		}
	}

	inline function dispatchCallbacks()
	{
		var i:Int = 0;
		while (i < callbacks.length) {
			var callbackData = callbacks[i];
			callbackData.callCount++;
			//dispatchCallback(callbackData.callback);
			toTrigger.push(callbackData.callback);
			if (callbackData.fireOnce == true) callbackData.remove = true;
			i++;
		}

		// remove single dispatchers
		var j:Int = callbacks.length - 1;
		while (j >= 0) {
			var callbackData = callbacks[j];
			if (callbackData.remove == true){
				callbacks.splice(j, 1);
			}
			j--;
		}

		for (i in 0...toTrigger.length){
			if (toTrigger[i] != null) dispatchCallback(toTrigger[i]);
		}
		toTrigger = [];
	}

	function dispatchCallback(callback:Callback)
	{
		// implement in override
	}

	function sortCallbacks(s1:SignalCallbackData, s2:SignalCallbackData):Int
	{
		if (s1.priority > s2.priority) return -1;
		else if (s1.priority < s2.priority) return 1;
		else return 0;
	}

	function get_numListeners()
	{
		return callbacks.length;
	}

	public function add(callback:Callback, ?fireOnce:Bool=false, ?priority:Int = 0, ?fireOnAdd:Null<Bool> = null):Void
	{
		callbacks.push({
			callback:callback,
			callCount:0,
			fireOnce:fireOnce,
			priority:priority,
			remove:false
		});
		if (priority != 0) priorityUsed = true;
		if (priorityUsed == true) requiresSort = true;
		if (fireOnAdd == true || this.fireOnAdd == true) dispatchCallback(callback);
	}

	public function remove(callback:Callback=null):Void
	{
		if (callback == null){
			callbacks = [];
		} else {
			var j:Int = 0;
			while (j < callbacks.length) {
				if (callbacks[j].callback == callback){
					callbacks.splice(j, 1);
				} else {
					j++;
				}
			}
		}
		
	}
}

typedef SignalCallbackData =
{
	callback:Dynamic,
	callCount:Int,
	fireOnce:Bool,
	priority:Int,
	remove:Bool
}
