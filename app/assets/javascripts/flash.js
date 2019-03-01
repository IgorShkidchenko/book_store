$( document ).on('turbolinks:load', function(){
    $(function() {
        setInterval(function(){
            $('.alert').slideUp(500);
        }, 20000);
    });
});
