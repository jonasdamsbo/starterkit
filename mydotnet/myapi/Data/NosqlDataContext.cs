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
		//public IMongoCollection<ExampleNavigationProperty> ExampleNavigationProperties { get; set; } = null!;

		public NosqlDataContext(IOptions<NosqlDataContext> nosqlDataContextOptions)
		{
			NosqlDataContextOptions = nosqlDataContextOptions;
			MongoClient = new MongoClient(NosqlDataContextOptions.Value.ConnectionString);
			MongoDatabase = MongoClient.GetDatabase(NosqlDataContextOptions.Value.DatabaseName);

			ExampleModels = MongoDatabase.GetCollection<ExampleModel>("ExampleModels");
			//ExampleNavigationProperties = MongoDatabase.GetCollection<ExampleNavigationProperty>("ExampleNavigationProperties");

			//ExampleCollection = MongoDatabase.GetCollection<NosqlExampleModel>(NosqlDataContextOptions.Value.ExampleCollectionName);
		}

		public void Initialize()
		{
			// col1
			//var col = MongoClient.GetDatabase(NosqlDataContextOptions.Value.DatabaseName).GetCollection<ExampleModel>("ExampleModels");

			if (ExampleModels.Find(_ => true).ToListAsync().Result.IsNullOrEmpty())
			{
				var data = new List<ExampleModel> {
					new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), 
						Title = "First project", 
						Description = "Alot of fun", 
						WebUrl = "google.dk", 
						ExampleNavigationProperty = new List<ExampleNavigationProperty>() },
					new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), 
						Title = "Second project", 
						Description = "Alot of fun", 
						WebUrl = "google.dk", 
						ExampleNavigationProperty = new List<ExampleNavigationProperty>() },
					new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), 
						Title = "Third project", 
						Description = "Alot of fun", 
						WebUrl = "google.dk",
						ExampleNavigationProperty = new List<ExampleNavigationProperty>() }
				};

				data[0].ExampleNavigationProperty.Add(new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "First navprop", ExampleModelId = data[0].Id });
				data[0].ExampleNavigationProperty.Add(new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "Second navprop", ExampleModelId = data[0].Id });
				data[1].ExampleNavigationProperty.Add(new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "Third navprop", ExampleModelId = data[1].Id });

				//ExampleModels.InsertManyAsync(data);
				var result = ExampleModels.InsertManyAsync(data);
			}

			// col2
			//var col2 = MongoClient.GetDatabase(NosqlDataContextOptions.Value.DatabaseName).GetCollection<ExampleNavigationProperty>("ExampleNavigationProperties");

			//if (ExampleNavigationProperties.Find(_ => true).ToListAsync().Result.IsNullOrEmpty())
			//{
			//	var data = new List<ExampleNavigationProperty> {
			//		new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "First navprop" },
			//		new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "Second navprop" },
			//		new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "Third navprop" }
			//	};
			//	//ExampleModels.InsertManyAsync(data);
			//	var result = ExampleNavigationProperties.InsertManyAsync(data);
			//}
		}

		//public string ExampleCollectionName { get; set; } = null!;
		//public IMongoCollection<ExampleModel> ExampleCollection { get; set; } = null!;
	}
}
