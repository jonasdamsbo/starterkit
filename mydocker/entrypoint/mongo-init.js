db = connect( 'mongodb://sa:P@ssw0rd@localhost:27017' );

db = db.getSiblingDB('mydb');

db.createCollection('portfolioProject');

db.portfolioProject.insertMany( [
   {
      title: 'title1',
      description: 'some description',
      weburl: 'weburl@example.com'
   },
   {
    title: 'title2',
    description: 'some description',
    weburl: 'weburl@example.com'
   },
   {
    title: 'title3',
    description: 'some description',
    weburl: 'weburl@example.com'
   }
] )
