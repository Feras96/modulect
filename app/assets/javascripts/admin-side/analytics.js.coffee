$ ->
 $(document).on 'change', '#courses_analytics_select', (evt) ->
    $.ajax 'update_modules',
      type: 'GET'
      dataType: 'script'
      data: {
        course_id: $("#courses_analytics_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic Course select OK!")