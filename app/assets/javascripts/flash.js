$( document ).on('turbolinks:load', function(){
    $(function() {
        setTimeout(function(){
            $('.alert').slideUp(800);
        }, 15000);
    });
});
