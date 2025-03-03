import "@hotwired/turbo-rails";
import "controllers";
import jquery from "jquery";
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;
console.log("Bootstrap module:", bootstrap);

window.jQuery = jquery;
window.$ = jquery;

document.addEventListener('turbo:load', function () {
    initClickableRows();
    initBlockTypeSelect();
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-part-id', 'add-part-btn');
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-block-id', 'add-block-btn');
    initBlockSearch();
    initPartSelectionPagination();
});

// 初期化関数群
function initClickableRows() {
    const clickableRows = document.querySelectorAll('.clickable-row');
    clickableRows.forEach(row => {
        row.addEventListener('click', () => {
            window.location.href = row.dataset.href;
        });
    });
}

function initBlockTypeSelect() {
    const typeSelect = document.querySelector('#block_type_id');
    const blockNumberField = document.querySelector('#block_block_number');
    const typeNumberPrefix = document.querySelector('#type_number_prefix');
    if (typeSelect && blockNumberField && typeNumberPrefix) {
        typeSelect.addEventListener('change', () => {
            const selectedType = typeSelect.options[typeSelect.selectedIndex].text.split('-')[0];
            typeNumberPrefix.textContent = `${selectedType}-`;
            blockNumberField.value = '';
        });
    }
}

function initCustomSelect(inputId, listId, selectedIdInputId, addBtnId) {
    const input = document.querySelector(`#${inputId}`);
    const list = document.querySelector(`#${listId}`);
    const selectedIdInput = document.querySelector(`#${selectedIdInputId}`);
    const addBtn = document.querySelector(`#${addBtnId}`);
    if (!input || !list || !selectedIdInput || !addBtn) return;
    const options = Array.from(list.querySelectorAll('li'));
    input.addEventListener('input', function () {
        const filter = input.value.toLowerCase();
        options.forEach(option => {
            const text = option.textContent.toLowerCase();
            option.style.display = text.includes(filter) ? '' : 'none';
        });
    });
    list.addEventListener('click', function (e) {
        if (e.target.tagName === 'LI') {
            options.forEach(opt => opt.classList.remove('active'));
            e.target.classList.add('active');
            input.value = e.target.textContent;
            selectedIdInput.value = e.target.dataset.value;
            addBtn.disabled = false;
        }
    });
    input.addEventListener('focus', () => list.style.display = 'block');
    document.addEventListener('click', (e) => {
        if (!input.contains(e.target) && !list.contains(e.target)) {
            list.style.display = 'none';
        }
    });
}

function initBlockSearch() {
    const blockSearch = document.getElementById('block-search');
    const blockList = document.getElementById('block-list');
    const selectedCount = document.getElementById('selected-count');
    const compareButton = document.getElementById('compare-button');
    if (blockSearch && blockList) {
        blockSearch.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const blocks = blockList.querySelectorAll('label');
            blocks.forEach(block => {
                const text = block.textContent.toLowerCase();
                block.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
        blockList.addEventListener('change', function () {
            const checkedBoxes = blockList.querySelectorAll('input[type="checkbox"]:checked');
            if (selectedCount) selectedCount.textContent = checkedBoxes.length;
            if (compareButton) compareButton.disabled = checkedBoxes.length < 2;
        });
    }
}

function initPartSelection() {
    // 「Add Existing Part」セクションのテーブル形式選択用
    const partSearch = document.getElementById('part-search');
    const partsTable = document.getElementById('parts-selection-table');
    const selectedPartSpan = document.getElementById('selected-part');
    const addPartBtn = document.getElementById('add-part-btn');
    if (partSearch && partsTable) {
        partSearch.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const rows = partsTable.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const rowText = row.textContent.toLowerCase();
                row.style.display = rowText.includes(searchTerm) ? '' : 'none';
            });
        });
        const radioButtons = partsTable.querySelectorAll('input[type="radio"]');
        radioButtons.forEach(radio => {
            radio.addEventListener('change', function () {
                if (this.checked) {
                    const row = this.closest('tr');
                    const partNumber = row.cells[1].textContent.trim();
                    const partName = row.cells[2].textContent.trim();
                    selectedPartSpan.textContent = `Selected: ${partNumber} - ${partName}`;
                    addPartBtn.disabled = false;
                }
            });
        });
    }
}

document.addEventListener('turbo:load', function () {
    const searchInput = document.getElementById('existing-part-search');
    const partsTable = document.getElementById('existing-parts-table');
    if (searchInput && partsTable) {
        searchInput.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const rows = partsTable.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const rowText = row.textContent.toLowerCase();
                row.style.display = rowText.includes(searchTerm) ? '' : 'none';
            });
        });
    }
});

