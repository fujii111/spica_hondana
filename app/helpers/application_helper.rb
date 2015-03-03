module ApplicationHelper
  def format_datetime(datetime, type = :datetime)
    return "" unless datetime
    case type
    when :datetime
      format = "%Y年%m月%d日 %H:%M"
    when :date
      format = "%Y年%m月%d日"
    when :time
      format = "%H:%M"
    end
    datetime.strftime(format)
  end
end
