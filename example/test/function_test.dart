//class _$ {
//  Symbol last;
//  noSuchMethod() => last = i.memberName;
//}
//final dynamic $ = _$();
//
//main() {
//  print($.x1);   // Symbol #x1
//}

class ClassTest {
  noSuchMethod(Invocation invocation) {
    print(invocation.isMethod);
    print(invocation.memberName);
    Invocation.setter(const Symbol("test="), "");

    print(invocation.typeArguments);
  }
}
final dynamic $ = ClassTest();

main() {
  $.test(['type']);
}

