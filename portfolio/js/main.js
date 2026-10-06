const langBtn = document.getElementById('toggle-lang');
let currentLang = localStorage.getItem('lang') || 'pt';

// Aplica o idioma salvo (após o DOM carregar, para incluir o footer)
function applyLang() {
  document.querySelectorAll('[data-pt][data-en]').forEach(el => {
    el.innerHTML = el.getAttribute(`data-${currentLang}`);
  });
  langBtn.textContent = currentLang === 'pt' ? '🇺🇸' : '🇧🇷';
}
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', applyLang);
} else {
  applyLang();
}

// Alternar idioma
langBtn.addEventListener('click', () => {
  currentLang = currentLang === 'pt' ? 'en' : 'pt';
  localStorage.setItem('lang', currentLang);

  document.querySelectorAll('[data-pt][data-en]').forEach(el => {
    el.innerHTML = el.getAttribute(`data-${currentLang}`);
  });

  langBtn.textContent = currentLang === 'pt' ? '🇺🇸' : '🇧🇷';
});
