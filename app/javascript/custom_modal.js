document.addEventListener('DOMContentLoaded', function() {
    var modalTrigger = document.querySelector('[data-bs-toggle="modal"]');
    if (modalTrigger) {
        modalTrigger.addEventListener('click', function() {
            var target = modalTrigger.getAttribute('data-bs-target');
            var modal = new bootstrap.Modal(document.querySelector(target));
            modal.show();
        });
    }
});