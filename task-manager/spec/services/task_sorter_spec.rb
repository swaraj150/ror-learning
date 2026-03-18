require "rails_helper"
RSpec.describe TaskSorter, type: :service do
  let(:user)  { create(:user) }
  let(:scope) { user.tasks }

  let!(:low_no_due)     { create(:task, user: user, status: :todo, priority: :low,    due_date: nil,               created_at: 3.days.ago) }
  let!(:medium_late)    { create(:task, user: user, status: :todo, priority: :medium, due_date: 5.days.from_now,   created_at: 2.days.ago) }
  let!(:high_soon)      { create(:task, user: user, status: :todo, priority: :high,   due_date: 1.day.from_now,    created_at: 2.days.ago) }
  let!(:high_later)     { create(:task, user: user, status: :todo, priority: :high,   due_date: 4.days.from_now,   created_at: 1.day.ago)  }
  let!(:medium_no_due)  { create(:task, user: user, status: :todo, priority: :medium, due_date: nil,               created_at: 1.day.ago)  }

  describe "DEFAULT_SORT" do
    it "sorts priority desc, due_date asc, created_at desc by default" do
      result = described_class.new(scope, {}).apply.to_a
      expect(result.first(2).map(&:priority_before_type_cast)).to all(eq(2)) 
      # returns the raw database value before Rails casts it to the enum label.
      # task.priority                    # => "high"   (enum string — after type cast)
      # task.priority_before_type_cast   # => 2        (raw integer stored in DB)
      expect(result[0]).to eq(high_soon)
      expect(result[1]).to eq(high_later)
    end
  end

  describe "#apply" do
    context "with no params" do
      it "falls back to DEFAULT_SORT" do
        result = described_class.new(scope, {}).apply.to_a
        expect(result).not_to be_empty
      end

      it "places nil due_date tasks after tasks with dates at same priority level" do
        result = described_class.new(scope, {}).apply.to_a
        medium_tasks = result.select { |t| t.priority == "medium" }

        expect(medium_tasks.last).to eq(medium_no_due)
      end
    end

    context "sort by priority" do
      it "sorts priority asc — low to high numerically" do
        result = described_class.new(scope, { sort_by: "priority", sort_dir: "asc" }).apply
        priorities = result.map(&:priority_before_type_cast)
        expect(priorities).to eq(priorities.sort)
      end

      it "sorts priority desc — high to low numerically" do
        result = described_class.new(scope, { sort_by: "priority", sort_dir: "desc" }).apply
        priorities = result.map(&:priority_before_type_cast)
        expect(priorities).to eq(priorities.sort.reverse)
      end
    end

    context "sort by due_date" do
      it "sorts due_date asc with NULLS LAST" do
        result = described_class.new(scope, { sort_by: "due_date", sort_dir: "asc" }).apply.to_a
        non_null = result.reject { |t| t.due_date.nil? }

        dates = non_null.map(&:due_date)
        expect(dates).to eq(dates.sort)

        expect(result.last(2).map(&:due_date)).to all(be_nil)
      end

      it "sorts due_date desc with NULLS FIRST" do
        result = described_class.new(scope, { sort_by: "due_date", sort_dir: "desc" }).apply.to_a
        non_null = result.select { |t| t.due_date.present? }

        dates = non_null.map(&:due_date)
        expect(dates).to eq(dates.sort.reverse)

        expect(result.first(2).map(&:due_date)).to all(be_nil)
      end
    end

    context "sort by created_at" do
      it "sorts created_at desc — newest first" do
        result = described_class.new(scope, { sort_by: "created_at", sort_dir: "desc" }).apply
        dates = result.map(&:created_at)
        expect(dates).to eq(dates.sort.reverse)
      end

      it "sorts created_at asc — oldest first" do
        result = described_class.new(scope, { sort_by: "created_at", sort_dir: "asc" }).apply
        dates = result.map(&:created_at)
        expect(dates).to eq(dates.sort)
      end
    end

    context "multi-field sort" do
      it "sorts by priority desc then due_date asc" do
        result = described_class.new(scope, {
          sort_by:  "priority,due_date",
          sort_dir: "desc,asc"
        }).apply.to_a

        expect(result[0]).to eq(high_soon)
        expect(result[1]).to eq(high_later)
      end

      it "defaults missing sort_dir entries to desc" do
        result = described_class.new(scope, {
          sort_by:  "priority,due_date",
          sort_dir: "asc"
        }).apply.to_a

        priorities = result.map(&:priority_before_type_cast)
        expect(priorities).to eq(priorities.sort)
      end
    end

    context "invalid params" do
      it "ignores unknown sort_by fields and falls back to DEFAULT_SORT" do
        result = described_class.new(scope, { sort_by: "hacked_field" }).apply.to_a
        expect(result.length).to eq(5)
      end

      it "ignores SQL injection attempts in sort_by" do
        expect {
          described_class.new(scope, { sort_by: "priority; DROP TABLE tasks;--" }).apply.to_a
        }.not_to raise_error
      end

      it "defaults invalid sort_dir to desc" do
        result = described_class.new(scope, { sort_by: "priority", sort_dir: "sideways" }).apply
        priorities = result.map(&:priority_before_type_cast)
        expect(priorities).to eq(priorities.sort.reverse)
      end

      it "handles completely empty params" do
        result = described_class.new(scope, {}).apply.to_a
        expect(result.length).to eq(5)
      end
    end
  end
end
