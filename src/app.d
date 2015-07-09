import std.stdio;
import std.conv;
import std.container;
import std.range;
import std.algorithm.searching;

class GSet(T) {
  public RedBlackTree!T rbt;

  this() {
    rbt = new RedBlackTree!T();
  }

  void add(T t) {
    rbt.insert(t);
  }

  bool contains(T elem) {
    return elem in rbt;
  }

  void join(GSet other) {
    foreach(o; other.rbt[]) {
      rbt.insert(o);
    }
  }

  unittest {
    auto g = new GSet!int();
    g.add(1);
    g.add(2);
    assert(g.contains(1));
    assert(g.contains(2));
    assert(!g.contains(5));
    assert(!g.contains(6));

    auto h = new GSet!int();
    h.add(2);
    h.add(6);
    assert(h.contains(2));
    assert(h.contains(6));
    assert(!h.contains(1));

    g.join(h);
    assert(g.contains(1));
    assert(g.contains(2));
    assert(g.contains(6));
  }

}

void main() {
  auto g = new GSet!int();
  g.add(1);
  g.add(2);


  auto h = new GSet!int();
  h.add(5);
  h.add(6);

  g.join(h);
  //writeln(g.contains(5));
}
