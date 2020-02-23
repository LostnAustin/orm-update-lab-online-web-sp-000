require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id= nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY key,
    name TEXT,
    grade INTEGER
    )
    SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
        SQL
        DB[:conn].execute(sql)
  end

  def save
    if self.id
      sql = <<-SQL
      UPDATE students SET name = ?, grade = ?
      WHERE id = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?,?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

    def self.create(name, grade)
        student = Student.new(name, grade)
        student.save
        student
    end

    def self.new_from_db(array)
      id = array[0]
      name = array[1]
      grade = array[2]
      new_student = self.new(id, name, grade)
      new_student
    end

    def self.find_by_name(name)
      sql = <<-SQL
        SELECT * FROM students
         WHERE name = ?
         LIMIT 1
         SQL
        DB[:conn].execute(sql, name).map do |row|
          self.new_from_db(row)
        end.first
      end

      def update
        sql = <<-SQL
        UPDATE students SET name = ?, grade = ?
        WHERE id = ?
        SQL
        DB[:conn].execute(sql, self.name, self.grade, self.id)
      end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
