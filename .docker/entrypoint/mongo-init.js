db = connect( 'mongodb://sa:P@ssw0rd@localhost:27017' );

db = db.getSiblingDB('mydb');

db.createCollection('ExampleModels');

db.ExampleModels.insertMany( [
   {
      Title: 'title1',
      Description: 'some description',
      Weburl: 'weburl@example.com'
   },
   {
    Title: 'title2',
    Description: 'some description',
    Weburl: 'weburl@example.com'
   },
   {
    Title: 'title3',
    Description: 'some description',
    Weburl: 'weburl@example.com'
   }
] )
