using Microsoft.Extensions.Options;
using myshared.Models;
using MongoDB.Driver;
using myapi.Data;

namespace myapi.Repositories
{
	public class NosqlExampleModelRepository : INosqlExampleModelRepository
	{
		private readonly NosqlDataContext _context;

		public NosqlExampleModelRepository(NosqlDataContext context)
		{
			_context = context;
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
				var examples = await _context.ExampleCollection.Find(_ => true).ToListAsync();
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
				var example = await _context.ExampleCollection.Find(x => x.Id == id).FirstOrDefaultAsync();
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
				await _context.ExampleCollection.InsertOneAsync(newModel);
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
				var example = await GetByIdAsync(id);
				if (example != null)
				{
					await _context.ExampleCollection.ReplaceOneAsync(x => x.Id == id, updatedModel);
					example = await GetByIdAsync(id);
				}
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
					await _context.ExampleCollection.DeleteOneAsync(x => x.Id == id);
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


	
