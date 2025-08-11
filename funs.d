/* Example module with C functions needing bindings. */
module funs;

extern(C) {
	int foo(int x, int y);
	double bar(double * s, double * y);
}
