/* Aurelian Hotel - display currency switcher (USD / LKR).
   Display only: prices are converted in the browser; the database and backend still work in USD.
   To change the exchange rate, edit LKR.rate below. */
(function () {
  var CURRENCIES = {
    USD: { code: 'USD', name: 'US Dollar', flag: 'us', rate: 1,   prefix: '$' },
    LKR: { code: 'LKR', name: 'Sri Lankan Rupee', flag: 'lk', rate: 305, prefix: 'Rs. ' }   // <- 1 USD = 305 LKR (approx.)
  };
  var KEY = 'au-currency', cur = 'USD';
  try { var saved = localStorage.getItem(KEY); if (saved && CURRENCIES[saved]) cur = saved; } catch (e) {}
  var src = (document.currentScript && document.currentScript.src) || '';
  var base = src.replace(/\/js\/currency\.js.*$/, '');
  var PRICE = /\$\s?(\d[\d,]*(?:\.\d+)?)/g, HAS = /\$\s?\d/;
  var SKIP = { SCRIPT: 1, STYLE: 1, TEXTAREA: 1, NOSCRIPT: 1, TITLE: 1 };
  var state = new WeakMap();

  function convert(text) {
    var c = CURRENCIES[cur];
    return text.replace(PRICE, function (m, num) {
      var v = parseFloat(num.replace(/,/g, '')) * c.rate;
      return c.prefix + Math.round(v).toLocaleString('en-US');
    });
  }
  function skip(node) {
    var p = node.parentNode;
    if (!p || SKIP[p.nodeName]) return true;
    return p.closest && p.closest('.au-cur');
  }
  function handle(node) {
    var s = state.get(node);
    if (s && node.nodeValue === s.out) {            // one of our converted nodes
      if (cur === 'USD') { node.nodeValue = s.orig; state.delete(node); }
      else if (s.cur !== cur) { var o = convert(s.orig); state.set(node, { orig: s.orig, out: o, cur: cur }); node.nodeValue = o; }
      return;
    }
    if (s) state.delete(node);                       // page changed the text itself
    if (cur === 'USD' || skip(node) || !HAS.test(node.nodeValue)) return;
    var out = convert(node.nodeValue);
    if (out !== node.nodeValue) { state.set(node, { orig: node.nodeValue, out: out, cur: cur }); node.nodeValue = out; }
  }
  function walk(root) {
    if (root.nodeType === 3) { handle(root); return; }
    if (root.nodeType !== 1 || SKIP[root.nodeName]) return;
    var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null), n, list = [];
    while ((n = w.nextNode())) list.push(n);
    list.forEach(handle);
  }
  function apply() { if (document.body) walk(document.body); }

  function flag(c) { return '<img class="au-flag" src="' + base + '/images/flags/' + CURRENCIES[c].flag + '.svg" alt="" width="22" height="16">'; }
  function buildUI() {
    var host = document.querySelector('.nav-right');
    if (!host || document.getElementById('auCur')) return;
    var wrap = document.createElement('div'); wrap.className = 'au-cur'; wrap.id = 'auCur';
    var items = Object.keys(CURRENCIES).map(function (k) {
      return '<li role="option" tabindex="0" data-cur="' + k + '" aria-selected="' + (k === cur) + '">' + flag(k) +
        '<span class="au-cur-name"><b>' + k + '</b><small>' + CURRENCIES[k].name + '</small></span><i class="ph ph-check"></i></li>';
    }).join('');
    wrap.innerHTML = '<button type="button" class="au-cur-btn" aria-haspopup="listbox" aria-expanded="false" title="Change currency"></button>' +
      '<ul class="au-cur-menu" role="listbox" hidden>' + items +
      '<li class="au-cur-note">Prices in LKR are approximate. Payments are processed in USD.</li></ul>';
    var toggle = document.getElementById('auThemeToggle');
    if (toggle && toggle.parentNode === host) host.insertBefore(wrap, toggle); else host.insertBefore(wrap, host.firstChild);
    var btn = wrap.querySelector('.au-cur-btn'), menu = wrap.querySelector('.au-cur-menu');
    function paint() {
      btn.innerHTML = flag(cur) + '<span class="au-cur-code">' + cur + '</span><i class="ph ph-caret-down"></i>';
      [].forEach.call(menu.querySelectorAll('li[data-cur]'), function (li) { li.setAttribute('aria-selected', li.getAttribute('data-cur') === cur); });
    }
    function close() { menu.hidden = true; btn.setAttribute('aria-expanded', 'false'); }
    function choose(k) {
      cur = k; try { localStorage.setItem(KEY, k); } catch (e) {}
      paint(); close(); apply(); fit();
      if (window.Chart) setTimeout(function () { location.reload(); }, 150);
    }
    btn.addEventListener('click', function (e) { e.stopPropagation(); var open = menu.hidden; menu.hidden = !open; btn.setAttribute('aria-expanded', open ? 'true' : 'false'); });
    menu.addEventListener('click', function (e) { var li = e.target.closest('li[data-cur]'); if (li) choose(li.getAttribute('data-cur')); });
    menu.addEventListener('keydown', function (e) { if ((e.key === 'Enter' || e.key === ' ') && e.target.getAttribute('data-cur')) { e.preventDefault(); choose(e.target.getAttribute('data-cur')); } });
    document.addEventListener('click', function (e) { if (!wrap.contains(e.target)) close(); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') close(); });
    paint();
  }

  /* keep the navbar free of overlaps: compress step by step only when something would collide */
  function overlap(nav) {
    var l = nav.querySelector('.nav-left'), m = nav.querySelector('.nav-menu'), r = nav.querySelector('.nav-right');
    if (!l || !m || !r || !m.children.length) return false;
    var first = m.firstElementChild.getBoundingClientRect(), last = m.lastElementChild.getBoundingClientRect();
    return first.left < l.getBoundingClientRect().right + 8 || last.right > r.getBoundingClientRect().left - 8 || m.scrollWidth > m.clientWidth + 1;
  }
  function fit() {
    var nav = document.getElementById('navbar'); if (!nav) return;
    nav.classList.remove('au-tight', 'au-tighter');
    if (window.innerWidth < 1181) return;
    if (overlap(nav)) { nav.classList.add('au-tight'); if (overlap(nav)) nav.classList.add('au-tighter'); }
  }
  var rt; window.addEventListener('resize', function () { clearTimeout(rt); rt = setTimeout(fit, 80); });

  function init() {
    buildUI(); apply(); fit();
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(fit);
    window.addEventListener('load', fit);
    new MutationObserver(function (muts) {
      muts.forEach(function (m) {
        if (m.type === 'characterData') handle(m.target);
        else m.addedNodes.forEach(function (n) { walk(n); });
      });
    }).observe(document.body, { childList: true, subtree: true, characterData: true });
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();
