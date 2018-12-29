# Overview

A simple and light weight event system replacement.

##Performance

![performance](readme/performance.jpg)


##API


The API is based off massiveinteractive's msignal and Robert Penner’s AS3 Signals, however is greatly simplified.

### Basic Signal

The following example demonstrates how to create a signal, add a listener and dispatch it.

```haxe
var signal = new Signal();
signal.add(() -> { /* do something */ });
signal.dispatch();
```

### Single Property Signal

```haxe
var signal = new Signal1<Int>();
signal.add((value:Int) -> { /* do something */ });
signal.dispatch(5);
```

### Double Property Signal

```haxe
var signal = new Signal2<Int, String>();
signal.add((value1:Int, value2:String) -> { /* do something */ });
signal.dispatch(5, "example");
```

### Add Once

```haxe
var signal = new Signal();
signal.add(() -> { trace('fire'); }, true);
signal.dispatch();
signal.dispatch();

// output 
'fire'
```

### Priority

```haxe
var signal = new Signal();
signal.add(() -> { trace('Priority 100'); }, 100);
signal.add(() -> { trace('Priority 500'); }, 500);
signal.dispatch();

// output 
'Priority 500'
'Priority 100'

```

### Add Once with Priority

```haxe
var signal = new Signal();
signal.add(() -> { /* do something */ }, true, 500);
signal.dispatch();
```

### Remove Listener

```haxe
var signal = new Signal();
signal.add(example);
signal.dispatch();
signal.remove(example);
signal.dispatch();

function example()
{
	trace('example');
}


// output 
'example'
```

### Remove All

To remove all listeners on a signal simple call the remove function with no argument

```haxe
var signal = new Signal();
signal.add(example);
signal.dispatch();
signal.remove();
signal.dispatch();

function example()
{
	trace('example');
}


// output 
'example'
```

