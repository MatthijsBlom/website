class User::InsidersStatus::Activate
  include Mandate

  initialize_with :user

  def call
    user.with_lock do
      return unless %i[eligible eligible_lifetime].include?(user.insiders_status)

      if user.insiders_status == :eligible
        user.update(insiders_status: :active)
        User::Notification::Create.(user, :joined_insiders)
      else
        user.update(insiders_status: :active_lifetime)
        User::Notification::Create.(user, :joined_lifetime_insiders)
      end

      AwardBadgeJob.perform_later(user, :insider)
    end
  end
end
