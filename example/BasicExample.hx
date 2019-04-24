import signal.Signal;

class BasicExample
{
    static function main()
    {
        var signal = new Signal();
        signal.add(() -> trace('hello world!'));
        signal.dispatch();
    }
}