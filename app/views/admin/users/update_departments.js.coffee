$("#departments_select").empty().append("<option> </option>").append("<%= escape_javascript(render(:partial => @departments)) %>")
$("#courses_select").empty()