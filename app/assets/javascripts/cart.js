$( document ).on('turbolinks:load', function(){
    var quantitiy=0;

    $('.plus').click(function(e){
      e.preventDefault();
      var quantity = parseInt($('#quantity').val());
        $('#quantity').val(quantity + 1);
    });

    $('.minus').click(function(e){
      e.preventDefault();
      var quantity = parseInt($('#quantity').val());
        if(quantity>1){
          $('#quantity').val(quantity - 1);
        }
    });

    $(function() {
        setInterval(function(){
            $('.alert').slideUp(200);
        }, 10000);
    });
});

function cart_shake() {
    var div = document.getElementsByClassName('cart_link');
    var interval = 100;
    var distance = 10;
    var times = 4;

    $(div).css('position', 'relative');

    for (var iter = 0; iter < (times + 1) ; iter++) {
        $(div).animate({
            left: ((iter % 2 == 0 ? distance : distance * -1))
        }, interval);
    }
    $(div).animate({ left: 0 }, interval);
}
