module ReportHelper

  def format_percentage(percent)
    "%.1f" % percent.round(1)
  end
end
