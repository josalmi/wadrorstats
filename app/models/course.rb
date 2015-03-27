class Course < ActiveRecord::Base
  after_initialize :init
  has_many :submissions
  has_many :week_statistics
  has_many :feedbacks

  serialize :weeks

  def self.current
    Course.last
  end

  def take_into_account_in_stats(submission)
    week_stats = week_statistics.find_by(week:submission.week)
    week_stats.take_into_account(submission)
    week_stats.save
  end

  def update_stats_with(new_submission, old_submission)
    week_stats = week_statistics.find_by(week:new_submission.week)
    week_stats.update_with(new_submission, old_submission)
    week_stats.save
  end

  def to_s
    "#{name} #{term}"
  end

  def stats_for_weeks
    return 0 if week_statistics.nil? or week_statistics.empty?
    week_statistics.map(&:week).min
  end

  def week1
    weeks[0]
  end

  def week2
    weeks[1]
  end

  def week3
    weeks[2]
  end

  def week4
    weeks[3]
  end

  def week5
    weeks[4]
  end

  def week6
    weeks[5]
  end

  def week7
    weeks[6]
  end

  def exercises_at_week(week)
    weeks[week-1].to_i
  end

  def exercises_max
    (1..7).map{ |w| exercises_at_week(w) }.sort.last
  end

  private

    def init
      self.weeks ||= [0,0,0,0,0,0,0]
      self.current_week ||= 1
    end
end
