(function () {
  'use strict';

  /* ---------- idioma (pt/en), compartilha a chave "lang" com as páginas de projeto ---------- */
  var LANGS = ['pt', 'en'];
  var current = localStorage.getItem('lang');
  if (LANGS.indexOf(current) === -1) current = 'pt';

  var langButtons = Array.prototype.slice.call(document.querySelectorAll('.lang__btn'));

  function applyLang(lang) {
    current = lang;
    document.documentElement.lang = lang === 'pt' ? 'pt-BR' : 'en';
    document.querySelectorAll('[data-pt][data-en]').forEach(function (el) {
      el.innerHTML = el.getAttribute('data-' + lang);
    });
    document.querySelectorAll('[data-pt-aria][data-en-aria]').forEach(function (el) {
      el.setAttribute('aria-label', el.getAttribute('data-' + lang + '-aria'));
    });
    document.querySelectorAll('[data-pt-title][data-en-title]').forEach(function (el) {
      el.setAttribute('title', el.getAttribute('data-' + lang + '-title'));
    });
    langButtons.forEach(function (b) {
      b.setAttribute('aria-pressed', b.getAttribute('data-lang') === lang ? 'true' : 'false');
    });
    var t = document.querySelector('title');
    if (t && t.getAttribute('data-' + lang)) document.title = t.getAttribute('data-' + lang);
    try { localStorage.setItem('lang', lang); } catch (e) { /* storage bloqueado: segue sem persistir */ }
  }

  langButtons.forEach(function (b) {
    b.addEventListener('click', function () { applyLang(b.getAttribute('data-lang')); });
  });

  applyLang(current);

  /* ---------- menu mobile ---------- */
  var nav = document.querySelector('.nav');
  var burger = document.querySelector('.nav__burger');
  if (nav && burger) {
    burger.addEventListener('click', function () {
      var open = nav.classList.toggle('is-open');
      burger.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    nav.querySelectorAll('.nav__links a').forEach(function (a) {
      a.addEventListener('click', function () {
        nav.classList.remove('is-open');
        burger.setAttribute('aria-expanded', 'false');
      });
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && nav.classList.contains('is-open')) {
        nav.classList.remove('is-open');
        burger.setAttribute('aria-expanded', 'false');
        burger.focus();
      }
    });
  }

  /* ---------- filtros de projetos ---------- */
  var filterButtons = Array.prototype.slice.call(document.querySelectorAll('.filters .pill'));
  var projects = Array.prototype.slice.call(document.querySelectorAll('.project[data-cat]'));
  filterButtons.forEach(function (btn) {
    btn.addEventListener('click', function () {
      var cat = btn.getAttribute('data-filter');
      filterButtons.forEach(function (b) { b.setAttribute('aria-pressed', b === btn ? 'true' : 'false'); });
      projects.forEach(function (p) {
        var cats = (p.getAttribute('data-cat') || '').split(' ');
        p.classList.toggle('is-hidden', !(cat === 'all' || cats.indexOf(cat) !== -1));
      });
    });
  });

  /* ---------- copiar e-mail ---------- */
  var copyBtn = document.getElementById('copy-email');
  var copied = document.getElementById('copied');
  if (copyBtn && navigator.clipboard) {
    copyBtn.addEventListener('click', function () {
      navigator.clipboard.writeText(copyBtn.getAttribute('data-email')).then(function () {
        if (!copied) return;
        copied.hidden = false;
        clearTimeout(copied._t);
        copied._t = setTimeout(function () { copied.hidden = true; }, 1800);
      });
    });
  } else if (copyBtn) {
    copyBtn.hidden = true;
  }
})();
