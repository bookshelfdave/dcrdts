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

  RedBlackTree!T.Range elements() {
    return rbt[];
  }

  bool contains(T elem) {
    return elem in rbt;
  }

  void join(GSet other) {
    foreach(o; other.rbt[]) {
      rbt.insert(o);
    }
  }

  override bool opEquals(Object other) {
    GSet!T o = cast(GSet!T)other;
    return rbt.opEquals(o);
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

class TwoPSet(T) {
  RedBlackTree!T ss;
  RedBlackTree!T st; // tombstones

  this() {
    ss = new RedBlackTree!T();
    st = new RedBlackTree!T();
  }

  void add(T t) {
   if((t in st)) {
     // element in tombstone set
     return;
   }
   ss.insert(t);
  }

  RedBlackTree!T.Range elements() {
      return ss[];
  }


  bool contains(T elem) {
    return (elem in ss && !(elem in st));
  }


  void remove(T t) {
    // only remove if it exists in the set
    if(t in ss) {
      ss.removeKey(t);
      st.insert(t);
    }
  }

  void join(TwoPSet!T other) {
    foreach(tombstone; other.st) {
      st.insert(tombstone);
      ss.removeKey(tombstone);
    }

    foreach(obj; other.ss) {
      this.add(obj);
    }
  }

  override bool opEquals(Object other) {
    TwoPSet!T o = cast(TwoPSet!T) other;
    return this.ss == o.ss && this.st == o.st;
  }

  unittest {
    assert(false);
  }

}


