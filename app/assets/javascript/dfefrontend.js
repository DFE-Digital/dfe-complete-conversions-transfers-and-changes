!(function (e) {
  var t = {};
  function r(n) {
    if (t[n]) return t[n].exports;
    var o = (t[n] = { i: n, l: !1, exports: {} });
    return e[n].call(o.exports, o, o.exports, r), (o.l = !0), o.exports;
  }
  (r.m = e),
    (r.c = t),
    (r.d = function (e, t, n) {
      r.o(e, t) || Object.defineProperty(e, t, { enumerable: !0, get: n });
    }),
    (r.r = function (e) {
      "undefined" != typeof Symbol &&
        Symbol.toStringTag &&
        Object.defineProperty(e, Symbol.toStringTag, { value: "Module" }),
        Object.defineProperty(e, "__esModule", { value: !0 });
    }),
    (r.t = function (e, t) {
      if ((1 & t && (e = r(e)), 8 & t)) return e;
      if (4 & t && "object" == typeof e && e && e.__esModule) return e;
      var n = Object.create(null);
      if (
        (r.r(n),
        Object.defineProperty(n, "default", { enumerable: !0, value: e }),
        2 & t && "string" != typeof e)
      )
        for (var o in e)
          r.d(
            n,
            o,
            function (t) {
              return e[t];
            }.bind(null, o),
          );
      return n;
    }),
    (r.n = function (e) {
      var t =
        e && e.__esModule
          ? function () {
              return e.default;
            }
          : function () {
              return e;
            };
      return r.d(t, "a", t), t;
    }),
    (r.o = function (e, t) {
      return Object.prototype.hasOwnProperty.call(e, t);
    }),
    (r.p = ""),
    r((r.s = 1));
})([
  function (e, t) {
    NodeList.prototype.forEach ||
      (NodeList.prototype.forEach = Array.prototype.forEach),
      Array.prototype.includes ||
        Object.defineProperty(Array.prototype, "includes", {
          enumerable: !1,
          value: function (e) {
            return (
              this.filter(function (t) {
                return t === e;
              }).length > 0
            );
          },
        }),
      Element.prototype.matches ||
        (Element.prototype.matches =
          Element.prototype.msMatchesSelector ||
          Element.prototype.webkitMatchesSelector),
      Element.prototype.closest ||
        (Element.prototype.closest = function (e) {
          var t = this;
          do {
            if (Element.prototype.matches.call(t, e)) return t;
            t = t.parentElement || t.parentNode;
          } while (null !== t && 1 === t.nodeType);
          return null;
        });
  },
  function (e, t, r) {
    "use strict";
    r.r(t);
    var n = function (e, t) {
        if (e && t) {
          var r = "true" === e.getAttribute(t) ? "false" : "true";
          e.setAttribute(t, r);
        }
      },
      o = function () {
        var e, t, r, o;
        (e = document.querySelector("#toggle-menu")),
          (t = document.querySelector("#close-menu")),
          (r = document.querySelector("#header-navigation")),
          (o = function (t) {
            t.preventDefault(),
              n(e, "aria-expanded"),
              e.classList.toggle("is-active"),
              r.classList.toggle("js-show");
          }),
          e &&
            t &&
            r &&
            [e, t].forEach(function (e) {
              e.addEventListener("click", o);
            }),
          (function () {
            var e = document.querySelector("#toggle-search"),
              t = document.querySelector("#close-search"),
              r = document.querySelector("#wrap-search"),
              o = document.querySelector("#content-header"),
              c = function (t) {
                t.preventDefault(),
                  n(e, "aria-expanded"),
                  e.classList.toggle("is-active"),
                  r.classList.toggle("js-show"),
                  o.classList.toggle("js-show");
              };
            e &&
              t &&
              [e, t].forEach(function (e) {
                e.addEventListener("click", c);
              });
          })();
      };
    r(0);
    document.addEventListener("DOMContentLoaded", function () {
      o();
    });
  },
]);
