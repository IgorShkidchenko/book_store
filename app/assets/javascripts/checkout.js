$( document ).on('turbolinks:load', function(){
    $('.clone_check').change(function(e) {
        if(this.checked) {
            $('#shipping-form').slideUp(700);
        }
        else {
            $('#shipping-form').slideDown(700);
        }
    });

    if (document.getElementById('order_clone_address')) {
        if (document.getElementById('order_clone_address').value == 'true') {
            document.getElementById('shipping_form').style.display = 'none'
        };
    };

    $('.general-form-help').click(function(){
        $('.cvv_hint').toggle(800);
    });
});
