$( document ).on('turbolinks:load', function(){
    $('.checkbox-class').change(function(e) {
        if(this.checked) {
            $('.shipping_form').slideUp(700);
        }
        else {
            $('.shipping_form').slideDown(700);
        }
    });

    $('.general-form-help').click(function(){
        $('.cvv_hint').toggle(800);
    });
});
