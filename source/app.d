import Lexer, Parser, eval, ASTItems, builtinfuncs;
import std.stdio;


void main()
{
	Env env;

	env["print"] = new ASTBuiltin("print", &builtin_print);

	string src = `(print 'hello world')`;
	// string src = `(do (print 'HELLO WOLRD') (print 'GOOD BYE'))`;
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