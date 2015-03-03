class User
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    user_result = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id
    SQL

    User.new(user_result[0])
  end

  def self.find_by_name(fname, lname)
    user_result = QuestionsDatabase.instance.execute(<<-SQL, :first => fname, :last => lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :first AND lname = :last
    SQL

    User.new(user_result[0])
  end

  def initialize(user_hash)
    @id, @fname, @lname = user_hash.values_at('id', 'fname', 'lname')
  end
end