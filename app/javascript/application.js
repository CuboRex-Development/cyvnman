// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap

import "./popper"
import "./bootstrap"
import "@hotwired/turbo-rails"
import "controllers"

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