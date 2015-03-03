class QuestionFollow
  attr_accessor :id, :question_id, :user_id
  def self.find_by_id(id)
    follow_result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
    SQL

    QuestionFollow.new(follow_result[0])
  end

  def initialize(follow_hash)
    @id, @question_id, @user_id = follow_hash.values_at('id', 'question_id', 'user_id')
  end
end
