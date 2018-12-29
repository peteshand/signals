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

	var callbacks:Array<SignalCallbackData> = [];
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
			dispatchCallback(callbackData.callback);
			if (callbackData.fireOnce == true){
				callbacks.splice(i, 1);
			} else {
				i++;
			}
		}
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

	public function add(callback:Callback, ?fireOnce:Bool=false, ?priority:Int = 0):Void
	{
		callbacks.push({
			callback:callback,
			callCount:0,
			fireOnce:fireOnce,
			priority:priority
		});
		if (priority != 0) priorityUsed = true;
		if (priorityUsed == true) requiresSort = true;
	}

	public function remove(callback:Callback=null):Void
	{
		if (callback == null){
			callbacks = [];
		} else {
			var i:Int = 0;
			while (i < callbacks.length) {
				if (callbacks[i].callback == callback){
					callbacks.splice(i, 1);
				} else {
					i++;
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
	priority:Int
}
