using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;

namespace myapi.Repositories
{
	public class ExampleModelRepository// : IRepository // Combined to be nosql/mssql agnostic
	{
		//private readonly MssqlDataContext _context;
		//private readonly NosqlDataContext _context;
		private readonly dynamic _context;
		private ILogger<ExampleNavigationPropertyRepository> _log;

		// repo is database agnostic, flip to use nosql/mssql database, /*MssqlDataContext context*//*NosqlDataContext context*/
		public ExampleModelRepository(MssqlDataContext context, ILogger<ExampleNavigationPropertyRepository> log)
		{
			_context = context;
			_log = log;
		}

		public async Task<List<ExampleModel>> GetAllAsync()
		{
			try
			{
				//
				_log.LogInformation("### LOG INFORMATION TEST ###");
				_log.LogWarning("### LOG WARNING TEST ###");
				_log.LogError("### LOG ERROR TEST ###");
				//_log.LogInformation("\r\n" + "\r\n" + "### Getting all ExampleModels loginfo ###" + "\r\n");
				//Console.WriteLine("\r\n" + "### Getting all ExampleModels consolelog ###" + "\r\n");
				//var examples = await _context.ExampleModels.ToListAsync();
				//var examples = await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ToListAsync();
				var examples = new List<ExampleModel>();
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
				//_log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/GetAllAsync/line25' --> " + ex.ToString() + " <-- ###" + "\r\n"); // saved to apptracelogs in azure
				//Console.WriteLine("Exception thrown at 'ExampleNavigationPropertyRepository/UpdateAsync/line164': " + ex.ToString()); // shown in app console
				return null;
				//throw;
			}
		}

		public async Task<ExampleModel> GetByIdAsync(string id)
		{
			try
			{

				//
				//var example = await _context.ExampleModels.FindAsync(id);
				//var example = await _context.ExampleModels.Find(x => x.Id == id.ToString()).FirstOrDefaultAsync();
				ExampleModel example = new ExampleModel();
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
				newModel.Id = ObjectId.GenerateNewId().ToString();

				//
				/*_context.Add(newModel);
				await _context.SaveChangesAsync();*/
				//await _context.ExampleModels.InsertOneAsync(newModel);
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

				//
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

				//
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
