using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;

namespace myapi.Repositories
{
	public class ExampleNosqlRepository
	{
		private readonly NosqlDataContext _context;

		public ExampleNosqlRepository(NosqlDataContext context)
		{
			_context = context;
		}

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = await _context.ExampleModels.Find(_ => true).ToListAsync();

				if (examples is null) return new List<ExampleModel>();

				return examples;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleModel> GetByIdAsync(string id)
		{
			try
			{
				var example = await _context.ExampleModels.Find(x => x.Id == id.ToString()).FirstOrDefaultAsync();

				if (example is null) return new ExampleModel();

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
				newModel.Id = ObjectId.GenerateNewId().ToString();
				await _context.ExampleModels.InsertOneAsync(newModel);

				var example = await GetByIdAsync(newModel.Id);

				if (example is null) return new ExampleModel();

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

				if (example is null) return new ExampleModel();

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

				if (example is null) return new ExampleModel();

				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		// ### nosql repo simple version: ###

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
