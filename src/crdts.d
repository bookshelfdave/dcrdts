module dcrdts;
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
    TwoPSet!int psa = new TwoPSet!int();
    psa.add(1);
    psa.add(2);
    psa.add(3);
    psa.remove(2);
    psa.add(2);
    assert(psa.contains(1));
    assert(!psa.contains(2));
    assert(psa.contains(3));

    TwoPSet!int psb = new TwoPSet!int();
    psb.add(10);
    psb.remove(100);
    psb.add(11);
    psb.add(12);
    psb.remove(12);
    psb.add(12);

    assert(psb.contains(10));
    assert(psb.contains(11));
    assert(!psb.contains(12));

    psa.join(psb);
    assert(psa.contains(1));
    assert(psa.contains(3));
    assert(psa.contains(10));
    assert(psa.contains(11));
    psa.add(2); // tombstone prevents addition
    assert(!psa.contains(2));
    psa.add(12); // tombstone prevents addition
    assert(!psa.contains(12));

  }

}

class GCounter(T) {
  string id;

  this(string id) {
    this.id = id;
  }

}
