import java

from Method m
where not m.isAbstract() and m.fromSource()
select m,
  m.getDeclaringType().getQualifiedName() as declaringType,
  m.getName() as methodName,
  m.getReturnType().toString() as returnType,
  m.getNumberOfParameters() as paramCount,
  m.getLocation().getStartLine() as startLine