require "test_helper"

class AssembleExerciseRepresentationsWithoutFeedbackTest < ActiveSupport::TestCase
  test "index should return top 20 serialized correctly" do
    track = create :track
    user = create :user
    create(:user_track_mentorship, user:, track:)
    exercise = create(:practice_exercise, track:)
    representations = Array.new(25) do |idx|
      create(:exercise_representation, num_submissions: 25 - idx, feedback_type: nil, exercise:,
        last_submitted_at: Time.utc(2022, 3, 15) - idx.days, track:)
    end
    params = { track_slug: track.slug }

    paginated_representations = Kaminari.paginate_array(representations, total_count: 24).page(1).per(20)
    expected = SerializePaginatedCollection.(
      paginated_representations,
      serializer: SerializeExerciseRepresentations,
      serializer_kwargs: { params: },
      meta: {
        # TODO: fix performance
        unscoped_total: 0
        # unscoped_total: 25
      }
    )

    assert_equal expected, AssembleExerciseRepresentationsWithoutFeedback.(user, params)
  end

  test "should proxy correctly" do
    track = create :track
    mentor = create :user
    criteria = 'bob'
    order = 'num_submissions'
    page = '1'
    only_mentored_solutions = true

    Exercise::Representation::Search.expects(:call).with(
      with_feedback: false,
      mentor:,
      track:,
      page:,
      order:,
      criteria:,
      only_mentored_solutions:
    ).returns(Exercise::Representation.page(1).per(20))

    AssembleExerciseRepresentationsWithoutFeedback.(mentor,
      { track_slug: track.slug, criteria:, order:, page:, only_mentored_solutions: })
  end
end
