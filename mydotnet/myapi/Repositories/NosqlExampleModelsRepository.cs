using Microsoft.Extensions.Options;
using myshared.Models;
using MongoDB.Driver;

namespace myapi.Repositories
{
	public class NosqlExampleModelsRepository : INosqlExampleModelsRepository
	{
		private readonly IMongoCollection<NosqlExampleModel> _nosqlExampleCollection;

		public NosqlExampleModelsRepository(
			IOptions<NosqlExampleDatabaseSettings> nosqlExampleDatabaseSettings)
		{
			var mongoClient = new MongoClient(
				nosqlExampleDatabaseSettings.Value.ConnectionString);

			var mongoDatabase = mongoClient.GetDatabase(
				nosqlExampleDatabaseSettings.Value.DatabaseName);

			_nosqlExampleCollection = mongoDatabase.GetCollection<NosqlExampleModel>(
				nosqlExampleDatabaseSettings.Value.ExampleCollectionName);
		}

		//public async Task<List<NosqlExampleModel>> GetAllAsync() =>
		//	await _nosqlExampleCollection.Find(_ => true).ToListAsync();

		//public async Task<NosqlExampleModel> GetByIdAsync(int id) =>
		//	await _nosqlExampleCollection.Find(x => x.Id == id).FirstOrDefaultAsync();

		//public async Task AddAsync(NosqlExampleModel newModel) =>
		//	await _nosqlExampleCollection.InsertOneAsync(newModel);

		//public async Task UpdateAsync(int id, NosqlExampleModel updatedModel) =>
		//	await _nosqlExampleCollection.ReplaceOneAsync(x => x.Id == id, updatedModel);

		//public async Task DeleteAsync(int id) =>
		//	await _nosqlExampleCollection.DeleteOneAsync(x => x.Id == id);

		public async Task<List<NosqlExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = await _nosqlExampleCollection.Find(_ => true).ToListAsync();
				return examples;
			}
			catch (Exception ex)
			{
				return new List<NosqlExampleModel>();
				//throw;
			}
		}

		public async Task<NosqlExampleModel> GetByIdAsync(int id)
		{
			try
			{
				var example = await _nosqlExampleCollection.Find(x => x.Id == id).FirstOrDefaultAsync();
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}
			

		public async Task<NosqlExampleModel> AddAsync(NosqlExampleModel newModel)
		{
			try
			{
				await _nosqlExampleCollection.InsertOneAsync(newModel);
				var example = await GetByIdAsync(newModel.Id);
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<NosqlExampleModel> UpdateAsync(int id, NosqlExampleModel updatedModel)
		{
			try
			{
				await _nosqlExampleCollection.ReplaceOneAsync(x => x.Id == id, updatedModel);
				var example = await GetByIdAsync(id);
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}
			

		public async Task<NosqlExampleModel> DeleteAsync(int id)
		{
			try
			{
				var example = await GetByIdAsync(id);
				if (example != null)
				{
					await _nosqlExampleCollection.DeleteOneAsync(x => x.Id == id);
				}
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}
	}
}


	
