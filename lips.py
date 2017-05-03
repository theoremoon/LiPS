import string
import copy

script = [
    'do',
    ['func', 'factorial', ['n'], [
        'if',
        ['<=', 'n', 1],
        1,
        ['*', 'n', ['factorial', ['-', 'n', 1]]]
    ]],
    ['print', ['factorial', 10]]
]
script2 = [
    'do',
    ['func', 'FZBZ', ['v'],
     ['if',
      ['=', ['%', 'v', 15], 0],
      ['str', 'FizzBuzz'],
      ['if',
       ['=', ['%', 'v', 5], 0],
       ['str', 'Buzz'],
       ['if',
        ['=', ['%', 'v', 3], 0],
        ['str', 'Fizz'],
        ['v']
        ]
       ]
     ]
     ], 
    ['print', ['FZBZ', 2]]
]


def my_eval(code, fenv, venv):
    """
    :param code: AST
    :param fenv: function environment
    :param venv: variable environment
    """
        
    if isinstance(code, int):
        return code
           
    
    op = code[0]
    if isinstance(code, str):
        op = code
        
    if isinstance(op, int):
        return op
    if op == 'print':
        r = my_eval(code[1], fenv, venv)
        print(r)
        return r
    elif op == 'if':
        cond = my_eval(code[1], fenv, venv)
            
        if cond is None or cond is False:
            return my_eval(code[3], fenv, venv)
        return my_eval(code[2], fenv, venv)
    elif op == '<=':
        v1 = my_eval(code[1], fenv, venv)
        v2 = my_eval(code[2], fenv, venv)
        return v1 <= v2
    elif op == '*':
        v1 = my_eval(code[1], fenv, venv)
        v2 = my_eval(code[2], fenv, venv)
        return v1 * v2
    elif op == '-':
        v1 = my_eval(code[1], fenv, venv)
        v2 = my_eval(code[2], fenv, venv)
        return v1 - v2
    elif op == 'func':
        fname = code[1]
        fenv[fname] = {
            'args': code[2],
            'code': code[3]
        }
        return None
    elif op == 'do':
        newenv = copy.deepcopy(venv)
        result = None
        for c in code[1:]:
            result = my_eval(c, fenv, newenv)
        return result
    elif op == 'def':
        venv[code[1]] = my_eval(code[2], fenv, venv)
        return venv[code[1]]
    elif op == 'list':
        ls = []
        for v in code[1:]:
            ls.append(my_eval(v, fenv, venv))
        return ls
    elif op == 'str':
        return code[1]
    elif op == '=':
        v1 = my_eval(code[1], fenv, venv)
        v2 = my_eval(code[2], fenv, venv)
        return v1 == v2
    elif op == '%':
        v1 = my_eval(code[1], fenv, venv)
        v2 = my_eval(code[2], fenv, venv)
        return v1 % v2
    else:
        if op in fenv:
            newenv = {}
            for i, n in enumerate(fenv[op]['args']):
                newenv[n] = my_eval(code[i+1], fenv, venv)
            return my_eval(fenv[op]['code'], fenv, newenv)
        if op in venv:
            return venv[op]
    raise Exception("Invalid Name {}".format(op))

if __name__ == '__main__':
    my_eval(script2, {}, {})
    