function initPartSelectionPagination() {
    const searchInput = document.getElementById('existing-part-search');
    const table = document.getElementById('existing-parts-table');
    if (!table) return;

    const tbody = table.querySelector('tbody');
    const allRows = Array.from(tbody.querySelectorAll('tr'));
    let filteredRows = allRows.slice(); // 初期状態は全件
    const rowsPerPage = 10; // 1ページあたりの行数
    let currentPage = 1;

    function renderTable() {
        // 全行を一旦非表示
        allRows.forEach(row => row.style.display = 'none');

        const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
        // 現在のページに属する行のみ表示
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        filteredRows.slice(start, end).forEach(row => {
            row.style.display = '';
        });
        renderPaginationControls(totalPages);
    }

    function renderPaginationControls(totalPages) {
        let paginationDiv = document.getElementById('table-pagination');
        if (!paginationDiv) {
            paginationDiv = document.createElement('div');
            paginationDiv.id = 'table-pagination';
            paginationDiv.className = 'mt-3';
            // ページネーションをテーブルの下に挿入
            table.parentNode.insertBefore(paginationDiv, table.nextSibling);
        }
        paginationDiv.innerHTML = '';

        // 前へボタン
        const prevButton = document.createElement('button');
        prevButton.className = 'btn btn-sm btn-outline-secondary me-1';
        prevButton.textContent = 'Previous';
        prevButton.disabled = currentPage === 1;
        prevButton.addEventListener('click', () => {
            if (currentPage > 1) {
                currentPage--;
                renderTable();
            }
        });
        paginationDiv.appendChild(prevButton);

        // ページ番号ボタン
        for (let i = 1; i <= totalPages; i++) {
            const pageButton = document.createElement('button');
            pageButton.className = 'btn btn-sm btn-outline-secondary me-1';
            pageButton.textContent = i;
            if (i === currentPage) {
                pageButton.classList.add('active');
            }
            pageButton.addEventListener('click', () => {
                currentPage = i;
                renderTable();
            });
            paginationDiv.appendChild(pageButton);
        }

        // 次へボタン
        const nextButton = document.createElement('button');
        nextButton.className = 'btn btn-sm btn-outline-secondary';
        nextButton.textContent = 'Next';
        nextButton.disabled = currentPage === totalPages || totalPages === 0;
        nextButton.addEventListener('click', () => {
            if (currentPage < totalPages) {
                currentPage++;
                renderTable();
            }
        });
        paginationDiv.appendChild(nextButton);
    }

    // 検索機能：入力値に応じてフィルタリングし、ページ番号をリセットして再描画
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            filteredRows = allRows.filter(row => row.textContent.toLowerCase().includes(searchTerm));
            currentPage = 1; // 検索開始時は先頭ページにリセット
            renderTable();
        });
    }

    // 初期表示
    renderTable();
}

document.addEventListener('turbo:load', function () {
    // 既存の初期化処理
    initClickableRows();
    initBlockTypeSelect();
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-part-id', 'add-part-btn');
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-block-id', 'add-block-btn');
    initBlockSearch();

    // Add Existing Part テーブルの検索
    const existingSearch = document.getElementById('existing-part-search');
    const existingTable = document.getElementById('existing-parts-table');
    if (existingSearch && existingTable) {
        existingSearch.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const rows = existingTable.querySelectorAll('tbody tr');
            rows.forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(searchTerm) ? '' : 'none';
            });
        });
    }

    // Add Related Part テーブルの検索
    const relatedSearch = document.getElementById('related-part-search');
    const relatedTable = document.getElementById('related-parts-table');
    if (relatedSearch && relatedTable) {
        relatedSearch.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const rows = relatedTable.querySelectorAll('tbody tr');
            rows.forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(searchTerm) ? '' : 'none';
            });
        });
    }
});

function initRelatedPartPagination() {
    const searchInput = document.getElementById('related-part-search');
    const table = document.getElementById('related-parts-table');
    if (!table) return;

    const tbody = table.querySelector('tbody');
    const allRows = Array.from(tbody.querySelectorAll('tr'));
    let filteredRows = allRows.slice(); // 初期状態は全件表示
    const rowsPerPage = 10;  // 1ページあたりの行数
    let currentPage = 1;

    function renderTable() {
        // 全行を一旦非表示にする
        allRows.forEach(row => row.style.display = 'none');

        const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        filteredRows.slice(start, end).forEach(row => row.style.display = '');
        renderPaginationControls(totalPages);
    }

    function renderPaginationControls(totalPages) {
        let paginationDiv = document.getElementById('related-pagination');
        if (!paginationDiv) {
            paginationDiv = document.createElement('div');
            paginationDiv.id = 'related-pagination';
            paginationDiv.className = 'mt-3 d-flex justify-content-center';
            table.parentNode.insertBefore(paginationDiv, table.nextSibling);
        }
        paginationDiv.innerHTML = '';

        // 前へボタン
        const prevButton = document.createElement('button');
        prevButton.className = 'btn btn-sm btn-outline-secondary me-1';
        prevButton.textContent = 'Previous';
        prevButton.disabled = currentPage === 1;
        prevButton.addEventListener('click', () => {
            if (currentPage > 1) {
                currentPage--;
                renderTable();
            }
        });
        paginationDiv.appendChild(prevButton);

        // ページ番号ボタン
        for (let i = 1; i <= totalPages; i++) {
            const pageButton = document.createElement('button');
            pageButton.className = 'btn btn-sm btn-outline-secondary me-1';
            pageButton.textContent = i;
            if (i === currentPage) {
                pageButton.classList.add('active');
            }
            pageButton.addEventListener('click', () => {
                currentPage = i;
                renderTable();
            });
            paginationDiv.appendChild(pageButton);
        }

        // 次へボタン
        const nextButton = document.createElement('button');
        nextButton.className = 'btn btn-sm btn-outline-secondary';
        nextButton.textContent = 'Next';
        nextButton.disabled = currentPage === totalPages || totalPages === 0;
        nextButton.addEventListener('click', () => {
            if (currentPage < totalPages) {
                currentPage++;
                renderTable();
            }
        });
        paginationDiv.appendChild(nextButton);
    }

    if (searchInput) {
        searchInput.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            filteredRows = allRows.filter(row => row.textContent.toLowerCase().includes(searchTerm));
            currentPage = 1;  // 検索開始時は先頭ページにリセット
            renderTable();
        });
    }

    // 初期表示
    renderTable();
}

