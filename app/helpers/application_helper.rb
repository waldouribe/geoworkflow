# encoding: utf-8
module ApplicationHelper
  def datetime(date)
    if date
      date.strftime "%Y-%m-%d - %H:%M"
    else
      return '-'
    end
  end

  def date(date)
    if date
      date.strftime "%Y-%m-%d"
    else
      return '-'
    end
  end

  def to_timeline(tasks)
    tasks.order("assigned_start ASC").map do |task| {
        assigned_start: task.assigned_start,
        assigned_end: task.assigned_end,
        actual_start: task.actual_start,
        actual_end: task.actual_end,
        id: task.id,
        content: "#{task.name} <br/> Status: #{task.human_status} | Start: #{datetime task.actual_start} | End: #{datetime task.actual_end}".html_safe,
        visible_status: visible_status(task)
      }
    end
  end

  def visible_status(task)
    if !task.doable?(current_user)
      return 'blocked'
    else
      return task.status
    end
  end

  def task_locations(tasks)
    return tasks.map{|t| t.location }
  end
end
