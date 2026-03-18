class TaskFilter
  VALID_STATUSES = [ "todo", "in_progress", "completed" ].freeze
  VALID_PRIORITY = [ "low", "medium", "high" ].freeze

  def initialize(scope, param)
    @scope = scope
    @param = param
  end

  def apply
    filter_by_status
    filter_by_priority
    search_by_title
    @scope
  end

  def filter_by_status
    lowercased_statuses = Array(@param[:status]).map(&:downcase)
    statuses = Array(lowercased_statuses.select { |s| VALID_STATUSES.include?(s) })
    @scope = @scope.where(status: statuses) if statuses.any?
  end

  def filter_by_priority
    lowercased_priorities = Array(@param[:priority]).map(&:downcase)
    priorities = Array(lowercased_priorities.select { |p| VALID_PRIORITY.include?(p) })
    @scope = @scope.where(priority: priorities) if priorities.any?
  end

  def search_by_title
    return if @param[:search].blank?

    value = "%#{sanitize_sql_like(@param[:search])}%"

    @scope = @scope.where(
      "title ILIKE :value",
      value: value
    )
  end

  private
  def sanitize_sql_like(str)
    # match any one of: %, _, or \ and prefix each of those with a backslash”
    str.gsub(/[%_\\]/) { |c| "\\#{c}" }
  end
end
