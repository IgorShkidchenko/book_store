$( document ).on('turbolinks:load', function(){
    $(function() {
        setInterval(function(){
            $('.alert').slideUp(200);
        }, 10000);
    });
});
