$( document ).on('turbolinks:load', function(){
    $('.destroy_check').change(function(e) {
        if(this.checked) {
            $("#destroy_button").removeClass('disabled');
        }
        else {
            $("#destroy_button").addClass('disabled');
        }
    });
});
