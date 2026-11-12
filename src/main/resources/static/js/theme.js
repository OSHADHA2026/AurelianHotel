/* Aurelian Hotel - light/dark theme toggle (UI only) */
(function () {
  var KEY = 'au-theme', root = document.documentElement;
  function isDark() { return root.getAttribute('data-theme') === 'dark'; }
  function paint(btn) {
    var dark = isDark();
    btn.innerHTML = '<i class="ph ph-' + (dark ? 'sun' : 'moon') + '"></i>';
    btn.setAttribute('aria-pressed', dark ? 'true' : 'false');
    btn.setAttribute('title', dark ? 'Switch to light mode' : 'Switch to dark mode');
    btn.setAttribute('aria-label', btn.getAttribute('title'));
  }
  function init() {
    if (document.getElementById('auThemeToggle')) return;
    var btn = document.createElement('button');
    btn.type = 'button'; btn.id = 'auThemeToggle'; btn.className = 'au-theme-toggle';
    var host = document.querySelector('.nav-right');
    if (host && host.offsetWidth > 0) { host.insertBefore(btn, host.firstChild); }
    else { btn.classList.add('au-floating'); document.body.appendChild(btn); }
    paint(btn);
    btn.addEventListener('click', function () {
      try {
        if (isDark()) { root.removeAttribute('data-theme'); localStorage.setItem(KEY, 'light'); }
        else { root.setAttribute('data-theme', 'dark'); localStorage.setItem(KEY, 'dark'); }
      } catch (e) { isDark() ? root.removeAttribute('data-theme') : root.setAttribute('data-theme', 'dark'); }
      paint(btn);
      if (window.Chart) { setTimeout(function () { location.reload(); }, 150); }
    });
    try { if (window.Chart && Chart.defaults && isDark()) { Chart.defaults.color = '#9db0c2'; Chart.defaults.borderColor = '#26394a'; } } catch (e) {}
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();
