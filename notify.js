function notify(msg,speed,fadeSpeed,type){

   $('.notify').remove();

   if (typeof fade != "undefined"){
   clearTimeout(fade);
   }
   $('body').append('<div class="notify '+type+'" style="display:none;position:fixed;"><p>'+msg+'</p></div>');

   notifyHeight = $('.notify').outerHeight();

   $('.notify').css('top',-notifyHeight).animate({top:10,opacity:'toggle'},speed);

   fade = setTimeout(function(){

      $('.notify').animate({top:notifyHeight+10,opacity:'toggle'}, speed);

   }, fadeSpeed);
}
