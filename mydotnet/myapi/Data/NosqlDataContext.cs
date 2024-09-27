using Microsoft.Extensions.Options;
using MongoDB.Driver;
using myshared.Models;

namespace myapi.Data
{
	public class NosqlDataContext
	{
		public string ConnectionString { get; set; } = null!;

		public string DatabaseName { get; set; } = null!;

		//public string ExampleCollectionName { get; set; } = null!;

		public IOptions<NosqlDataContext> NosqlDataContextOptions { get; set; } = null!;

		public MongoClient MongoClient { get; set; } = null!;

		public IMongoDatabase MongoDatabase { get; set; } = null!;

		public string ExampleCollectionName { get; set; } = null!;
		public IMongoCollection<NosqlExampleModel> ExampleCollection { get; set; } = null!;

		public NosqlDataContext(
			IOptions<NosqlDataContext> nosqlDataContextOptions)
		{
			NosqlDataContextOptions = nosqlDataContextOptions;
			MongoClient = new MongoClient(NosqlDataContextOptions.Value.ConnectionString);
			MongoDatabase = MongoClient.GetDatabase(NosqlDataContextOptions.Value.DatabaseName);

			ExampleCollection = MongoDatabase.GetCollection<NosqlExampleModel>(NosqlDataContextOptions.Value.ExampleCollectionName);
		}

		//public IMongoCollection<NosqlExampleModel> GetNosqlExampleCollection()
		//{
		//	var nosqlExampleCollection = MongoDatabase.GetCollection<NosqlExampleModel>(NosqlDataContextOptions.Value.ExampleCollectionName);

		//	return nosqlExampleCollection;
		//}
	}
}
