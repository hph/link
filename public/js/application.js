$(function() {
  _.templateSettings = {interpolate: /\{\{(.+?)\}\}/g}
  var links = JSON.parse(localStorage.getItem('links'));
  if (links === null) {
    links = [];
  } else {
    $('#toggle-links').show();
    _.each(links, function(link) {
      $('.old-links').prepend(_.template($('#link-template').html(), link));
    });
  }

  function add_link(link) {
    $('.old-links').prepend(_.template($('#link-template').html(), link));
    links.push(link);
    localStorage.setItem('links', JSON.stringify(links));
    $('#toggle-links').show();
  }

  function post() {
    if ($('#long-url').val().length === 0) {
      return alert('The text field is empty...');
    }
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
        add_link(response.link);
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

  $('#toggle-links').click(function() {
    var button = $('#toggle-links');
    var links = $('.old-links');
    if (button.html() === 'Show old links') {
      button.html('Hide old links');
      links.show();
    } else {
      button.html('Show old links');
      links.hide();
    }
  });
});
