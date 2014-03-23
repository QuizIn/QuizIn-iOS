#ifndef QuizIn_QIMemoryManagementMacros_h
#define QuizIn_QIMemoryManagementMacros_h

#define QI_DECLARE_WEAK_SELF(name) __typeof(self) __weak name = self

#define QI_DECLARE_WEAK(var, name) __typeof(var) __weak name = var

#endif
