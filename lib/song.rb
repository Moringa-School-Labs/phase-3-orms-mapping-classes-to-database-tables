class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil) #A song gets an id only when it gets saved into the database thats why we are setting the default value to nil.
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    # Create table called songs for class Song
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  #Inserting data into a table with the #save method
  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    #insert the song
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end
