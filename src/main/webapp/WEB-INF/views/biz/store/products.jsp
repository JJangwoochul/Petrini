<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="products" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 7/3, 사업자(쇼핑몰) 상품 관리 UI 구성 v2 — 카테고리/정가·할인가/상품설명/정렬 추가 --%>
<style>
  .prod-filter{display:flex;flex-wrap:wrap;align-items:center;gap:10px;padding:18px 20px}
  .prod-filter select,.prod-filter input{border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px;color:#333}
  .prod-filter input[type="text"]{width:220px}
  .prod-filter .btn-search{background:var(--biz-primary);color:#fff;border:none;border-radius:8px;padding:9px 18px;font-size:13px;font-weight:700;cursor:pointer}
  .prod-filter .btn-reset{background:#fff;border:1px solid var(--biz-border);border-radius:8px;padding:9px 16px;font-size:13px;font-weight:600;color:#555;cursor:pointer}
  .prod-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}
  .prod-table-head .right{display:flex;align-items:center;gap:8px}
  .prod-sort{border:1px solid var(--biz-border);border-radius:8px;padding:7px 10px;font-size:12px;color:#555}
  .prod-thumb{width:52px;height:52px;border-radius:6px;object-fit:cover;display:block;background:#F5F6F4}
  .prod-cat{display:inline-block;font-size:11px;color:#666;background:#F0F2EE;border-radius:20px;padding:2px 10px;margin-bottom:3px}
  .prod-price .orig{display:block;font-size:11px;color:#bbb;text-decoration:line-through}
  .prod-price .sale{font-weight:700;color:#1A1A2E}
  .prod-price .discount{color:#E24B4A;font-size:11px;font-weight:700;margin-right:4px}
  .prod-pagination{display:flex;align-items:center;justify-content:center;gap:6px;padding:16px 0 20px}
  .prod-pagination button{width:28px;height:28px;border:1px solid var(--biz-border);background:#fff;border-radius:6px;cursor:pointer;font-size:12px;color:#555}
  .prod-pagination button.active{background:var(--biz-primary);border-color:var(--biz-primary);color:#fff;font-weight:700}
  .prod-pagination button:disabled{opacity:.4;cursor:default}
  .prod-form-actions{display:flex;justify-content:center;gap:10px;margin-top:22px}
  .prod-form-actions .biz-btn-primary{min-width:180px}
  .prod-price-row{display:grid;grid-template-columns:250px 250px;column-gap:24px;}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">상품 관리</h1>
    <p class="biz-page-desc">판매할 상품을 등록·수정·삭제하세요.</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="prod-filter">
      <select id="fField">
        <option value="name">상품명</option>
      </select>
      <input type="text" id="fKeyword" placeholder="상품명을 입력하세요.">
      <span style="font-size:13px;color:#666;margin-left:6px">카테고리</span>
      <select id="fCategory">
        <option value="all">전체</option>
        <option value="food">사료</option>
        <option value="snack">간식</option>
        <option value="toy">장난감</option>
        <option value="hygiene">위생용품</option>
      </select>
      <span style="font-size:13px;color:#666;margin-left:6px">상태</span>
      <select id="fStatus">
        <option value="all">전체</option>
        <option value="sale">판매중</option>
        <option value="soldout">품절</option>
      </select>
      <button class="btn-search" onclick="applyFilter()">검색</button>
      <button class="btn-reset" onclick="resetFilter()">초기화</button>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="prod-table-head">
      <div class="biz-card-head" style="padding:20px 0 12px"><span>상품목록</span><small>총 <span id="totalCount">0</span>개</small></div>
      <div class="right">
        <select class="prod-sort" id="fSort" onchange="applySort()">
          <option value="latest">최신순</option>
          <option value="lowstock">재고 적은순</option>
          <option value="priceAsc">가격 낮은순</option>
          <option value="priceDesc">가격 높은순</option>
        </select>
        <button type="button" class="biz-btn-primary" onclick="openForm('add')">+ 상품등록</button>
      </div>
    </div>
    <table class="biz-table">
      <thead><tr><th>상품이미지</th><th>상품명 / 카테고리</th><th>판매가</th><th>재고</th><th>등록일</th><th>상태</th><th>관리</th></tr></thead>
      <tbody id="prodBody"></tbody>
    </table>
    <div class="prod-pagination" id="pagination"></div>
  </div>

  <div class="biz-card" id="formCard" style="display:none">
    <div class="biz-card-head"><span id="formTitle">상품등록</span></div>
    <form id="prodForm" style="padding:20px;max-width:640px">
      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>상품명<span class="req">*</span></label>
          <input type="text" id="pName" placeholder="상품명을 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>카테고리<span class="req">*</span></label>
          <select id="pCategory">
            <option value="food">사료</option>
            <option value="snack">간식</option>
            <option value="toy">장난감</option>
            <option value="hygiene">위생용품</option>
          </select>
        </div>

        <div class="biz-form-row">
        <label>정가<span class="req">*</span></label>
        <input type="number" id="pOrigPrice" placeholder="예: 35000">
        </div>

        <div class="biz-form-row">
        <label>판매가(할인가)<span class="req">*</span></label>
        <input type="number" id="pPrice" placeholder="예: 29900">
        </div>

        <div class="biz-form-row">
          <label>수량(재고)<span class="req">*</span></label>
          <input type="number" id="pStock" placeholder="재고 수량을 입력하세요">
        </div>
        
        <div class="biz-form-row">
          <label>용량/중량/사이즈</label>
          <input type="text" id="pSize" placeholder="예) 4kg, 200g, M 사이즈 등">
        </div>
        
        <div class="biz-form-row">
          <label>유통기한</label>
          <input type="text" id="pExpire" placeholder="예) 2027-06-30 (해당 없으면 비워두세요)">
        </div>
        <div class="biz-form-row">
          <label>상품설명</label>
          <textarea id="pDesc" placeholder="상품에 대한 설명을 입력하세요"></textarea>
        </div>

        <div class="biz-form-row">
          <label>상품이미지</label>
          <div style="display:flex;gap:10px;align-items:center">
            <input type="text" id="pImgName" placeholder="선택된 파일이 없습니다" readonly style="flex:1;background:#FAFBFA">
            <button type="button" class="biz-btn-ghost" style="white-space:nowrap" onclick="document.getElementById('pImgFile').click()">이미지 찾기</button>
            <input type="file" id="pImgFile" accept="image/*" style="display:none">
          </div>
          <div class="biz-form-image-box" id="imgPreviewBox" style="width:160px;height:160px;margin-top:10px;display:none">
            <img id="imgPreview" src="" alt="상품 이미지 미리보기">
          </div>
        </div>
      </div>

      <div class="prod-form-actions">
        <button type="button" class="biz-btn-ghost" onclick="closeForm()">취소</button>
        <button type="button" class="biz-btn-primary" id="submitBtn" onclick="submitProduct()">상품등록신청</button>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var categoryLabel = { food:'사료', snack:'간식', toy:'장난감', hygiene:'위생용품' };
  var statusLabel = { sale:'판매중', soldout:'품절' };
  var statusBadgeClass = { sale:'bs-done', soldout:'bs-cancel' };

  var products = [
    { id:1, name:'로얄캐닌 인도어 사료', category:'food', origPrice:35000, price:29900, stock:32, status:'sale', size:'4kg', expire:'2027-03-31', desc:'실내 생활 반려묘를 위한 저칼로리 사료입니다.', regDate:'2026-06-20', img:'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=200&q=80' },
    { id:2, name:'수제 닭가슴살 져키', category:'snack', origPrice:8500, price:8500, stock:0, status:'soldout', size:'200g', expire:'2026-12-31', desc:'국내산 닭가슴살로 만든 무첨가 수제 간식입니다.', regDate:'2026-06-15', img:'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=200&q=80' },
    { id:3, name:'노즈워크 매트 오렌지', category:'toy', origPrice:22000, price:18500, stock:14, status:'sale', size:'L 사이즈', expire:'', desc:'후각 발달과 스트레스 해소에 좋은 노즈워크 매트입니다.', regDate:'2026-06-10', img:'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=200&q=80' },
    { id:4, name:'H형 하네스 블루', category:'hygiene', origPrice:25000, price:22000, stock:9, status:'sale', size:'M 사이즈', expire:'', desc:'가슴 압박이 적은 편안한 착용감의 하네스입니다.', regDate:'2026-06-05', img:'https://images.unsplash.com/photo-1601758125946-6ac8acf9758f?w=200&q=80' }
  ];

  var filtered = products.slice();
  var page = 1;
  var pageSize = 3;
  var editingId = null;
  var previewSrc = '';

  function fmtWon(n){ return n.toLocaleString('ko-KR') + '원'; }

  function applyFilter() {
    var keyword = document.getElementById('fKeyword').value.trim();
    var category = document.getElementById('fCategory').value;
    var status = document.getElementById('fStatus').value;

    filtered = products.filter(function (p) {
      var matchName = !keyword || p.name.indexOf(keyword) !== -1;
      var matchCategory = category === 'all' || p.category === category;
      var matchStatus = status === 'all' || p.status === status;
      return matchName && matchCategory && matchStatus;
    });
    page = 1;
    applySort();
  }

  function resetFilter() {
    document.getElementById('fKeyword').value = '';
    document.getElementById('fCategory').value = 'all';
    document.getElementById('fStatus').value = 'all';
    document.getElementById('fSort').value = 'latest';
    filtered = products.slice();
    page = 1;
    render();
  }

  function applySort() {
    var sort = document.getElementById('fSort').value;
    if (sort === 'latest') filtered.sort(function (a, b) { return b.regDate.localeCompare(a.regDate); });
    else if (sort === 'lowstock') filtered.sort(function (a, b) { return a.stock - b.stock; });
    else if (sort === 'priceAsc') filtered.sort(function (a, b) { return a.price - b.price; });
    else if (sort === 'priceDesc') filtered.sort(function (a, b) { return b.price - a.price; });
    render();
  }

  function deleteProduct(id) {
    if (!confirm('선택한 상품을 삭제하시겠습니까?')) return;
    products = products.filter(function (p) { return p.id !== id; });
    filtered = filtered.filter(function (p) { return p.id !== id; });
    render();
    showToast('상품이 삭제되었습니다.');
  }

  function openForm(mode, id) {
    editingId = null;
    previewSrc = '';
    document.getElementById('prodForm').reset();
    document.getElementById('imgPreviewBox').style.display = 'none';

    if (mode === 'edit') {
      var p = products.find(function (x) { return x.id === id; });
      if (!p) return;
      editingId = id;
      document.getElementById('formTitle').textContent = '상품수정';
      document.getElementById('submitBtn').textContent = '수정완료';
      document.getElementById('pName').value      = p.name;
      document.getElementById('pCategory').value  = p.category;
      document.getElementById('pOrigPrice').value = p.origPrice;
      document.getElementById('pPrice').value     = p.price;
      document.getElementById('pStock').value     = p.stock;
      document.getElementById('pSize').value      = p.size;
      document.getElementById('pExpire').value    = p.expire;
      document.getElementById('pDesc').value      = p.desc;
      previewSrc = p.img;
      document.getElementById('pImgName').value = '기존 이미지 사용중';
      document.getElementById('imgPreview').src = previewSrc;
      document.getElementById('imgPreviewBox').style.display = 'block';
    } else {
      document.getElementById('formTitle').textContent = '상품등록';
      document.getElementById('submitBtn').textContent = '상품등록신청';
    }

    document.getElementById('formCard').style.display = 'block';
    document.getElementById('formCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function closeForm() {
    document.getElementById('formCard').style.display = 'none';
  }

  document.getElementById('pImgFile').addEventListener('change', function (e) {
    var file = e.target.files[0];
    if (!file) return;
    document.getElementById('pImgName').value = file.name;
    previewSrc = URL.createObjectURL(file);
    document.getElementById('imgPreview').src = previewSrc;
    document.getElementById('imgPreviewBox').style.display = 'block';
  });

/*사업자(상점) 숫자 마이너스 제한*/
  ['pStock', 'pOrigPrice', 'pPrice'].forEach(function (id) {
    var el = document.getElementById(id);
    el.addEventListener('input', function () {
      if (this.value.indexOf('-') !== -1) {
        this.value = this.value.replace(/-/g, '');
      }
    });
    el.addEventListener('keydown', function (e) {
      if (e.key === '-' || e.key === 'Subtract') {
        e.preventDefault();
      }
    });
  });

  function todayStr() {
    var d = new Date();
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  }

  function submitProduct() {
    var required = [
      { id: 'pName',      label: '상품명' },
      { id: 'pOrigPrice', label: '정가' },
      { id: 'pPrice',     label: '판매가(할인가)' },
      { id: 'pStock',     label: '수량(재고)' }
    ];
    for (var i = 0; i < required.length; i++) {
      var el = document.getElementById(required[i].id);
      if (!el.value.trim()) {
        alert(required[i].label + '을(를) 입력해주세요.');
        el.focus();
        return;
      }
    }

    var stockVal = Number(document.getElementById('pStock').value);
    var data = {
      name: document.getElementById('pName').value.trim(),
      category: document.getElementById('pCategory').value,
      origPrice: Number(document.getElementById('pOrigPrice').value),
      price: Number(document.getElementById('pPrice').value),
      stock: stockVal,
      status: stockVal > 0 ? 'sale' : 'soldout',
      size: document.getElementById('pSize').value.trim(),
      expire: document.getElementById('pExpire').value.trim(),
      desc: document.getElementById('pDesc').value.trim(),
      img: previewSrc || 'https://images.unsplash.com/photo-1601758124096-1f7e1b3b0c6e?w=200&q=80'
    };

    if (editingId) {
      var p = products.find(function (x) { return x.id === editingId; });
      Object.assign(p, data);
      showToast('상품 정보가 수정되었습니다.');
    } else {
      data.id = products.length ? Math.max.apply(null, products.map(function (x) { return x.id; })) + 1 : 1;
      data.regDate = todayStr();
      products.push(data);
      showToast('상품 등록 신청이 완료되었습니다.');
    }

    filtered = products.slice();
    closeForm();
    applySort();
  }

  function showToast(msg) {
    document.getElementById('saveToastMsg').textContent = msg;
    var toast = document.getElementById('saveToast');
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2000);
  }

  function render() {
    document.getElementById('totalCount').textContent = filtered.length;

    var totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
    if (page > totalPages) page = totalPages;
    var pageItems = filtered.slice((page - 1) * pageSize, page * pageSize);

    var body = document.getElementById('prodBody');
    body.innerHTML = '';
    if (pageItems.length === 0) {
      body.innerHTML = '<tr><td colspan="7" style="text-align:center;color:#999;padding:24px 0">등록된 상품이 없습니다.</td></tr>';
    } else {
      pageItems.forEach(function (p) {
        var discountRate = p.origPrice > p.price ? Math.round((1 - p.price / p.origPrice) * 100) : 0;
        var priceHtml = '<div class="prod-price">';
        if (discountRate > 0) {
          priceHtml += '<span class="orig">' + fmtWon(p.origPrice) + '</span>';
          priceHtml += '<span class="discount">' + discountRate + '%</span><span class="sale">' + fmtWon(p.price) + '</span>';
        } else {
          priceHtml += '<span class="sale">' + fmtWon(p.price) + '</span>';
        }
        priceHtml += '</div>';

        var tr = document.createElement('tr');
        tr.innerHTML =
          '<td><img class="prod-thumb" src="' + p.img + '" alt="' + p.name + '"></td>' +
          '<td><span class="prod-cat">' + categoryLabel[p.category] + '</span><br>' + p.name + '</td>' +
          '<td>' + priceHtml + '</td>' +
          '<td>' + p.stock + '개</td>' +
          '<td>' + p.regDate + '</td>' +
          '<td><span class="bs-badge ' + statusBadgeClass[p.status] + '">' + statusLabel[p.status] + '</span></td>' +
          '<td>' +
            '<button class="biz-btn" onclick="openForm(\'edit\',' + p.id + ')">수정</button> ' +
            '<button class="biz-btn danger" onclick="deleteProduct(' + p.id + ')">삭제</button>' +
          '</td>';
        body.appendChild(tr);
      });
    }

    var pg = document.getElementById('pagination');
    pg.innerHTML = '';
    var prev = document.createElement('button');
    prev.textContent = '<';
    prev.disabled = page <= 1;
    prev.onclick = function () { page--; render(); };
    pg.appendChild(prev);
    for (var i = 1; i <= totalPages; i++) {
      var b = document.createElement('button');
      b.textContent = i;
      if (i === page) b.className = 'active';
      (function (n) { b.onclick = function () { page = n; render(); }; })(i);
      pg.appendChild(b);
    }
    var next = document.createElement('button');
    next.textContent = '>';
    next.disabled = page >= totalPages;
    next.onclick = function () { page++; render(); };
    pg.appendChild(next);
  }

  applySort();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>