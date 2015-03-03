class QuestionLike
  attr_accessor :id, :question_id, :user_id
  def self.find_by_id(id)
    like_result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
    SQL

    QuestionLike.new(like_result[0])
  end

  def initialize(like_hash)
    @id, @question_id, @user_id = like_hash.values_at('id', 'question_id', 'user_id')
  end
end
