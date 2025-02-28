import "@hotwired/turbo-rails";
import "controllers";
import jquery from "jquery";
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;
console.log("Bootstrap module:", bootstrap);

window.jQuery = jquery;
window.$ = jquery;

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

// turbo:load イベントで全初期化関数を呼び出す
document.addEventListener('turbo:load', function () {
    initClickableRows();
    initBlockTypeSelect();
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-part-id', 'add-part-btn');
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-block-id', 'add-block-btn');
    initBlockSearch();
    initPartSelection();
});