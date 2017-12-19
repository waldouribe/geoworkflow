//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require vis.min
//= require forms
//= require waitings
//= require maps_searchbox
//= require my_process

var showTaskForm = function (taskId) {
  $('.task-form').addClass('hidden');
  $('#my-process-left-bar').removeClass('hidden');

  $('#my-process-left-bar').removeClass('col-sm-0');
  $('#my-process-left-bar').addClass('col-sm-4');

  $('#my-process-content').removeClass('col-sm-12');
  $('#my-process-content').addClass('col-sm-8');

  $("#task-" + taskId + "-form").removeClass('hidden');
}