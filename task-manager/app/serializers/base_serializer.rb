class BaseSerializer < ActiveModel::Serializer
  def formatted_date(date)
    date&.strftime("%Y-%m-%d")
  end

  def datetime_iso(datetime)
    datetime&.iso8601
  end
end
