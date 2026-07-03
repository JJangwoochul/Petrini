(function () {
    var STORAGE_KEY = 'petcareWishlist';
    var SELECTORS = '.wish-btn, .stay-wish-btn, .product-wish, .btn-wish-detail, .hospital-wish, .wish-heart';

    function getContextPath() {
        return window.__CONTEXT_PATH__ || '';
    }

    function readList() {
        try {
            var raw = localStorage.getItem(STORAGE_KEY);
            return raw ? JSON.parse(raw) : {};
        } catch (e) {
            return {};
        }
    }

    function writeList(list) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(list));
    }

    function resolveId(btn) {
        if (btn.dataset.wishId) {
            return btn.dataset.wishId;
        }

        var card = btn.closest('.stay-card, .product-card, .wish-card, .hospital-card');
        if (!card) {
            return null;
        }

        var onclick = card.getAttribute('onclick') || '';
        var match = onclick.match(/id=(\d+)/);
        if (!match) {
            return null;
        }

        if (card.classList.contains('stay-card')) {
            return 'stay:' + match[1];
        }
        if (card.classList.contains('product-card')) {
            return 'store:' + match[1];
        }
        if (card.classList.contains('hospital-card')) {
            return 'hospital:' + match[1];
        }
        return null;
    }

    function resolveMeta(btn, id) {
        var card = btn.closest('.stay-card, .product-card, .wish-card, .hospital-card, .detail-info');
        var type = id.split(':')[0];
        var title = btn.dataset.wishTitle;
        var price = btn.dataset.wishPrice;
        var image = btn.dataset.wishImage;
        var link = btn.dataset.wishLink;

        if (card) {
            title = title || card.querySelector('.sc-name, .product-name, .w-name, .detail-name, .hospital-name')?.textContent?.trim();
            price = price || card.querySelector('.sc-price strong, .price-sale, .w-price, .detail-price-sale, .hospital-price')?.textContent?.trim();
            image = image || card.querySelector('.stay-card-thumb img, .product-thumb, .wish-thumb, .detail-main-img, .hospital-thumb')?.getAttribute('src');
        }

        if (!link && (id.indexOf('stay:') === 0 || id.indexOf('hotel:') === 0)) {
            link = '/stay/detail?id=' + id.split(':')[1];
        }
        if (!link && id.indexOf('store:') === 0) {
            link = '/store/detail?id=' + id.split(':')[1];
        }
        if (!link && id.indexOf('hospital:') === 0) {
            link = '/hospital/detail?id=' + id.split(':')[1];
        }

        return {
            id: id,
            type: type,
            title: title || '찜한 항목',
            price: price || '',
            image: image || '',
            link: link || '/'
        };
    }

    function setActive(btn, active) {
        btn.classList.toggle('wish-active', active);
        btn.classList.toggle('wished', active);
        btn.setAttribute('aria-pressed', active ? 'true' : 'false');

        var svg = btn.querySelector('svg');
        if (svg) {
            svg.style.fill = active ? '#FF6B6B' : 'none';
            svg.style.stroke = active ? '#FF6B6B' : '';
        }

        if (btn.classList.contains('btn-wish-detail')) {
            btn.style.borderColor = active ? '#FF6B6B' : '';
            btn.style.color = active ? '#FF6B6B' : '';
        }
    }

    function syncButton(btn) {
        var id = resolveId(btn);
        if (!id) {
            return;
        }
        btn.dataset.wishId = id;
        setActive(btn, !!readList()[id]);
    }

    function toggle(btn) {
        var id = resolveId(btn);
        if (!id) {
            return;
        }

        var list = readList();
        var active;

        if (list[id]) {
            delete list[id];
            active = false;
        } else {
            list[id] = resolveMeta(btn, id);
            active = true;
        }

        writeList(list);
        setActive(btn, active);
        document.dispatchEvent(new CustomEvent('petcare:wishlist-changed', {
            detail: { id: id, active: active }
        }));
    }

    function bindButtons(root) {
        (root || document).querySelectorAll(SELECTORS).forEach(function (btn) {
            if (btn.dataset.wishBound === 'true') {
                syncButton(btn);
                return;
            }

            btn.dataset.wishBound = 'true';
            btn.setAttribute('type', btn.getAttribute('type') || 'button');
            btn.setAttribute('aria-label', btn.getAttribute('aria-label') || '찜하기');
            syncButton(btn);

            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                toggle(btn);
            });
        });
    }

    function renderWishlistPage() {
        var grid = document.getElementById('wishlistGrid');
        var countEl = document.getElementById('wishCount');
        if (!grid) {
            return;
        }

        var list = readList();
        var items = Object.keys(list).map(function (key) {
            return list[key];
        });

        if (countEl) {
            countEl.textContent = items.length;
        }

        if (items.length === 0) {
            grid.innerHTML = '<div class="search-empty" style="grid-column:1/-1;padding:48px 20px;text-align:center;color:var(--text-muted);">찜한 상품이 없습니다.</div>';
            return;
        }

        var base = getContextPath();
        grid.innerHTML = items.map(function (item) {
            var image = item.image || 'https://placehold.co/300x300/EAF7F2/2BAB82?text=상품';
            var link = item.link.indexOf('/') === 0 ? base + item.link : item.link;
            return ''
                + '<div class="wish-card" onclick="location.href=\'' + link + '\'">'
                + '  <div class="wish-thumb-wrap">'
                + '    <img class="wish-thumb" src="' + image + '" alt="" onerror="this.src=\'https://placehold.co/300x300/EAF7F2/2BAB82?text=상품\'">'
                + '    <button type="button" class="wish-heart wish-btn" data-wish-id="' + item.id + '" aria-label="찜 해제"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>'
                + '  </div>'
                + '  <div class="wish-body">'
                + '    <div class="w-name">' + item.title + '</div>'
                + '    <div><span class="w-price">' + item.price + '</span></div>'
                + '  </div>'
                + '</div>';
        }).join('');

        bindButtons(grid);
    }

    document.addEventListener('DOMContentLoaded', function () {
        bindButtons(document);
        renderWishlistPage();
    });

    document.addEventListener('petcare:wishlist-changed', function () {
        renderWishlistPage();
    });

    window.PetcareWishlist = {
        bind: bindButtons,
        toggle: toggle,
        render: renderWishlistPage,
        isActive: function (id) {
            return !!readList()[id];
        }
    };
})();
