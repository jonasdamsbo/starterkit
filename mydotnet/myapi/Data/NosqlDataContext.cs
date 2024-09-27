using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
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

		//public string ExampleCollectionName { get; set; } = null!;
		//public IMongoCollection<ExampleModel> ExampleCollection { get; set; } = null!;
	}
}
