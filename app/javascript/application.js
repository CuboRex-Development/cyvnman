// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import jquery from "jquery"
import "select2"

window.jQuery = jquery
window.$ = jquery

document.addEventListener("turbo:load", function() {
    $('.select2').select2({
        theme: 'bootstrap-5',
        width: '100%'
    });
});

document.addEventListener('turbolinks:load', () => {
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