# encoding: utf-8
module ApplicationHelper
  def datetime(date)
    date.strftime "%Y-%m-%d - %H:%M"
  end

  def date(date)
    date.strftime "%Y-%m-%d"
  end
end
