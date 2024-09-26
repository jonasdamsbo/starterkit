using Microsoft.Extensions.Options;
using myshared.Models;
using MongoDB.Driver;

namespace myapi.Repositories
{
	public class NosqlExampleRepository
	{
		private readonly IMongoCollection<NosqlExampleModel> _nosqlExampleCollection;

		public NosqlExampleRepository(
			IOptions<NosqlExampleDatabaseSettings> nosqlExampleDatabaseSettings)
		{
			var mongoClient = new MongoClient(
				nosqlExampleDatabaseSettings.Value.ConnectionString);

			var mongoDatabase = mongoClient.GetDatabase(
				nosqlExampleDatabaseSettings.Value.DatabaseName);

			_nosqlExampleCollection = mongoDatabase.GetCollection<NosqlExampleModel>(
				nosqlExampleDatabaseSettings.Value.NosqlExampleCollectionName);
		}

		public async Task<List<NosqlExampleModel>> GetAsync() =>
			await _nosqlExampleCollection.Find(_ => true).ToListAsync();

		public async Task<NosqlExampleModel?> GetAsync(int id) =>
			await _nosqlExampleCollection.Find(x => x.Id == id).FirstOrDefaultAsync();

		public async Task CreateAsync(NosqlExampleModel newModel) =>
			await _nosqlExampleCollection.InsertOneAsync(newModel);

		public async Task UpdateAsync(int id, NosqlExampleModel updatedModel) =>
			await _nosqlExampleCollection.ReplaceOneAsync(x => x.Id == id, updatedModel);

		public async Task RemoveAsync(int id) =>
			await _nosqlExampleCollection.DeleteOneAsync(x => x.Id == id);
	}
}


	
