jQuery ->
  $('form').on 'click', '.add-fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '.remove-fieldset', (event) ->
    $(this).closest('.fieldset').remove()
    event.preventDefault()

  $('.close-task-form').on 'click', (event) ->
    fullScreen()
    event.preventDefault()

  fullScreen = () ->
    $('.task-form').addClass('hidden')
    $('#my-process-left-bar').addClass('hidden')

    $('#my-process-left-bar').removeClass('col-sm-4')
    $('#my-process-left-bar').addClass('col-sm-0')
    $('#my-process-left-bar').addClass('hidden')

    $('#my-process-content').removeClass('col-sm-8')
    $('#my-process-content').addClass('col-sm-12')
