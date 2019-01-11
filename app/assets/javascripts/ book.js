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
});

function readMore() {
    var dots = document.getElementById("dots");
    var moreText = document.getElementById("more");
    var btnText = document.getElementById("myBtn");

    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "Read more";
        moreText.style.display = "none";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "Close";
        moreText.style.display = "inline";
    }
}
