const langBtn = document.getElementById('toggle-lang');
let currentLang = localStorage.getItem('lang') || 'pt';

// Aplica o idioma salvo
document.querySelectorAll('[data-pt][data-en]').forEach(el => {
  el.innerHTML = el.getAttribute(`data-${currentLang}`);
});
langBtn.textContent = currentLang === 'pt' ? '🇺🇸' : '🇧🇷';

// Alternar idioma
langBtn.addEventListener('click', () => {
  currentLang = currentLang === 'pt' ? 'en' : 'pt';
  localStorage.setItem('lang', currentLang);

  document.querySelectorAll('[data-pt][data-en]').forEach(el => {
    el.innerHTML = el.getAttribute(`data-${currentLang}`);
  });

  langBtn.textContent = currentLang === 'pt' ? '🇺🇸' : '🇧🇷';
});