document.addEventListener('turbo:load', function () {
    // 既存の初期化処理
    initClickableRows();
    initBlockTypeSelect();
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-part-id', 'add-part-btn');
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-block-id', 'add-block-btn');
    initBlockSearch();

    // Add Related Part テーブルの検索機能
    const relatedSearch = document.getElementById('related-part-search');
    const relatedTable = document.getElementById('related-parts-table');
    if (relatedSearch && relatedTable) {
        relatedSearch.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const rows = relatedTable.querySelectorAll('tbody tr');
            rows.forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(searchTerm) ? '' : 'none';
            });
        });
    }

    // クライアントサイドのページネーション (Add Related Part)
    function initRelatedPartPagination() {
        const searchInput = document.getElementById('related-part-search');
        const table = document.getElementById('related-parts-table');
        if (!table) return;

        const tbody = table.querySelector('tbody');
        const allRows = Array.from(tbody.querySelectorAll('tr'));
        let filteredRows = allRows.slice();
        const rowsPerPage = 10; // 表示件数
        let currentPage = 1;

        function renderTable() {
            allRows.forEach(row => row.style.display = 'none');
            const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
            const start = (currentPage - 1) * rowsPerPage;
            const end = start + rowsPerPage;
            filteredRows.slice(start, end).forEach(row => row.style.display = '');
            renderPaginationControls(totalPages);
        }

        function renderPaginationControls(totalPages) {
            let paginationDiv = document.getElementById('related-pagination');
            if (!paginationDiv) {
                paginationDiv = document.createElement('div');
                paginationDiv.id = 'related-pagination';
                paginationDiv.className = 'mt-3 d-flex justify-content-center';
                table.parentNode.insertBefore(paginationDiv, table.nextSibling);
            }
            paginationDiv.innerHTML = '';

            // 前へボタン
            const prevButton = document.createElement('button');
            prevButton.className = 'btn btn-sm btn-outline-secondary me-1';
            prevButton.textContent = 'Previous';
            prevButton.disabled = currentPage === 1;
            prevButton.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    renderTable();
                }
            });
            paginationDiv.appendChild(prevButton);

            // ページ番号ボタン
            for (let i = 1; i <= totalPages; i++) {
                const pageButton = document.createElement('button');
                pageButton.className = 'btn btn-sm btn-outline-secondary me-1';
                pageButton.textContent = i;
                if (i === currentPage) {
                    pageButton.classList.add('active');
                }
                pageButton.addEventListener('click', () => {
                    currentPage = i;
                    renderTable();
                });
                paginationDiv.appendChild(pageButton);
            }

            // 次へボタン
            const nextButton = document.createElement('button');
            nextButton.className = 'btn btn-sm btn-outline-secondary';
            nextButton.textContent = 'Next';
            nextButton.disabled = currentPage === totalPages || totalPages === 0;
            nextButton.addEventListener('click', () => {
                if (currentPage < totalPages) {
                    currentPage++;
                    renderTable();
                }
            });
            paginationDiv.appendChild(nextButton);
        }

        if (searchInput) {
            searchInput.addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();
                filteredRows = allRows.filter(row => row.textContent.toLowerCase().includes(searchTerm));
                currentPage = 1;
                renderTable();
            });
        }

        renderTable();
    }

    initRelatedPartPagination();
});


// 既存の turbo:load イベントの中で呼び出す例
document.addEventListener('turbo:load', function () {
    initClickableRows();
    initBlockTypeSelect();
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-part-id', 'add-part-btn');
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-block-id', 'add-block-btn');
    initBlockSearch();
    // 追加：関連パーツ用の検索＆ページネーション
    initRelatedPartPagination();
});
