using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using MongoDB.Bson;
using MongoDB.Driver;
using myshared.Models;

namespace myapi.Data
{
	public class NosqlDataContext
	{
		public NosqlDataContext() : base()
		{
		}

		public string ConnectionString { get; set; } = null!;

		public string DatabaseName { get; set; } = null!;

		public IOptions<NosqlDataContext> NosqlDataContextOptions { get; set; } = null!;

		public MongoClient MongoClient { get; set; } = null!;

		public IMongoDatabase MongoDatabase { get; set; } = null!;

		public IMongoCollection<ExampleModel> ExampleModels { get; set; } = null!;

		public NosqlDataContext(IOptions<NosqlDataContext> nosqlDataContextOptions)
		{
			NosqlDataContextOptions = nosqlDataContextOptions;
			MongoClient = new MongoClient(NosqlDataContextOptions.Value.ConnectionString);
			MongoDatabase = MongoClient.GetDatabase(NosqlDataContextOptions.Value.DatabaseName);

			ExampleModels = MongoDatabase.GetCollection<ExampleModel>("ExampleModels");

			//ExampleCollection = MongoDatabase.GetCollection<NosqlExampleModel>(NosqlDataContextOptions.Value.ExampleCollectionName);
		}

		public async void CheckNosqlDbState()
		{
			var col = MongoClient.GetDatabase(NosqlDataContextOptions.Value.DatabaseName).GetCollection<ExampleModel>("ExampleModels");

			if (col.Find(_ => true).ToListAsync().Result.IsNullOrEmpty())
			{
				var data = new List<ExampleModel> {
					new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), Title = "First project", Description = "Alot of fun", WebUrl = "google.dk" },
					new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), Title = "Second project", Description = "Alot of fun", WebUrl = "google.dk" },
					new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), Title = "Third project", Description = "Alot of fun", WebUrl = "google.dk" }
				};
				//ExampleModels.InsertManyAsync(data);
				var result = col.InsertManyAsync(data);
			}
			else
			{

			}
		}

		//public string ExampleCollectionName { get; set; } = null!;
		//public IMongoCollection<ExampleModel> ExampleCollection { get; set; } = null!;
	}
}
