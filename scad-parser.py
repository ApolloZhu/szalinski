#!/usr/bin/env python3

from lark import Lark, Transformer

parser = Lark(r"""
    program: instr*

    instr:
         | "group();" -> empty_group
         | "group()" _scope -> group
         | "union()" _scope -> union
         | "difference()" _scope -> diff
         | "multmatrix(" mat ")" _scope -> matrix

    _scope: "{" (instr | object)* "}"

    num: NUMBER
    ?ident: /\$?[a-z][a-zA-Z0-9]*/

    vec4: "[" num "," num "," num "," num "]"
    mat:  "[" vec4 "," vec4 "," vec4 "," vec4 "]"

    vec3: "[" num "," num "," num "]"
    arg: ident "=" value
    ?value: num | vec3 | bool
    bool: "true" | "false"

    object: ident "(" [arg ("," arg)*] ")" ";"

    %import common.WS
    %import common.SIGNED_NUMBER    -> NUMBER
    %ignore WS

    """, start='program', debug=True)

def debug(*args, **kwargs):
    # print(*args, **kwargs, file=sys.stderr)
    pass

def foldup(op, args):
    debug('foldup', op, args)
    assert args
    if len(args) == 1:
        return args[0]
    if len(args) == 2:
        return [op, args[0], args[1]]
    return [op, args[0], foldup(op, args[1:])]

def get_scale(m):
    for i, row in enumerate(m):
        for j, elem in enumerate(row):
            if i != j and elem != 0:
                return None
    assert m[3][3] == 1
    return ['Scale', m[0][0], m[1][1], m[2][2]]

def get_trans(m):
    for i, row in enumerate(m):
        for j, elem in enumerate(row):
            if i == j and elem != 1:
                return None
            if i != j and j != 3 and elem != 0:
                return None
    return ['Trans', m[0][3], m[1][3], m[2][3]]

class SexpTransformer(Transformer):

    def program(self, args):
        debug('program', args)
        nonempty = [group for group in args if group]
        assert len(nonempty) == 1
        return nonempty[0]

    def empty_group(self, args): return None
    def group(self, args):
        assert len(args) == 1
        return args[0]

    def arg  (self, args): return list(args)
    def vec3 (self, args): return list(args)
    def vec4 (self, args): return list(args)
    def mat  (self, args): return list(args)
    def num  (self, args): return float(args[0])

    def union(self, args): return foldup('Union', args)
    def diff (self, args): return foldup('Diff',  args)

    def matrix(self, args):
        debug('matrix', args)
        mat, *args = args
        op = get_trans(mat) or get_scale(mat) or ['Matrix']
        if len(args) == 1:
            return op + args
        else:
            return foldup('Union', [op + [a] for a in args])

    def object(self, args):
        debug('object', args)
        op, args = args[0], dict(args[1:])
        if op == 'sphere':
            r = args['r']
            return 'Sphere' if r == 1.0 else ['Scale', r, r, r, 'Sphere']
        if op == 'cube':
            x, y, z = args['size']
            return 'Cube' if (x, y, z) == (1, 1, 1) else ['Scale', x, y, z, 'Cube']
        if op == 'cylinder':
            h, r1, r2 = args['h'], args['r1'], args['r2']
            assert r1 == r2
            return 'Cylinder' if (h, r1, r2) == (1, 1, 1) else ['Scale', h, r1, r2, 'Cylinder']

        raise ValueError('Unexpected object {}, args: {}'.format(op, args))

def pretty_print(sexp, current=0, step=2, limit=80):
    if type(sexp) is not list:
        return str(sexp)

    op, *args = sexp
    assert type(op) is str
    assert type(args) is list
    pp_args = [pretty_print(a) for a in args]
    s = '(' + ' '.join([op] + pp_args) + ')'
    if current + len(s) < limit:
        return s
    current += step
    indent = ' ' * current
    pp_args = [pretty_print(a, current=current) for a in args]
    s = '(' + ('\n' + indent).join([op] + pp_args) + ')'
    return s

if __name__ == "__main__":
    import sys

    s = sys.stdin.read()
    tree = parser.parse(s)
    debug(tree.pretty())
    sexp = SexpTransformer().transform(tree)
    debug('done')
    debug(sexp)
    print(pretty_print(sexp))