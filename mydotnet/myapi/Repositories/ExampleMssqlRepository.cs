using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;

namespace myapi.Repositories
{
	public class ExampleMssqlRepository
	{
		private readonly MssqlDataContext _context;

		public ExampleMssqlRepository(MssqlDataContext context)
		{
			_context = context;
		}

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = await _context.ExampleModels.ToListAsync();

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
				var example = await _context.ExampleModels.FindAsync(id);

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
				_context.Add(newModel);
				await _context.SaveChangesAsync();

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
					example.Title = updatedModel.Title;
					example.Description = updatedModel.Description;

					await _context.SaveChangesAsync();

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
					_context.ExampleModels.Remove(example);
					await _context.SaveChangesAsync();
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
	}
}
