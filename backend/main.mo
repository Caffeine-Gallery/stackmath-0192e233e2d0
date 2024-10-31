import Error "mo:base/Error";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Stack "mo:base/Stack";

import Float "mo:base/Float";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";

actor {
  type Stack = [Float];

  public func calculate(input: Text) : async Text {
    let tokens = Iter.toArray(Text.tokens(input, #text(" ")));
    var stack : Stack = [];

    for (token in tokens.vals()) {
      switch (token) {
        case "+" { stack := operate(stack, Float.add); };
        case "-" { stack := operate(stack, Float.sub); };
        case "*" { stack := operate(stack, Float.mul); };
        case "/" { stack := operate(stack, Float.div); };
        case _ {
          switch (textToFloat(token)) {
            case (?num) { stack := Array.append(stack, [num]); };
            case (null) { return "Error: Invalid token " # token; };
          };
        };
      };
    };

    if (stack.size() != 1) {
      return "Error: Invalid expression";
    };

    Float.toText(stack[0])
  };

  func operate(stack: Stack, op: (Float, Float) -> Float) : Stack {
    if (stack.size() < 2) {
      Debug.print("Error: Insufficient operands");
      return stack;
    };

    let b = stack[stack.size() - 1];
    let a = stack[stack.size() - 2];
    let result = op(a, b);
    Array.tabulate<Float>(stack.size() - 1, func(i) {
      if (i == stack.size() - 2) { result } else { stack[i] }
    })
  };

  func textToFloat(t : Text) : ?Float {
    var int : Nat = 0;
    var frac : Float = 0;
    var div : Float = 1;
    var isNeg = false;
    var afterDot = false;

    for (c in t.chars()) {
      if (c == '-') {
        if (int == 0 and frac == 0 and not isNeg) {
          isNeg := true;
        } else {
          return null;
        };
      } else if (c == '.') {
        if (afterDot) {
          return null;
        };
        afterDot := true;
      } else if (c >= '0' and c <= '9') {
        let digit = Nat32.toNat(Char.toNat32(c) - Char.toNat32('0'));
        if (afterDot) {
          div *= 10;
          frac += Float.fromInt(digit) / div;
        } else {
          int := int * 10 + digit;
        };
      } else {
        return null;
      };
    };

    let result = Float.fromInt(int) + frac;
    ?((if (isNeg) -result else result))
  };
}
