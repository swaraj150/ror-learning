require "rails_helper"

RSpec.describe TaskFilter, type: :service do
  let(:user)  { create(:user) }
  let(:scope) { user.tasks }

  let!(:todo_high)       { create(:task, user: user, status: "todo",        priority: :high,   title: "Fix critical bug")      }
  let!(:todo_low)        { create(:task, user: user, status: "todo",        priority: :low,    title: "Buy office supplies")   }
  let!(:in_progress_med) { create(:task, user: user, status: "in_progress", priority: :medium, title: "Write documentation")   }
  let!(:completed_high)  { create(:task, user: user, status: "completed",   priority: :high,   title: "Deploy to production")  }
  let!(:todo_med)        { create(:task, user: user, status: "todo",        priority: :medium, title: "Fix UI bug in reports") }

  describe "#apply" do
    context "with no params" do
      it "returns all tasks unfiltered" do
        result = described_class.new(scope, {}).apply
        expect(result.count).to eq(5)
      end
    end
  end

  describe "#filter_by_status" do
    it "returns tasks with a single status" do
      result = described_class.new(scope, { status: [ "todo" ] }).apply
      expect(result.map(&:status).uniq).to eq([ "todo" ])
      expect(result.count).to eq(3)
    end

    it "returns tasks matching multiple statuses" do
      result = described_class.new(scope, { status: [ "todo", "in_progress" ] }).apply
      expect(result.map(&:status).uniq).to match_array(%w[todo in_progress])
    end

    it "is case insensitive" do
      result = described_class.new(scope, { status: [ "TODO", "In_Progress" ] }).apply
      expect(result.map(&:status).uniq).to match_array(%w[todo in_progress])
    end

    it "ignores invalid status values" do
      result = described_class.new(scope, { status: [ "invalid_status" ] }).apply
      expect(result.count).to eq(5)   # no filter applied
    end

    it "handles nil status without crashing" do
      expect {
        described_class.new(scope, { status: nil }).apply
      }.not_to raise_error
    end

    it "handles missing status key without crashing" do
      expect {
        described_class.new(scope, {}).apply
      }.not_to raise_error
    end

    it "returns no tasks when status matches nothing" do
      result = described_class.new(scope, { status: [ "archived" ] }).apply
      expect(result.count).to eq(5)   # invalid — no filter applied
    end
  end

  describe "#filter_by_priority" do
    it "returns tasks with a single priority" do
      result = described_class.new(scope, { priority: [ "high" ] }).apply
      expect(result).to match_array([ todo_high, completed_high ])
    end

    it "returns tasks matching multiple priorities" do
      result = described_class.new(scope, { priority: [ "low", "medium" ] }).apply
      expect(result).to match_array([ todo_low, in_progress_med, todo_med ])
    end

    it "is case insensitive" do
      result = described_class.new(scope, { priority: [ "HIGH" ] }).apply
      expect(result).to match_array([ todo_high, completed_high ])
    end

    it "ignores invalid priority values" do
      result = described_class.new(scope, { priority: [ "urgent" ] }).apply
      expect(result.count).to eq(5)
    end

    it "handles nil priority without crashing" do
      expect {
        described_class.new(scope, { priority: nil }).apply
      }.not_to raise_error
    end
  end

  describe "#search_by_title" do
    it "returns tasks with matching title substring" do
      result = described_class.new(scope, { search: "bug" }).apply
      expect(result).to match_array([ todo_high, todo_med ])
    end

    it "is case insensitive via ILIKE" do
      result = described_class.new(scope, { search: "FIX" }).apply
      expect(result).to match_array([ todo_high, todo_med ])
    end

    it "returns all tasks when search is blank" do
      result = described_class.new(scope, { search: "" }).apply
      expect(result.count).to eq(5)
    end

    it "returns all tasks when search is nil" do
      result = described_class.new(scope, { search: nil }).apply
      expect(result.count).to eq(5)
    end

    it "returns empty when search matches nothing" do
      result = described_class.new(scope, { search: "xyznonexistent" }).apply
      expect(result).to be_empty
    end

    it "sanitizes SQL LIKE special characters" do
      create(:task, user: user, title: "100% done", status: :todo)
      create(:task, user: user, title: "pay_roll task", status: :todo)

      result = described_class.new(scope, { search: "100%" }).apply
      expect(result.map(&:title)).to eq([ "100% done" ])

      result = described_class.new(scope, { search: "pay_roll" }).apply
      expect(result.map(&:title)).to eq([ "pay_roll task" ])
    end
  end

  describe "combined filters" do
    it "combines status and priority" do
      result = described_class.new(scope, {
        status:   [ "todo" ],
        priority: [ "high" ]
      }).apply

      expect(result).to match_array([ todo_high ])
    end

    it "combines status and search" do
      result = described_class.new(scope, {
        status: [ "todo" ],
        search: "bug"
      }).apply

      expect(result).to match_array([ todo_high, todo_med ])
    end

    it "combines priority and search" do
      result = described_class.new(scope, {
        priority: [ "high" ],
        search:   "fix"
      }).apply

      expect(result).to match_array([ todo_high ])
    end

    it "combines all three filters" do
      result = described_class.new(scope, {
        status:   [ "todo" ],
        priority: [ "medium" ],
        search:   "reports"
      }).apply

      expect(result).to match_array([ todo_med ])
    end

    it "returns empty when combined filters match nothing" do
      result = described_class.new(scope, {
        status:   [ "completed" ],
        priority: [ "low" ]
      }).apply

      expect(result).to be_empty
    end
  end

  describe "other user isolation" do
    it "never returns tasks belonging to another user" do
      other_user = create(:user)
      create(:task, user: other_user, status: "todo", priority: :high, title: "Fix bug")

      result = described_class.new(scope, { search: "fix" }).apply
      expect(result.map(&:user_id).uniq).to eq([ user.id ])
    end
  end
end
