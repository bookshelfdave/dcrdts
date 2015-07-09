import std.stdio;

import dcrdts;

void main(string[] args) {
  // unittests don't run unless there are template instantiations...?
  GSet!int g = new GSet!int();
//  g.add(1);
//  g.add(2);

  TwoPSet!int ps = new TwoPSet!int();
 // ps.add(1);
 // ps.add(2);
}
