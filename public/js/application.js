$(function() {
  _.templateSettings = {interpolate: /\{\{(.+?)\}\}/g}
  var links = JSON.parse(localStorage.getItem('links'));
  if (links === null) {
    links = [];
  } else {
    $('#old-links-text').show();
    $('#clear').show();
    _.each(links, function(link) {
      $('.old-links').prepend(_.template($('#link-template').html(), link));
    });
  }

  function add_link(link) {
    $('.old-links').prepend(_.template($('#link-template').html(), link));
    links.push(link);
    localStorage.setItem('links', JSON.stringify(links));
    $('#old-links-text').show();
    $('#clear').show();
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

  $('#clear').click(function() {
    $('#old-links-text').hide();
    $('#clear').hide();
    $('.old-links').html('');
    localStorage.setItem('links', null);
  });
});
