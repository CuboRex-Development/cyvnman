import "@hotwired/turbo-rails"
import "controllers"
import jquery from "jquery"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap
console.log("Bootstrap module:", bootstrap)

window.jQuery = jquery;
window.$ = jquery;

document.addEventListener('turbo:load', () => {
    initClickableRows();
    initBlockTypeSelect();
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-part-id', 'add-part-btn');
    initCustomSelect('custom-select-input', 'custom-select-list', 'selected-block-id', 'add-block-btn');
    initBlockSearch();
});

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

    input.addEventListener('focus', function () {
        list.style.display = 'block';
    });

    document.addEventListener('click', function (e) {
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