require_relative 'classes'

class QuestionLike
  attr_accessor :id, :question_id, :user_id
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
    SQL

    QuestionLike.new(result[0])
  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :question_id => question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = :question_id
    SQL

    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, :question_id => question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = :question_id
    SQL
    result[0]['COUNT(*)']
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, :user_id => user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = :user_id
    SQL

    results.map { |result| Question.new(result)}
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, :num => n)
      SELECT
        questions.*
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.user_id)
      LIMIT
        :num
    SQL

    results.map { |result| Question.new(result)}
  end

  def initialize(like_hash)
    @id, @question_id, @user_id = like_hash.values_at('id', 'question_id', 'user_id')
  end
end
