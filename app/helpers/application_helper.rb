module ApplicationHelper

  # 戻るアンカーの生成
  def link_back(pipe = false)
    if session[:return_path].blank?
      ""
    else
      while session[:return_path].last == request.fullpath
        session[:return_path].pop
      end
      if session[:return_path].present?
        path = "<a href=\"/back?callback=" + u(session[:return_path].last) + "\">戻る</a>"
        raw(pipe ? "| " + path : path)
      else
        ""
      end
    end
  end

  # 日付時刻フォーマット
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
