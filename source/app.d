import Lexer, Parser, eval, ASTItems, builtinfuncs;
import std.stdio;


void execute(string src) {
	writeln("\n== EXECUTE ==");

	Env env;

	env["print"] = new ASTBuiltin("print", &builtin_print);
	env["+"] = new ASTBuiltin("+", &builtin_add);
	env["if"] = new ASTBuiltin("if", &builtin_if);
	env["do"] = new ASTBuiltin("do", &builtin_do);
	env["def"] = new ASTBuiltin("def", &builtin_def);
	env["func"] = new ASTBuiltin("func", &builtin_func);

	auto it = lex(src);
	// writeln(it);
	auto ast = parse(it);
	// writeln(ast);
	eval.eval(ast, env);
}

void main()
{
	

	string[] srcs = [
		`(print (+ 1 2 2))`,
		`(if () (print 'true') (print 'false'))`,
		`(do (print 'HELLO WOLRD') (print 'GOOD BYE'))`,
		`(do (def v 1) (print v))`,
		`(do (func f (arg1 arg2) (print arg1)) (f 2 1))`,
	];
	// string src = `(do
	// 	(func factorial (n) (
	// 		(if (= n 1)
	// 			1
	// 			(* n (factorial (- n 1)))
	// 		)
	// 	))
	// 	(print (factorial 10))
	// )`;
	foreach (src; srcs) {
		execute(src);
	}
}