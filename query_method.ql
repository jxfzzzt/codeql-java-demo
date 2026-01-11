/**
 * @name List All Methods in Project
 * @description 列出项目中定义的所有方法及其详细信息
 * @kind problem
 * @id java/list-all-methods
 * @problem.severity recommendation
 */

import java

from Method m
where 
  m.fromSource() and           // Only methods defined in source code
  not m.isAbstract()           // Exclude abstract methods
select m,
  "Method: " + m.getName() + 
  " | Class: " + m.getDeclaringType().getQualifiedName() + 
  " | Return: " + m.getReturnType().toString() + 
  " | Params: " + m.getNumberOfParameters().toString() + 
  " | Line: " + m.getLocation().getStartLine().toString()