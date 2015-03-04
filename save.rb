module SaveObject
  def save
    pre_vars = self.instance_variables.drop(1)
    vals = pre_vars.map do |var|
      '"' + self.instance_variable_get(var).to_s + '"'
    end
    vars = pre_vars.map { |var| var.to_s[1..-1] }

    if id.nil?
      insert_row(vars, vals)
    else
      update_row(vars, vals)
    end
  end

  def insert_row(vars, vals)
    QuestionsDatabase.instance.execute(<<-SQL)
      INSERT INTO
        #{self.class.table_name}
        (#{vars.join(', ')})
      VALUES
        (#{vals.join(', ')})
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update_row(vars, vals)
    var_val_pairs = vars.zip(vals).map { |pair| pair.join(' = ')}.join(', ')
    QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      UPDATE
        #{self.class.table_name}
      SET
        #{var_val_pairs}
      WHERE
        id = :id
    SQL
  end
end
