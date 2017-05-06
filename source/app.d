import Lexer, Parser, eval, ASTItems, builtinfuncs;
import std.stdio;


/// Lips ソースコードを実行する
void execute(string src) {
	writeln("\n== EXECUTE ==");

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

	// 字句解析して構文解析して評価する
	auto it = lex(src);
	auto ast = parse(it);
	eval.eval(ast, env);
}

void main()
{
	

	string[] srcs = [
		`(print (+ 1 2 2))`,
		`(if () (print 'true') (print 'false'))`,
		`(do (print 'HELLO WOLRD') (print 'GOOD BYE'))`,
		`(do (def v 1) (print v))`,
		`(do (def f (func (arg1 arg2) (print arg1))) (f 2 1))`,
		`(do (def f (func (arg1) (+ 1 arg1))) (print (f 3)))`,
		`(print ((func (arg1) (+ 1 arg1)) 2))`,
		`(do (def v 10) (print (- v 1)))`,
		`(do
			(def factorial (func (n) 
				(if (= n 1)
					1
					(* n (factorial (- n 1))))))
			(print (factorial 4))
			(print (factorial 1))
			(print (factorial 10)))`
	];
			
	foreach (src; srcs) {
		execute(src);
	}
}