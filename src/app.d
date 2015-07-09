import std.stdio;
import std.conv;
import std.container;
import std.range;
import std.algorithm.searching;

import crdts;



void main() {
  GSet!int g = new GSet!int();
  g.add(1);
  g.add(2);
  g.add(3);
  writeln(g.elements());

  TwoPSet!int ps = new TwoPSet!int();
  ps.add(1);
  ps.add(2);
  ps.add(3);
  ps.remove(1);
  ps.add(1);
  writeln(ps.elements());
}
