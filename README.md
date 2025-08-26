Recitation 1: CodeQL
====================

[CodeQL](https://semmle.com/codeql) is a structured query language for syntax-directed analysis. CodeQL allows us to ask questions about a project's abstract syntax tree and find patterns/bugs. CodeQL compiles code and builds a database of information that can be queried (e.g., variables, types, functions, dataflow) and combined to build up an analysis. We first have to create or import a CodeQL database to query a specific project.

Recitation Goals:

In this recitation, we will:

1. Get set up to run queries using CodeQL VS Code's extension.
2. Get an overview of how a query works and how to navigate the interface.
3. Learn how to write simple analyses targeting JavaScript.

Setup:
------
1. Open this repository using **GitHub Codespaces** by pressing "," on your keyboard. A dialogue may say "This folder contains a workspace file ... <snip> ... Do you want to open it?" Click "Open Workspace".  You may receive a warning from the Git extension of too many active changes in the codeql submodule; you can ignore this warning, especially since you won't turn in this git repository. You may need to wait a couple minutes for everything to get set up properly. 
2. Open the QL Tab on the sidebar of Visual Studio Code and click **"Add a CodeQL database From GitHub"**. Download `meteor/meteor` (https://github.com/meteor/meteor) CodeQL database.


Example Query 1, "Functions with many parameters":
--------------------------------------------------
In VSCode, go to `javascript-queries/` and open the file **ex1.ql**, where you can
find the following code:

```
import javascript

from Function f
where f.getNumParameter() > 10
select f
```

Here is an explanation of each part of the code:

| Query                            | Purpose                                                       |
|----------------------------------|---------------------------------------------------------------|
| `import javascript`              | Tells CodeQL to use the JavaScript library                    |
| `from Function f`                | Defines a variable `f` that ranges over Functions             |
| `where f.getNumParameter() > 10` | Constrains `f` to only functions with more than 10 parameters |
| `select f`                       | Tells CodeQL to display all matching `f`                      |

Run this example query on `meteor/meteor`.
You can do this by right clicking on file **ex1.ql** and selecting "CodeQL: Run Queries in Selected Files"
After running the query, you can press on the result to jump to that file.


Example Query 2, "If statements with empty then branch":
--------------------------------------------------------

In `javascript-queries/` create a new file **ex2.ql** with the following code:

```
import javascript

from IfStmt i
where i.getThen().(BlockStmt).getNumStmt() = 0
select i
```

This query finds `if` statements guarding an empty block. Note that this query
uses a cast (the `(BlockStmt)`). The return type of `getThen()` is `Stmt`, but
we are only interested in empty blocks, and the cast adds this constraint. See
the [JavaScript AST class
reference](https://codeql.github.com/docs/codeql-language-guides/abstract-syntax-tree-classes-for-working-with-javascript-and-typescript-programs)
for more info on classes.

Another way of doing this is to introduce a new variable and constrain it to be
equal to `getThen()`. This is useful if you'd like to use the new variable in
several places. Try running the following query:

```
import javascript

from BlockStmt b, IfStmt i
where
  i.getThen() = b and
  b.getNumStmt() = 0
select i, b.getContainer()
```

Note that `and` and `or` can be used to combine queries, and `select` can take a
comma-delimited list of values you'd like to inspect.

Example Query 3, "Functions without return statements":
-------------------------------------------------------
Load the "Functions without return statements" example. You should get this
code:

```
import javascript

from Function f
where
  exists(f.getABodyStmt()) and
  not exists(ReturnStmt r | r.getContainer() = f)
select f
```

This query uses the [`exists`
quantifier](https://codeql.github.com/docs/ql-language-reference/formulas/#exists). `exists`
is true if there is at least one set of variables that can make it true. For
example `exists(f.getABodyStmt())` is true if there is at least one statement in
the body of the function `f`. You can also define local variables in
`exists`. The syntax for this is `exists(<variables> | <formula>)`.

### Exercise 1:
Try extending this query to also filter out functions containing `if` statements.

Predicates:
-----------
Quantifiers can also be abstracted into predicates which can be used as
quantifiers themselves. For example, we can refactor the "If statement with
empty then branch" example using predicates:

```
import javascript

predicate empty_block(BlockStmt b) {
  b.getNumStmt() = 0
}

predicate if_empty_then(IfStmt i) {
  empty_block(i.getThen())
}

from Stmt s
where if_empty_then(s)
select s
```

### Exercise 2: 
Try extending this query to also match both empty `then` blocks and  empty `while` statements.

Resources:
----------
These resources will help when writing your own CodeQL queries:

- [The QL Language Reference](https://codeql.github.com/docs/ql-language-reference)
- [JavaScript AST class
  reference](https://codeql.github.com/docs/codeql-language-guides/abstract-syntax-tree-classes-for-working-with-javascript-and-typescript-programs)