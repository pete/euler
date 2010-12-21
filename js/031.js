/*
  How many different ways can £2 be made using any number of coins?
*/

xs = {
  "200":100,
  "100":50,
  "50":20,
  "20":10,
  "10":5,
  "5":2,
  "2":1
};

function p(x, n) {
  if(x === undefined)
    return 0;

  if(x == 1)
    return 1;

  if(n < 0)
    return 0;

  return(p(xs[x], n) + p(x, n - x));
}

// Either I don't know Javascript, or there is no good way to determine if I can
// use console.log or print.  NodeJS defines print, but defines it to throw a
// deprecation error.  SpiderMonkey doesn't define console, and "console ===
// undefined" throws an error.  I tried "this.console", but Node doesn't define
// this.console; console is somewhere higher up, and "this" isn't the toplevel
// binding/global object/whatever.  So I eventually broke down and put it into
// two files, to avoid having to do an eval to see if an error was thrown.
// FFFFFFFFFUUUUUUUU---
print(p(200, 200));
