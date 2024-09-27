using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Repositories
{
	public class MssqlExampleModelRepository : IMssqlExampleModelRepository
	{
		private readonly MssqlDataContext _context;

		public MssqlExampleModelRepository(MssqlDataContext context)
		{
			_context = context;
		}

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = await _context.ExampleModels.ToListAsync();
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
				var example = await _context.ExampleModels.FindAsync(id);
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
				_context.Add(newModel);
				await _context.SaveChangesAsync();
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
					example.Title = updatedModel.Title;
					example.Description = updatedModel.Description;

					await _context.SaveChangesAsync();
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
					_context.ExampleModels.Remove(example);
					await _context.SaveChangesAsync();
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
