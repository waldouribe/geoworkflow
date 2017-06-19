$(document).ready(function(){
  $('.work-to-do-item.doable').click(function(event){
    task_id = $(this).data('task-id');
    $("#edit-task-"+task_id).click();
  });
});
