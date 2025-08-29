import javascript

predicate empty_block(BlockStmt b) {
    b.getNumStmt() = 0
}

predicate if_empty_then(IfStmt i) {
    empty_block(i.getThen())
}

predicate empty_while(WhileStmt w) {
    empty_block(w.getBody())
}

// Extension 1
// from Function f
// where
//   exists(f.getABodyStmt()) and
//   not exists(IfStmt i| i.getContainer() = f) or
//   not exists(ReturnStmt r| r.getContainer() = f)
// select f

// Extension 2
from Stmt s
where
  if_empty_then(s) or
  empty_while(s)
select s

