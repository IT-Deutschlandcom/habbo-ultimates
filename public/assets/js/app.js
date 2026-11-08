(() => {
  'use strict';
  const $ = (s, c = document) => c.querySelector(s), $$ = (s, c = document) => [...c.querySelectorAll(s)];
  const csrf = document.querySelector('meta[name=csrf]')?.content || '';
  $$('[data-avatar-fallback]').forEach(img => {
    const unavailable = () => {
      img.removeEventListener('error', unavailable);
      img.src = img.dataset.avatarFallback;
      img.alt = 'Avatar derzeit nicht verfügbar';
      img.title = img.alt;
    };
    img.addEventListener('error', unavailable);
    if (img.complete && !img.naturalWidth) unavailable();
  });

  // Ladebildschirm (einmal pro Sitzung)
  const loader = $('#loader');
  if (loader) {
    if (sessionStorage.getItem('loaded')) loader.remove();
    else {
      const bar = $('i', loader), pct = $('.pct', loader), txt = $('small', loader);
      const msgs = ['Lade das Hotel…', 'Pflücke Kirschblüten…', 'Baue Räume auf…', 'Fast geschafft…'];
      let p = 0;
      const t = setInterval(() => {
        p = Math.min(100, p + Math.random() * 14 + 6);
        bar.style.width = p + '%'; pct.textContent = Math.floor(p) + '%'; txt.textContent = msgs[Math.min(3, Math.floor(p / 26))];
        if (p >= 100) { clearInterval(t); setTimeout(() => { loader.classList.add('done'); sessionStorage.setItem('loaded', '1'); setTimeout(() => loader.remove(), 800); }, 250); }
      }, 140);
    }
  }

  // Toasts
  const box = $('#toasts');
  window.toast = (msg, type = 'info') => {
    const d = document.createElement('div'); d.className = 'toastx ' + type; d.textContent = msg; box.appendChild(d);
    setTimeout(() => { d.classList.add('out'); setTimeout(() => d.remove(), 400); }, 4500);
  };
  (window.__flash || []).forEach(f => toast(f.m, f.t));

  // Sidebar (mobil)
  const menu = $('.menu-btn');
  const setMenu = open => {
    document.body.classList.toggle('side-open', open);
    menu?.setAttribute('aria-expanded', String(open));
  };
  menu?.addEventListener('click', () => setMenu(!document.body.classList.contains('side-open')));
  document.addEventListener('click', e => {
    if (document.body.classList.contains('side-open') && !e.target.closest('.sidebar,.menu-btn')) setMenu(false);
  });
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape' && document.body.classList.contains('side-open')) { setMenu(false); menu?.focus(); }
  });

  // Ripple
  document.addEventListener('click', e => {
    const b = e.target.closest('.btn'); if (!b) return;
    const r = b.getBoundingClientRect(), s = Math.max(r.width, r.height), d = document.createElement('span');
    d.className = 'ripple'; d.style.cssText = `width:${s}px;height:${s}px;left:${e.clientX - r.left - s / 2}px;top:${e.clientY - r.top - s / 2}px`;
    b.appendChild(d); setTimeout(() => d.remove(), 600);
  });

  // Reveal on scroll + Zähler
  const io = new IntersectionObserver(es => es.forEach(en => {
    if (!en.isIntersecting) return; en.target.classList.add('in'); io.unobserve(en.target);
    $$('[data-count]', en.target).concat(en.target.dataset.count ? [en.target] : []).forEach(countUp);
    $$('.bars i', en.target).forEach(i => { i.style.height = i.dataset.h; });
  }), { threshold: .12 });
  $$('.reveal').forEach((el, i) => { el.style.transitionDelay = Math.min(i % 6, 5) * 70 + 'ms'; io.observe(el); });
  function countUp(el) {
    const to = +el.dataset.count, t0 = performance.now();
    const f = n => { const k = Math.min(1, (n - t0) / 900); el.textContent = Math.round(to * (1 - Math.pow(1 - k, 3))).toLocaleString('de-DE'); if (k < 1) requestAnimationFrame(f); };
    requestAnimationFrame(f);
  }
  $$('.bars i').forEach(i => { i.dataset.h = i.style.height; i.style.height = '4px'; });

  // 3D-Tilt auf Karten
  if (matchMedia('(hover:hover)').matches) $$('.tilt').forEach(el => {
    el.addEventListener('mousemove', e => { const r = el.getBoundingClientRect(), x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5; el.style.transform = `perspective(900px) rotateX(${-y * 5}deg) rotateY(${x * 6}deg) translateY(-3px)`; });
    el.addEventListener('mouseleave', () => { el.style.transform = ''; });
  });

  // Kirschblüten-Canvas
  const cv = $('#petals');
  if (cv && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
    const c = cv.getContext('2d'); let W, H; const N = innerWidth < 700 ? 14 : 30;
    const size = () => { W = cv.width = innerWidth; H = cv.height = innerHeight; }; size(); addEventListener('resize', size);
    const mk = (init) => ({ x: Math.random() * W, y: init ? Math.random() * H : -20, s: 6 + Math.random() * 9, v: .35 + Math.random() * .9, sw: Math.random() * 6.28, sp: .01 + Math.random() * .02, r: Math.random() * 6.28, rs: (Math.random() - .5) * .04, a: .25 + Math.random() * .4 });
    const ps = Array.from({ length: N }, () => mk(true));
    (function draw() {
      c.clearRect(0, 0, W, H);
      for (const p of ps) {
        p.y += p.v; p.sw += p.sp; p.x += Math.sin(p.sw) * .7 + .25; p.r += p.rs;
        if (p.y > H + 20 || p.x > W + 20) Object.assign(p, mk(false));
        c.save(); c.translate(p.x, p.y); c.rotate(p.r); c.globalAlpha = p.a;
        const g = c.createRadialGradient(0, 0, 0, 0, 0, p.s); g.addColorStop(0, '#ffd1e6'); g.addColorStop(1, '#ff6fae');
        c.fillStyle = g; c.beginPath(); c.moveTo(0, -p.s); c.bezierCurveTo(p.s, -p.s * .6, p.s * .8, p.s * .8, 0, p.s * .6); c.bezierCurveTo(-p.s * .8, p.s * .8, -p.s, -p.s * .6, 0, -p.s); c.fill(); c.restore();
      }
      requestAnimationFrame(draw);
    })();
  }

  // Vote (AJAX)
  document.addEventListener('click', async e => {
    const b = e.target.closest('[data-vote]'); if (!b) return;
    const w = b.closest('[data-entity]'), fd = new FormData();
    fd.append('entity', w.dataset.entity); fd.append('id', w.dataset.id); fd.append('type', b.dataset.vote); fd.append('_token', csrf);
    const r = await fetch('/vote', { method: 'POST', body: fd, headers: { Accept: 'application/json' } });
    if (!r.ok) return toast('Bitte logge dich ein.', 'warning');
    const j = await r.json();
    $('[data-vote="1"] span', w).textContent = j.likes; $('[data-vote="2"] span', w).textContent = j.dislikes;
    $$('[data-vote]', w).forEach(x => x.classList.toggle('on', +x.dataset.vote === j.mine));
  });

  // Bestätigungsdialog
  document.addEventListener('submit', e => { const m = e.target.dataset.confirm; if (m && !confirm(m)) e.preventDefault(); });

  // RCON-Konsole
  $$('form[data-rcon]').forEach(f => f.addEventListener('submit', async e => {
    e.preventDefault();
    const r = await fetch('/admin/rcon', { method: 'POST', body: new FormData(f), headers: { Accept: 'application/json' } });
    const j = await r.json().catch(() => ({ ok: false, msg: 'Fehler' })); toast(j.msg, j.ok ? 'success' : 'danger');
  }));

  // Live-Online-Zähler
  const on = $('[data-online]');
  if (on) setInterval(async () => { try { const j = await (await fetch('/api/online')).json(); $$('[data-online]').forEach(x => x.textContent = j.online); } catch (_) {} }, 30000);
})();
