$ ->
  $('#posts_list').imagesLoaded ->
    $('#posts_list').masonry
      itemSelector: '.post-panel-group'
      isFitWidth: true
