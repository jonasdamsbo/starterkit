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

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = await _context.ExampleModels.Find(_ => true).ToListAsync();
				return examples;
			}
			catch (Exception ex)
			{
				return new List<ExampleModel>();
				//throw;
			}
		}

		public async Task<ExampleModel> GetByIdAsync(string id)
		{
			try
			{
				var example = await _context.ExampleModels.Find(x => x.Id == id.ToString()).FirstOrDefaultAsync();
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleModel> AddAsync(ExampleModel newModel)
		{
			try
			{
				await _context.ExampleModels.InsertOneAsync(newModel);

				var example = await GetByIdAsync(newModel.Id);
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleModel> UpdateAsync(string id, ExampleModel updatedModel)
		{
			try
			{
				var example = await GetByIdAsync(id);
				if (example != null)
				{
					await _context.ExampleModels.ReplaceOneAsync(x => x.Id == id.ToString(), updatedModel);
					
					
					
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
			
		public async Task<ExampleModel> DeleteAsync(string id)
		{
			try
			{
				var example = await GetByIdAsync(id);
				if (example != null)
				{
					await _context.ExampleModels.DeleteOneAsync(x => x.Id == id.ToString());

				}
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		// ### simple version: ###

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
	}
}


	
