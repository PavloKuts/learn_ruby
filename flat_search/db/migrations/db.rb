require_relative '../../lib/flat_search'

class DbMigation
  def self.execute
    db = SQLite3::Database.new AdsSQLiteCache::CACHE_DEFAULT_PATH

    # CREATE ADS TABLE
    db.execute <<-SQL
      CREATE TABLE ads (
        id INTEGER PRIMARY KEY AUTOINCREMENT      NOT NULL,
        text TEXT                                 NOT NULL,
        url VARCHAR(2000)                         NOT NULL,
        date DATE DEFAULT CURRENT_DATE            NOT NULL
      );
    SQL

    db.execute <<-SQL
      CREATE UNIQUE INDEX ads_url_index
      ON ads (url);
    SQL

    # CREATE PHONES TABLE
    db.execute <<-SQL
      CREATE TABLE phones (
        id INTEGER PRIMARY KEY AUTOINCREMENT    NOT NULL,
        phone VARCHAR(10)                       NOT NULL
      );
    SQL

    db.execute <<-SQL
      CREATE UNIQUE INDEX phones_index
      ON phones (phone);
    SQL

    db.execute <<-SQL
      CREATE TABLE ads_phones (
        id INTEGER PRIMARY KEY AUTOINCREMENT     NOT NULL,
        ad_id INTEGER                            NOT NULL,
        phone_id INTEGER                         NOT NULL,
        FOREIGN KEY(ad_id) REFERENCES ads(id),
        FOREIGN KEY(phone_id) REFERENCES phones(id),
        UNIQUE(ad_id, phone_id) ON CONFLICT IGNORE
      );
    SQL
  end
end
