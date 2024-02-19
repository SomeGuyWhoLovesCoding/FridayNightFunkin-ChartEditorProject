package;

class ArrayBuffer<T> {
    private var buffers(default, null):Array<haxe.ds.Vector<T>>;
    private var curBuffer(default, null):Int;

    public function new() {
        buffers = [];
        curBuffer = 0;
        buffers.push(new haxe.ds.Vector<T>());
    }

    public function push(v:T):Int {
        if (buffers[curBuffer].length >= 100) { // Example threshold for buffer size
            curBuffer++;
            buffers.push(new haxe.ds.Vector<T>());
        }
        return buffers[curBuffer].push(v);
    }
}