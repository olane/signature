% DATABASE TOOLBOX METHOD

db_loc = '/Users/olane/proj/experiments/test.db';

db_url = ['jdbc:sqlite:' db_loc];

dbpath = '';
username = '';
pwd = '';


conn = database(dbpath, username, pwd, 'org.sqlite.JDBC', db_url)

colnames = {'productNumber','Quantity','Price'};

data = {50 100 15.50};

tablename = 'inventoryTable';

datainsert(conn,tablename,colnames,data) 

close(conn);


%%

% matlab-sqlite3-driver method
% https://github.com/kyamagu/matlab-sqlite3-driver
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

sqlite3.open('test.db');
sqlite3.execute('CREATE TABLE records (id INTEGER, name VARCHAR)');
sqlite3.execute('INSERT INTO records VALUES (?, ?)', 1, 'foo');
sqlite3.execute('INSERT INTO records VALUES (?, ?)', 2, 'bar');
records = sqlite3.execute('SELECT * FROM records WHERE id < ?', 10)
result = sqlite3.execute('SELECT COUNT(*) FROM records')
sqlite3.close();

delete('test.db');