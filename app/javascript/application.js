import "@hotwired/turbo-rails"
import "controllers"
import jquery from "jquery"
// import select2 from "select2"

window.jQuery = jquery;
window.$ = jquery;

document.addEventListener('turbo:load', function() {
    const input = document.querySelector('#custom-select-input');
    const list = document.querySelector('#custom-select-list');
    const options = Array.from(list.querySelectorAll('li'));
    const selectedPartIdInput = document.querySelector('#selected-part-id');
    const addPartBtn = document.querySelector('#add-part-btn');

    input.addEventListener('input', function() {
        const filter = input.value.toLowerCase();
        options.forEach(option => {
            const text = option.textContent.toLowerCase();
            option.style.display = text.includes(filter) ? '' : 'none';
        });
    });

    list.addEventListener('click', function(e) {
        if (e.target.tagName === 'LI') {
            options.forEach(opt => opt.classList.remove('active'));
            e.target.classList.add('active');
            input.value = e.target.textContent;
            selectedPartIdInput.value = e.target.dataset.value;
            addPartBtn.disabled = false;
        }
    });

    input.addEventListener('focus', function() {
        list.style.display = 'block';
    });

    document.addEventListener('click', function(e) {
        if (!input.contains(e.target) && !list.contains(e.target)) {
            list.style.display = 'none';
        }
    });
});

document.addEventListener('turbo:load', () => {
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
});