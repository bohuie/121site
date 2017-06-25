$ ->
  $(document).on 'change', '#game_course_id', (evt) ->
    $.ajax "practices/update_practice_topics",
      type: "GET"
      dataType: "script"
      data: {
        course_id: $("#game_course_id option:selected").val()
      }

      error: (jqXHR, textStatus, errorThrown) ->
        console.log($("#game_course_id option:selected").val())
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic course select OK!")