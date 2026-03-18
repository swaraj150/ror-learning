class TaskSorter
  SORTABLE_FIELDS = {
    "created_at" =>"tasks.created_at",
    "updated_at" =>"tasks.updated_at",
    "due_date" =>"tasks.due_date",
    "priority" =>"tasks.priority"
  }

  VALID_DIRECTIONS = [ "asc", "desc" ].freeze
  DEFAULT_SORT = [
    { field: "priority",   dir: "desc" },  # high(2) → medium(1) → low(0)
    { field: "due_date",   dir: "asc"  },  # earliest due first
    { field: "created_at", dir: "desc" }   # newest first as tiebreaker
  ].freeze

  def initialize(scope, params)
    @scope  = scope
    @params = params
  end

  def parse_sorts
    fields = @params[:sort_by].to_s.split(",").map(&:strip)
    directions = @params[:sort_dir].to_s.split(",").map(&:strip)

    fields.each_with_index.filter_map do |field, i|
      next unless SORTABLE_FIELDS.key?(field)

      dir = VALID_DIRECTIONS.include?(directions[i]) ? directions[i] : "desc"

      { field: field, dir: dir }
    end
  end

  def apply
    sorts = parse_sorts
    sorts = DEFAULT_SORT if sorts.empty?
    sorts.each do |sort|
      column = SORTABLE_FIELDS[sort[:field]]
      direction = sort[:dir]

      null_handling = direction == "asc" ? "NULLS LAST" : "NULLS FIRST"

      @scope = @scope.order(Arel.sql("#{column} #{direction.upcase} #{null_handling}"))
    end
    @scope
  end
end
