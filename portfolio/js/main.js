const toggleButton = document.getElementById('toggle-dark');
const langBtn = document.getElementById('toggle-lang');
let currentLang = localStorage.getItem('lang') || 'pt';

// Aplica o tema salvo (dark-mode)
if (localStorage.getItem('theme') === 'dark') {
  document.body.classList.add('dark-mode');
  toggleButton.textContent = '☀️';
} else {
  toggleButton.textContent = '🌙';
}

// Aplica o idioma salvo
document.querySelectorAll('[data-pt][data-en]').forEach(el => {
  el.innerHTML = el.getAttribute(`data-${currentLang}`);
});
langBtn.textContent = currentLang === 'pt' ? '🇺🇸' : '🇧🇷';

// Alternar tema
toggleButton.addEventListener('click', () => {
  document.body.classList.toggle('dark-mode');

  const isDark = document.body.classList.contains('dark-mode');
  localStorage.setItem('theme', isDark ? 'dark' : 'light');

  toggleButton.textContent = isDark ? '☀️' : '🌙';
});

// Alternar idioma
langBtn.addEventListener('click', () => {
  currentLang = currentLang === 'pt' ? 'en' : 'pt';
  localStorage.setItem('lang', currentLang);

  document.querySelectorAll('[data-pt][data-en]').forEach(el => {
    el.innerHTML = el.getAttribute(`data-${currentLang}`);
  });

  langBtn.textContent = currentLang === 'pt' ? '🇺🇸' : '🇧🇷';
});
