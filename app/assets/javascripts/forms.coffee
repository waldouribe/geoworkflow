jQuery ->
  $('form').on 'click', '.add-fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '.remove-fieldset', (event) ->
    $(this).closest('.fieldset').remove()
    event.preventDefault()
