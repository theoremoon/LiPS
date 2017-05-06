import Lexer, Parser, eval, ASTItems, builtinfuncs;
import std.stdio;


void main()
{
	Env env;

	env["print"] = new ASTBuiltin("print", &builtin_print);
	env["+"] = new ASTBuiltin("+", &builtin_add);
	env["if"] = new ASTBuiltin("if", &builtin_if);
	env["do"] = new ASTBuiltin("do", &builtin_do);
	env["def"] = new ASTBuiltin("def", &builtin_def);
	env["func"] = new ASTBuiltin("func", &builtin_func);

	string src = `(print (+ 1 2 2 'str'))`;
	src = `(if () (print 'true') (print 'false'))
	`;
	src = `(do (print 'HELLO WOLRD') (print 'GOOD BYE'))`;
	src = `(do (def v 1) (print v))`;
	src = `(func f (arg1 arg2) (print 1))`;
	// string src = `(do
	// 	(func factorial (n) (
	// 		(if (= n 1)
	// 			1
	// 			(* n (factorial (- n 1)))
	// 		)
	// 	))
	// 	(print (factorial 10))
	// )`;
	auto it = lex(src);
	// writeln(it);
	auto ast = parse(it);
	// writeln(ast);
	eval.eval(ast, env);
}