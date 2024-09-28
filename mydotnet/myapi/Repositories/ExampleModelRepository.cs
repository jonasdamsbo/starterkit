using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;

namespace myapi.Repositories
{
	public class ExampleModelRepository// : IRepository
	{
		//private readonly MssqlDataContext _context;
		//private readonly NosqlDataContext _context;
		private readonly dynamic _context;

		// repo is database agnostic, flip to use nosql/mssql database
		public ExampleModelRepository(MssqlDataContext context/*MssqlDataContext context*//*NosqlDataContext context*/)
		{
			_context = context;
		}

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = new List<ExampleModel>();

				//examples = await _context.ExampleModels.ToListAsync();
				//examples = await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ToListAsync();
				if (_context is MssqlDataContext)
				{
					examples = await (_context as MssqlDataContext).ExampleModels.ToListAsync();
				}
				else examples = await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ToListAsync();

				if(examples is null) return new List<ExampleModel>();

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
				ExampleModel example = new ExampleModel();

				//example = await _context.ExampleModels.FindAsync(id);
				//example = await _context.ExampleModels.Find(x => x.Id == id.ToString()).FirstOrDefaultAsync();
				if (_context is MssqlDataContext)
				{
					example = await (_context as MssqlDataContext).ExampleModels.FindAsync(id);
				}
				else example = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == id.ToString()).FirstOrDefaultAsync();

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
				/*newModel.Id = ObjectId.GenerateNewId().ToString();
				_context.Add(newModel);
				await _context.SaveChangesAsync();*/
				//await _context.ExampleModels.InsertOneAsync(newModel);
				newModel.Id = ObjectId.GenerateNewId().ToString();
				if (_context is MssqlDataContext)
				{
					(_context as MssqlDataContext).Add(newModel);
					await (_context as MssqlDataContext).SaveChangesAsync();
				}
				else await (_context as NosqlDataContext).ExampleModels.InsertOneAsync(newModel);

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
					/*example.Title = updatedModel.Title;
					example.Description = updatedModel.Description;
					await _context.SaveChangesAsync();*/
					//await _context.ExampleModels.ReplaceOneAsync(x => x.Id == id.ToString(), updatedModel);
					if (_context is MssqlDataContext)
					{
						example.Title = updatedModel.Title;
						example.Description = updatedModel.Description;

						await (_context as MssqlDataContext).SaveChangesAsync();
					}
					else await (_context as NosqlDataContext).ExampleModels.ReplaceOneAsync(x => x.Id == id.ToString(), updatedModel);

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
					/*_context.ExampleModels.Remove(example);
					await _context.SaveChangesAsync();*/
					//await _context.ExampleModels.DeleteOneAsync(x => x.Id == id.ToString());
					if (_context is MssqlDataContext)
					{
						_context.ExampleModels.Remove(example);
						await (_context as MssqlDataContext).SaveChangesAsync();
					}
					else await (_context as NosqlDataContext).ExampleModels.DeleteOneAsync(x => x.Id == id.ToString());
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
