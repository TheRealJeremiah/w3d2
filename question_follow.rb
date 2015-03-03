require_relative 'classes'

class QuestionFollow
  attr_accessor :id, :question_id, :user_id
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
    SQL

    QuestionFollow.new(result[0])
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :question_id => question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users
        ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = :question_id
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :user_id => user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions
        ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = :user_id
    SQL

    results.map { |result| Question.new(result) }
  end

  def initialize(follow_hash)
    @id, @question_id, @user_id = follow_hash.values_at('id', 'question_id', 'user_id')
  end
end
