import bind;
import funs;
import std.stdio;

/* This will fail if not on Windows */
version(Windows) {
	mixin(makeBindings!("this", "funs")());
}

void main() {
	/* Prints out the generated bindings so you can see them on any OS. */
	string v = makeBindings!("this", "funs")();
	writeln(v);
}
