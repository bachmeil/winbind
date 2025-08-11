module winbind.bind;

import std.conv, std.traits;

/* dllname: The name of the DLL, without the extension.
 * modname: The name of the module you want to bind.
 * Binds all functions in the module. */
string makeBindings(string dllname, string modname)() {
	mixin(i"import $(modname);".text);
	string global = "extern(C) {\n";
	string fun = i"void load_$(modname)(bool errors=false) {
  import std.process, std.stdio, std.utf;
  import core.sys.windows.windows;
  import std.windows.syserror;

  // Error 126 means *something* can't be found, including a dependency.
  HMODULE mod$(dllname) = LoadLibraryW(toUTF16z(`$(dllname).dll`));
  if (errors) {
    writeln(sysErrorString(GetLastError()));
  }
".text;

	foreach(memberName; __traits(allMembers, mixin(modname))) {
    alias member = __traits(getMember, mixin(modname), memberName);
    static if (isFunction!member) {
			string ret = ReturnType!(member).stringof;
			string par = Parameters!(member).stringof;
			global ~= i"  $(ret) function$(par) $(memberName);\n".text;
			fun ~= i"  $(memberName) = cast(typeof($(memberName))) GetProcAddress(mod$(dllname), `$(memberName)`);\n".text;
		}
	}
	fun ~= "}\n\n";
	return global ~ "}\n\n" ~ fun;
}
