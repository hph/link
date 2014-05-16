$(function() {
  function post() {
    $.ajax({
      type: 'POST',
      url: '/new',
      data: {url: $('#long-url').val()},
      success: function(response) {
        var url = window.location.host + '/' + response.link.uid;
        $('#short-url').val(url).show().select();
        if (['MacIntel', 'iPhone', 'iPod'].indexOf(navigator.platform) > -1) {
          var key = 'Command';
        } else {
          var key = 'Control';
        }
        $('#info-text').html('Press ' + key + '-C to copy the URL');
      },
      dataType: 'json'
    });
  };

  $('#submit').click(function() {
    post();
  });

  $('#long-url').keypress(function(event) {
    if (event.keyCode === 13) {
      post();
    }
  });
});
