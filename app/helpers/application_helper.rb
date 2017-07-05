# encoding: utf-8
module ApplicationHelper
  def datetime(date)
    date.strftime "%Y-%m-%d - %H:%M"
  end

  def date(date)
    date.strftime "%Y-%m-%d"
  end

  def to_timeline(tasks)
    tasks.order("assigned_start ASC").map do |task| {
        assigned_start: task.assigned_start,
        assigned_end: task.assigned_end,
        actual_start: task.actual_start,
        actual_end: task.actual_end,
        id: task.id,
        content: "#{task.name} #{task.waitings_to_s}",
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
