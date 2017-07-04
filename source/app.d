import Lexer, Parser, eval, ASTItems, builtinfuncs;
import std.stdio, std.file;

Env MakeEnv() {
	// 環境をつくって
	Env env;

	// ビルトイン関数を与える
	env["print"] = new ASTBuiltin(&builtin_print);
	env["+"] = new ASTBuiltin(&builtin_add);
	env["*"] = new ASTBuiltin(&builtin_multiply);
	env["-"] = new ASTBuiltin(&builtin_sub);
	env["if"] = new ASTBuiltin(&builtin_if);
	env["do"] = new ASTBuiltin(&builtin_do);
	env["def"] = new ASTBuiltin(&builtin_def);
	env["func"] = new ASTBuiltin(&builtin_func);
	env["="] = new ASTBuiltin(&builtin_eq);
	env["quote"] = new ASTBuiltin(&builtin_quote);
	env["list"] = new ASTBuiltin(&builtin_list);
	env["nth"] = new ASTBuiltin(&builtin_nth);
	env["macro"] = new ASTBuiltin(&builtin_macro);
	env["qquote"] = new ASTBuiltin(&builtin_qquote);

	return env;
}


/// Lips ソースコードを実行する
void execute(string src) {
	auto env = MakeEnv();

	// 字句解析して構文解析して評価する
	auto it = lex(src);
	auto asts = parse(it);
	foreach (ast; asts) {
	    eval.eval(ast, env);
	}
}

void main(string[] args)
{
	if (args.length > 1) {
		string src = cast(string)read(args[1]);
		execute(src);
	}
	else {
		auto env = MakeEnv();
		string line;
		while ((line = readln) !is null) {
			auto it = lex(line);
			auto asts = parse(it);
			foreach(ast; asts) {
			    auto res = eval.eval(ast, env);
			    write("=>"); builtin_print([res], env);
			}
		}
	}
}
