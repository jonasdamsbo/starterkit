using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Repositories
{
	public class ExampleModelRepository// : IRepository
	{
		private readonly dynamic _context;

		public ExampleModelRepository(/*MssqlDataContext context*/NosqlDataContext context) // repo is database agnostic, flip to use nosql/mssql database
		{
			_context = context;
		}

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = new List<ExampleModel>();

				if(_context is MssqlDataContext)
				{
					examples = await (_context as MssqlDataContext).ExampleModels.ToListAsync();
				}
				else examples = await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ToListAsync();

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
				ExampleModel example = new ExampleModel();

				if (_context is MssqlDataContext)
				{
					example = await (_context as MssqlDataContext).ExampleModels.FindAsync(id);
				}
				else example = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == id.ToString()).FirstOrDefaultAsync();

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
				if (_context is MssqlDataContext)
				{
					newModel.Id = ObjectId.GenerateNewId().ToString();
					(_context as MssqlDataContext).Add(newModel);
					await (_context as MssqlDataContext).SaveChangesAsync();
				}
				else await (_context as NosqlDataContext).ExampleModels.InsertOneAsync(newModel);

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
					if (_context is MssqlDataContext)
					{
						example.Title = updatedModel.Title;
						example.Description = updatedModel.Description;

						await (_context as MssqlDataContext).SaveChangesAsync();
					}
					else await (_context as NosqlDataContext).ExampleModels.ReplaceOneAsync(x => x.Id == id.ToString(), updatedModel);

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
					if (_context is MssqlDataContext)
					{
						_context.ExampleModels.Remove(example);
						await (_context as MssqlDataContext).SaveChangesAsync();
					}
					else await (_context as NosqlDataContext).ExampleModels.DeleteOneAsync(x => x.Id == id.ToString());
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
